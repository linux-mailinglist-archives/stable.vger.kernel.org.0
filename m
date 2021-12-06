Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1AF469B9E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356136AbhLFPSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356910AbhLFPPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:15:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393FFC08E8A8;
        Mon,  6 Dec 2021 07:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E836134F;
        Mon,  6 Dec 2021 15:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF57CC341C1;
        Mon,  6 Dec 2021 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803292;
        bh=RozQamQQtRuZSEjp0n1NPClHeyLCJGDs8DRON/hA+wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myodd3KIPH3oOs4UbDCfmiCpAq3Pm44Ag/PwCsyk/UKPVrrc10rGd46IcjTuKmeEZ
         9k+Cu4gjHq5uwLUrL2xwlZEfmJtdsPQeMAQbDEUvNShPiizZFWlLMzhKNSZZC6hfsR
         qcuqTKoYkqjDv+zbFqb4eN05TkNDyP0fdnuHdKac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 096/106] net/smc: Keep smc_close_final rc during active close
Date:   Mon,  6 Dec 2021 15:56:44 +0100
Message-Id: <20211206145558.866211109@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -180,6 +180,7 @@ int smc_close_active(struct smc_sock *sm
 	int old_state;
 	long timeout;
 	int rc = 0;
+	int rc1 = 0;
 
 	timeout = current->flags & PF_EXITING ?
 		  0 : sock_flag(sk, SOCK_LINGER) ?
@@ -219,8 +220,11 @@ again:
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


