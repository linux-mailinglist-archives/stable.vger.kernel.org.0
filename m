Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F7B594328
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245279AbiHOWMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349409AbiHOWL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:11:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4796F11CF03;
        Mon, 15 Aug 2022 12:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5897C611F5;
        Mon, 15 Aug 2022 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0D6C433B5;
        Mon, 15 Aug 2022 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592331;
        bh=RZ0vulzf7UEz5azfjdo4BMoZmo2urF2aS/b4lpbo9RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yePT1WGXAgnryqI8WecNkaihgP+QOVpXkGZliP7smrvwpDi73CRge6x91vosxzcal
         FjsTMu7neln7bIlgJSHZGpjC+++Mn8IkSaIHTp2gLxbbVBN4Egv89prfE0SaXNRV3g
         XjBxxiL+1BJC52DT3basRgDCWqMaWt8xzco3/Nz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0771/1095] RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event
Date:   Mon, 15 Aug 2022 20:02:50 +0200
Message-Id: <20220815180501.144431648@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 17f34d584cd9..f88d2971c2c6 100644
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



