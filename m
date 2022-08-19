Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4B659A01C
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352103AbiHSQXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352159AbiHSQVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB164A98F4;
        Fri, 19 Aug 2022 09:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06EB4B8281A;
        Fri, 19 Aug 2022 16:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466A0C433C1;
        Fri, 19 Aug 2022 16:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924962;
        bh=Ue5WTpNkr1YCPFe7K+gnxnV31/gUq1gsXowARGuCpMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5LrtWGYIoTSShYRH4/OaD8fYGqMN6JNAqnn83qQqXNAtVGvX6lRgxy/XKxi1Glph
         I9gM26YsBB8/Ak+XCHscBlegRQzL+A/mZcb8P9FHyOLYENpGIraKq1VNmJe30ut8xy
         lroBuRgdIRGP7GlDvELcWFEgVTWqMCGKvlIFHUZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/545] RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event
Date:   Fri, 19 Aug 2022 17:41:48 +0200
Message-Id: <20220819153844.520448682@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 3056fc6c32e613b760422b94c7617ac9a24a4721 ]

If siw_recv_mpa_rr returns -EAGAIN, it means that the MPA reply hasn't
been received completely, and should not report IW_CM_EVENT_CONNECT_REPLY
in this case. This may trigger a call trace in iw_cm. A simple way to
trigger this:
 server: ib_send_lat
 client: ib_send_lat -R <server_ip>

The call trace looks like this:

 kernel BUG at drivers/infiniband/core/iwcm.c:894!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 <...>
 Workqueue: iw_cm_wq cm_work_handler [iw_cm]
 Call Trace:
  <TASK>
  cm_work_handler+0x1dd/0x370 [iw_cm]
  process_one_work+0x1e2/0x3b0
  worker_thread+0x49/0x2e0
  ? rescuer_thread+0x370/0x370
  kthread+0xe5/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Link: https://lore.kernel.org/r/dae34b5fd5c2ea2bd9744812c1d2653a34a94c67.1657706960.git.chengyou@linux.alibaba.com
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 6e7399c2ca8c..b87ba4c9fccf 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -725,11 +725,11 @@ static int siw_proc_mpareply(struct siw_cep *cep)
 	enum mpa_v2_ctrl mpa_p2p_mode = MPA_V2_RDMA_NO_RTR;
 
 	rv = siw_recv_mpa_rr(cep);
-	if (rv != -EAGAIN)
-		siw_cancel_mpatimer(cep);
 	if (rv)
 		goto out_err;
 
+	siw_cancel_mpatimer(cep);
+
 	rep = &cep->mpa.hdr;
 
 	if (__mpa_rr_revision(rep->params.bits) > MPA_REVISION_2) {
@@ -895,7 +895,8 @@ static int siw_proc_mpareply(struct siw_cep *cep)
 	}
 
 out_err:
-	siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, -EINVAL);
+	if (rv != -EAGAIN)
+		siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, -EINVAL);
 
 	return rv;
 }
-- 
2.35.1



