Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF6A86986
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404870AbfHHTIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404866AbfHHTIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14137214C6;
        Thu,  8 Aug 2019 19:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291297;
        bh=GO944Vpxi6hLaivkOV6+1MtsnIIXDbWFeObHenW4B/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMvixmqKajo1TdKFS4lawTp6OtVtUDKxnVXwLE2AiS+O9FNtiPkBXcbDcljji2L5v
         DYzICfUGcfP9+SO+7P7hByjGkl8x3MIzgEW7sju920GW6IVJLCoy7/Tg4HHoq5/IHG
         GiAWVKo2SrJ6nq5ED+R0H/E5T+IHTXB3eFpSpthk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 46/56] hv_sock: Fix hang when a connection is closed
Date:   Thu,  8 Aug 2019 21:05:12 +0200
Message-Id: <20190808190455.008606190@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 8c7885e5690be9a27231ebebf82ef29fbf46c4e4 ]

There is a race condition for an established connection that is being closed
by the guest: the refcnt is 4 at the end of hvs_release() (Note: here the
'remove_sock' is false):

1 for the initial value;
1 for the sk being in the bound list;
1 for the sk being in the connected list;
1 for the delayed close_work.

After hvs_release() finishes, __vsock_release() -> sock_put(sk) *may*
decrease the refcnt to 3.

Concurrently, hvs_close_connection() runs in another thread:
  calls vsock_remove_sock() to decrease the refcnt by 2;
  call sock_put() to decrease the refcnt to 0, and free the sk;
  next, the "release_sock(sk)" may hang due to use-after-free.

In the above, after hvs_release() finishes, if hvs_close_connection() runs
faster than "__vsock_release() -> sock_put(sk)", then there is not any issue,
because at the beginning of hvs_close_connection(), the refcnt is still 4.

The issue can be resolved if an extra reference is taken when the
connection is established.

Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -311,6 +311,11 @@ static void hvs_close_connection(struct
 	lock_sock(sk);
 	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
+
+	/* Release the refcnt for the channel that's opened in
+	 * hvs_open_connection().
+	 */
+	sock_put(sk);
 }
 
 static void hvs_open_connection(struct vmbus_channel *chan)
@@ -378,6 +383,9 @@ static void hvs_open_connection(struct v
 	}
 
 	set_per_channel_state(chan, conn_from_host ? new : sk);
+
+	/* This reference will be dropped by hvs_close_connection(). */
+	sock_hold(conn_from_host ? new : sk);
 	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
 
 	/* Set the pending send size to max packet size to always get


