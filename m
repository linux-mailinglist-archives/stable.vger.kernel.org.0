Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84C0469BBF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347610AbhLFPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36024 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358633AbhLFPQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC6E36131B;
        Mon,  6 Dec 2021 15:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F23FC341C5;
        Mon,  6 Dec 2021 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803594;
        bh=87huGYT6ZRyW4Ks1/jHy46Dc5usVHgQgTTvk8U2HRtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNPMcfnfz7xpAOsOP/YdpBAVlM42YYtRctfP6aJ4n0VY1Srw9KUeY/1oPiQs8zs2x
         UnMV2/zo+L4sblEXiL7tZTjjQ+HDivqTb4SOVyolnWCgdYl9BcI1Ql5aflWM0xzntp
         BMyAf7v/MMXU2wW29e42H51ZGCJtaLVu/+fNI1bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 48/70] net/smc: Keep smc_close_final rc during active close
Date:   Mon,  6 Dec 2021 15:56:52 +0100
Message-Id: <20211206145553.578718155@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

commit 00e158fb91dfaff3f94746f260d11f1a4853506e upstream.

When smc_close_final() returns error, the return code overwrites by
kernel_sock_shutdown() in smc_close_active(). The return code of
smc_close_final() is more important than kernel_sock_shutdown(), and it
will pass to userspace directly.

Fix it by keeping both return codes, if smc_close_final() raises an
error, return it or kernel_sock_shutdown()'s.

Link: https://lore.kernel.org/linux-s390/1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com/
Fixes: 606a63c9783a ("net/smc: Ensure the active closing peer first closes clcsock")
Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_close.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -183,6 +183,7 @@ int smc_close_active(struct smc_sock *sm
 	int old_state;
 	long timeout;
 	int rc = 0;
+	int rc1 = 0;
 
 	timeout = current->flags & PF_EXITING ?
 		  0 : sock_flag(sk, SOCK_LINGER) ?
@@ -222,8 +223,11 @@ again:
 			/* actively shutdown clcsock before peer close it,
 			 * prevent peer from entering TIME_WAIT state.
 			 */
-			if (smc->clcsock && smc->clcsock->sk)
-				rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
+			if (smc->clcsock && smc->clcsock->sk) {
+				rc1 = kernel_sock_shutdown(smc->clcsock,
+							   SHUT_RDWR);
+				rc = rc ? rc : rc1;
+			}
 		} else {
 			/* peer event has changed the state */
 			goto again;


