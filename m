Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECD247FE99
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhL0PaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34998 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbhL0P37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 403DFB80E5A;
        Mon, 27 Dec 2021 15:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF3AC36AEA;
        Mon, 27 Dec 2021 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618997;
        bh=Vz8vVtXcbEHvRmf7CfHIDvEoOvMdq+KaI3CLJ0RSZik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/MpSQxnI1tE6QparO+8vXIX9z8il04X+tT95q1MkQWuXp5hDGHJM+QM/jjMtDDA5
         J5sCetNXXDprjnB1Iht6MRVdouuwx3/yeuqoi8BhSFIebQrEWVmNgYpBu3JJHLZ9Vr
         3GN7Jcc6HSa3SwJ882l7m34DWTy5O/lhv1RCOEgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjie Wu <nagi@zju.edu.cn>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 26/29] ax25: NPD bug when detaching AX25 device
Date:   Mon, 27 Dec 2021 16:27:36 +0100
Message-Id: <20211227151319.325293247@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 1ade48d0c27d5da1ccf4b583d8c5fc8b534a3ac8 upstream.

The existing cleanup routine implementation is not well synchronized
with the syscall routine. When a device is detaching, below race could
occur.

static int ax25_sendmsg(...) {
  ...
  lock_sock()
  ax25 = sk_to_ax25(sk);
  if (ax25->ax25_dev == NULL) // CHECK
  ...
  ax25_queue_xmit(skb, ax25->ax25_dev->dev); // USE
  ...
}

static void ax25_kill_by_device(...) {
  ...
  if (s->ax25_dev == ax25_dev) {
    s->ax25_dev = NULL;
    ...
}

Other syscall functions like ax25_getsockopt, ax25_getname,
ax25_info_show also suffer from similar races. To fix them, this patch
introduce lock_sock() into ax25_kill_by_device in order to guarantee
that the nullify action in cleanup routine cannot proceed when another
socket request is pending.

Signed-off-by: Hanjie Wu <nagi@zju.edu.cn>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -88,8 +88,10 @@ static void ax25_kill_by_device(struct n
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
-			s->ax25_dev = NULL;
 			spin_unlock_bh(&ax25_list_lock);
+			lock_sock(s->sk);
+			s->ax25_dev = NULL;
+			release_sock(s->sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
 


