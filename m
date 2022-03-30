Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078CC4EC26B
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiC3L7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345908AbiC3LzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E5D26C561;
        Wed, 30 Mar 2022 04:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2373F61703;
        Wed, 30 Mar 2022 11:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861CBC36AE2;
        Wed, 30 Mar 2022 11:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641142;
        bh=+LlN6is2oOq9hSTl4jDvC8cIgW19PtekWjYIVYSEn/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzn08dPm/+eLykwFXa7XoWDMmSh03R2FUVpVII8H2u9FbHtsQIGth7yepWC9rYUiL
         malf9LMIRE29RotLYBk5w8gjlzTAHg+99IZT22TjFp+7Drnz5HhIk2yiSFdlOmQDAD
         mUIdtJ86PBNAc/mHc8F6cspKwbsCy2YTGb5kXXF9KhQ8YTe6GbRdtKypNh2rC9f/WW
         ajBgwCMwH5DC2maADvlKmetGi3tcjde3Vx3/C4KpDwfJsENRkIOi0KL+iGqcA44oCj
         sHPkFeiXeY/pndSW+mP0uE+RcqRZf9j3hxXhhbrmaT1X85vzJmvgVpteAVooMr8pho
         vyycimK99MUcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 36/37] media: atomisp: fix bad usage at error handling logic
Date:   Wed, 30 Mar 2022 07:51:21 -0400
Message-Id: <20220330115122.1671763-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit fc0b582c858ed73f94c8f3375c203ea46f1f7402 ]

As warned by sparse:
	atomisp: drivers/staging/media/atomisp/pci/atomisp_acc.c:508 atomisp_acc_load_extensions() warn: iterator used outside loop: 'acc_fw'

The acc_fw interactor is used outside the loop, at the error handling
logic. On most cases, this is actually safe there, but, if
atomisp_css_set_acc_parameters() has an error, an attempt to use it
will pick an invalid value for acc_fw.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_acc.c   | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_acc.c b/drivers/staging/media/atomisp/pci/atomisp_acc.c
index f638d0bd09fe..b1614cce2dfb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_acc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_acc.c
@@ -439,6 +439,18 @@ int atomisp_acc_s_mapped_arg(struct atomisp_sub_device *asd,
 	return 0;
 }
 
+static void atomisp_acc_unload_some_extensions(struct atomisp_sub_device *asd,
+					      int i,
+					      struct atomisp_acc_fw *acc_fw)
+{
+	while (--i >= 0) {
+		if (acc_fw->flags & acc_flag_to_pipe[i].flag) {
+			atomisp_css_unload_acc_extension(asd, acc_fw->fw,
+							 acc_flag_to_pipe[i].pipe_id);
+		}
+	}
+}
+
 /*
  * Appends the loaded acceleration binary extensions to the
  * current ISP mode. Must be called just before sh_css_start().
@@ -477,16 +489,20 @@ int atomisp_acc_load_extensions(struct atomisp_sub_device *asd)
 								     acc_fw->fw,
 								     acc_flag_to_pipe[i].pipe_id,
 								     acc_fw->type);
-				if (ret)
+				if (ret) {
+					atomisp_acc_unload_some_extensions(asd, i, acc_fw);
 					goto error;
+				}
 
 				ext_loaded = true;
 			}
 		}
 
 		ret = atomisp_css_set_acc_parameters(acc_fw);
-		if (ret < 0)
+		if (ret < 0) {
+			atomisp_acc_unload_some_extensions(asd, i, acc_fw);
 			goto error;
+		}
 	}
 
 	if (!ext_loaded)
@@ -495,6 +511,7 @@ int atomisp_acc_load_extensions(struct atomisp_sub_device *asd)
 	ret = atomisp_css_update_stream(asd);
 	if (ret) {
 		dev_err(isp->dev, "%s: update stream failed.\n", __func__);
+		atomisp_acc_unload_extensions(asd);
 		goto error;
 	}
 
@@ -502,13 +519,6 @@ int atomisp_acc_load_extensions(struct atomisp_sub_device *asd)
 	return 0;
 
 error:
-	while (--i >= 0) {
-		if (acc_fw->flags & acc_flag_to_pipe[i].flag) {
-			atomisp_css_unload_acc_extension(asd, acc_fw->fw,
-							 acc_flag_to_pipe[i].pipe_id);
-		}
-	}
-
 	list_for_each_entry_continue_reverse(acc_fw, &asd->acc.fw, list) {
 		if (acc_fw->type != ATOMISP_ACC_FW_LOAD_TYPE_OUTPUT &&
 		    acc_fw->type != ATOMISP_ACC_FW_LOAD_TYPE_VIEWFINDER)
-- 
2.34.1

