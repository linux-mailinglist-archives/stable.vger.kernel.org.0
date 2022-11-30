Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1215563E045
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiK3SzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiK3SzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18B999F32
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED9661D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93293C433C1;
        Wed, 30 Nov 2022 18:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834516;
        bh=gOBjXsPCy4231m/YEE+zLyMZXLbGf3MQ0/wjtLguMiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSggxh5Wxzq5eDCn/bylVMWZraKNKKl9m1fjLkgIvtDcKsXAUIrKAcb5hIi/sq7Oq
         XpfmGaOOkk1qOkGBHF6L8LpGhxOVZjMU3XyK0hppIh/qqUahVk2Tc7h3OV+HxKb4N9
         z96aHipyQiGXnBzOm1nu773KNKhDItvoL8+25uqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerry Zuo <Jerry.Zuo@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Tsung-hua Lin <Tsung-hua.Lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 282/289] drm/amd/display: No display after resume from WB/CB
Date:   Wed, 30 Nov 2022 19:24:27 +0100
Message-Id: <20221130180550.495792124@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Tsung-hua Lin <Tsung-hua.Lin@amd.com>

commit a6e1775da04ab042bc9e2e42399fa25714c253da upstream.

[why]
First MST sideband message returns AUX_RET_ERROR_HPD_DISCON
on certain intel platform. Aux transaction considered failure
if HPD unexpected pulled low. The actual aux transaction success
in such case, hence do not return error.

[how]
Not returning error when AUX_RET_ERROR_HPD_DISCON detected
on the first sideband message.

v2: squash in fix (Alex)

Reviewed-by: Jerry Zuo <Jerry.Zuo@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Tsung-hua Lin <Tsung-hua.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1371,7 +1371,44 @@ static const struct dmi_system_id hpd_di
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
+		},
+	},
 	{}
+	/* TODO: refactor this from a fixed table to a dynamic option */
 };
 
 static void retrieve_dmi_info(struct amdgpu_display_manager *dm)


