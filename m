Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF96359DFE6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354303AbiHWKYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355222AbiHWKXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:23:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B6296FCA;
        Tue, 23 Aug 2022 02:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAD69B81C66;
        Tue, 23 Aug 2022 09:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFFC433B5;
        Tue, 23 Aug 2022 09:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245454;
        bh=iEBNwJXJZXuq4CJ5XN0UuXtBxokmOgf2OI7wZs/yPh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ru9QUR2jJ2k1CFuXYihR8xIiJ+M9lagXIpfmzCD2KZeLOhc1xSV7WLBEw1hT6efBV
         G9IKG3BMTpWjkUhp39OeoKBCMLQlRYRPj77gC66z0afdRLg2BWlpYojVkN7RTDWHsk
         bjslanpdp0iYCI31hs6fQEb6yR9A0ouMgX9NRfUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Irui Wang <irui.wang@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/287] media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment
Date:   Tue, 23 Aug 2022 10:24:13 +0200
Message-Id: <20220823080103.118785157@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit ab14c99c035da7156a3b66fa171171295bc4b89a ]

The mdp_ipi_comm structure defines a command that is either
PROCESS (start processing) or DEINIT (destroy instance); we
are using this one to send PROCESS or DEINIT commands from Linux
to an MDP instance through a VPU write but, while the first wants
us to stay 4-bytes aligned, the VPU instead requires an 8-bytes
data alignment.

Keeping in mind that these commands are executed immediately
after sending them (hence not chained with others before the
VPU/MDP "actually" start executing), it is fine to simply add
a padding of 4 bytes to this structure: this keeps the same
performance as before, as we're still stack-allocating it,
while avoiding hackery inside of mtk-vpu to ensure alignment
bringing a definitely bigger performance impact.

Fixes: c8eb2d7e8202 ("[media] media: Add Mediatek MDP Driver")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Houlong Wei <houlong.wei@mediatek.com>
Reviewed-by: Irui Wang <irui.wang@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h b/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
index 78e2cc0dead1..4f4a51dd48e1 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
@@ -48,12 +48,14 @@ struct mdp_ipi_init {
  * @ipi_id        : IPI_MDP
  * @ap_inst       : AP mtk_mdp_vpu address
  * @vpu_inst_addr : VPU MDP instance address
+ * @padding       : Alignment padding
  */
 struct mdp_ipi_comm {
 	uint32_t msg_id;
 	uint32_t ipi_id;
 	uint64_t ap_inst;
 	uint32_t vpu_inst_addr;
+	uint32_t padding;
 };
 
 /**
-- 
2.35.1



