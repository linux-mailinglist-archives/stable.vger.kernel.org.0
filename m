Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D80C594907
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353903AbiHOXrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354424AbiHOXp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82A689923;
        Mon, 15 Aug 2022 13:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4399160B6E;
        Mon, 15 Aug 2022 20:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33662C433C1;
        Mon, 15 Aug 2022 20:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594456;
        bh=9O9iAJb5khkUCY/Vmag+s/+bSwnnOfdvyRWWB2nxb6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSs2OMEfOWqp0kkbNdbGTbyp0vqbTz70tWLqdE4QcHbETr3CIo3EAu0fIplbo/PCa
         UFEVhzgVOquGvqr6sMMTknIxVRea4FT80shrje3dpPV8ghFKTtB8DL8ObUsuZVYAZG
         8m51H3ZuzlQb6IjSpv6GMpJ2R1ToHuIvm5qYLC0E=
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
Subject: [PATCH 5.19 0454/1157] media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment
Date:   Mon, 15 Aug 2022 19:56:50 +0200
Message-Id: <20220815180457.757333630@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h b/drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h
index 2cb8cecb3077..b810c96695c8 100644
--- a/drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h
+++ b/drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h
@@ -40,12 +40,14 @@ struct mdp_ipi_init {
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



