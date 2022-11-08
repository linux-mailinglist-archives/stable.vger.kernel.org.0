Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3407162153D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiKHOJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiKHOJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C52CDAA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB220B81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E1AC433C1;
        Tue,  8 Nov 2022 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916571;
        bh=Qs2YG4eZPcMB3J3UO5+oTFanUUSas1ZnrNeZRV6oHOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+AKZqQsakqvWQRJxuSYB5znLskSkir0kJl+OQRiSQ77u2Q0et1FqLNaz2800uMri
         synbhY1lThWh/KV80Zbc5GMdoVEFj9cyN+oirwFOZeCooCKUmNkLpK6HUYVF3NdNDb
         9c0OSkSVEDnsEtaDr0wh9JX+iAS3lUoWWjmq2e6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 065/197] media: rkisp1: Dont pass the quantization to rkisp1_csm_config()
Date:   Tue,  8 Nov 2022 14:38:23 +0100
Message-Id: <20221108133357.795346372@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 711d91497e203b058cf0a08c0f7d41c04efbde76 ]

The rkisp1_csm_config() function takes a pointer to the rkisp1_params
structure which contains the quantization value. There's no need to pass
it separately to the function. Drop it from the function parameters.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-params.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
index 9da7dc1bc690..32485f7c79d5 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -1066,7 +1066,7 @@ static void rkisp1_ie_enable(struct rkisp1_params *params, bool en)
 	}
 }
 
-static void rkisp1_csm_config(struct rkisp1_params *params, bool full_range)
+static void rkisp1_csm_config(struct rkisp1_params *params)
 {
 	static const u16 full_range_coeff[] = {
 		0x0026, 0x004b, 0x000f,
@@ -1080,7 +1080,7 @@ static void rkisp1_csm_config(struct rkisp1_params *params, bool full_range)
 	};
 	unsigned int i;
 
-	if (full_range) {
+	if (params->quantization == V4L2_QUANTIZATION_FULL_RANGE) {
 		for (i = 0; i < ARRAY_SIZE(full_range_coeff); i++)
 			rkisp1_write(params->rkisp1,
 				     RKISP1_CIF_ISP_CC_COEFF_0 + i * 4,
@@ -1552,11 +1552,7 @@ static void rkisp1_params_config_parameter(struct rkisp1_params *params)
 	rkisp1_param_set_bits(params, RKISP1_CIF_ISP_HIST_PROP_V10,
 			      rkisp1_hst_params_default_config.mode);
 
-	/* set the  range */
-	if (params->quantization == V4L2_QUANTIZATION_FULL_RANGE)
-		rkisp1_csm_config(params, true);
-	else
-		rkisp1_csm_config(params, false);
+	rkisp1_csm_config(params);
 
 	spin_lock_irq(&params->config_lock);
 
-- 
2.35.1



