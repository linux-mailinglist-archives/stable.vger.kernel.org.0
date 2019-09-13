Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2609AB211A
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388969AbfIMNdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387788AbfIMNLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:17 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97413208C2;
        Fri, 13 Sep 2019 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380277;
        bh=PAKaJQyWgyfTcBY6l1xp4O9eU92shj7WJb6AV3Ggkrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYVZ7PdTvHp+g+kAsK8+OpwvXIMBM5zSGQMQxApDLeI+lpnkW7KJmJ/e0vDvO/WR9
         3ZNkZJd/xpvPeJqVZdhkNESABvksFl8o/oxSJK6ib3a4lvajXdpNu6krhP8BbMbsS8
         tRffp5CuleArV8hPJc6fpWMcWiQr4YZ1fQs3KeE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/190] hv_sock: Fix hang when a connection is closed
Date:   Fri, 13 Sep 2019 14:04:28 +0100
Message-Id: <20190913130600.658336649@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 685703b497bacea8765bb409d6b73455b73c540e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/hyperv_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 9c7da811d130f..98f193fd5315e 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -320,6 +320,11 @@ static void hvs_close_connection(struct vmbus_channel *chan)
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
@@ -388,6 +393,9 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 	}
 
 	set_per_channel_state(chan, conn_from_host ? new : sk);
+
+	/* This reference will be dropped by hvs_close_connection(). */
+	sock_hold(conn_from_host ? new : sk);
 	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
 
 	/* Set the pending send size to max packet size to always get
-- 
2.20.1



