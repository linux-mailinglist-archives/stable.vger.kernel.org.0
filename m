Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24A75218F5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243803AbiEJNlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244878AbiEJNiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA1D72226;
        Tue, 10 May 2022 06:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1396961767;
        Tue, 10 May 2022 13:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1506DC385A6;
        Tue, 10 May 2022 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189196;
        bh=KROBn0sVKqejLhXC5hNUtuLqTsLA0EpNTTg+h0Jc3Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFDLWD/hOgqlQM+RBOAvutKdLGvSNBPNFwYG6V7mLRHDwdKf5n5JITbUzN4h2DAbx
         dyT2/ystn59Jk4Z/65Kcz/MrMrF6vmoDj1GKakmXl4y03722j9QW4NCelLBlXiJkBM
         t2qVkOTvkL9r+CtgqfA41OYAdg//ErQjz+2mHegY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Cheng Xu <chengyou@linux.alibaba.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 43/70] RDMA/siw: Fix a condition race issue in MPA request processing
Date:   Tue, 10 May 2022 15:08:02 +0200
Message-Id: <20220510130734.122923464@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Xu <chengyou@linux.alibaba.com>

commit ef91271c65c12d36e4c2b61c61d4849fb6d11aa0 upstream.

The calling of siw_cm_upcall and detaching new_cep with its listen_cep
should be atomistic semantics. Otherwise siw_reject may be called in a
temporary state, e,g, siw_cm_upcall is called but the new_cep->listen_cep
has not being cleared.

This fixes a WARN:

  WARNING: CPU: 7 PID: 201 at drivers/infiniband/sw/siw/siw_cm.c:255 siw_cep_put+0x125/0x130 [siw]
  CPU: 2 PID: 201 Comm: kworker/u16:22 Kdump: loaded Tainted: G            E     5.17.0-rc7 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Workqueue: iw_cm_wq cm_work_handler [iw_cm]
  RIP: 0010:siw_cep_put+0x125/0x130 [siw]
  Call Trace:
   <TASK>
   siw_reject+0xac/0x180 [siw]
   iw_cm_reject+0x68/0xc0 [iw_cm]
   cm_work_handler+0x59d/0xe20 [iw_cm]
   process_one_work+0x1e2/0x3b0
   worker_thread+0x50/0x3a0
   ? rescuer_thread+0x390/0x390
   kthread+0xe5/0x110
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x1f/0x30
   </TASK>

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Link: https://lore.kernel.org/r/d528d83466c44687f3872eadcb8c184528b2e2d4.1650526554.git.chengyou@linux.alibaba.com
Reported-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_cm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -968,14 +968,15 @@ static void siw_accept_newconn(struct si
 
 		siw_cep_set_inuse(new_cep);
 		rv = siw_proc_mpareq(new_cep);
-		siw_cep_set_free(new_cep);
-
 		if (rv != -EAGAIN) {
 			siw_cep_put(cep);
 			new_cep->listen_cep = NULL;
-			if (rv)
+			if (rv) {
+				siw_cep_set_free(new_cep);
 				goto error;
+			}
 		}
+		siw_cep_set_free(new_cep);
 	}
 	return;
 


