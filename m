Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909D65F9558
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiJJASy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiJJASY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:18:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E36413F8C;
        Sun,  9 Oct 2022 16:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D3E60D3D;
        Sun,  9 Oct 2022 23:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE1AC433C1;
        Sun,  9 Oct 2022 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359603;
        bh=wLs1MRVkbxT3b8aKqZEYPEL1jHZDMLOF9qfa9pKqlWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGy3TC8rx5r0UDSLaUV1J8qEVLSnFyQ4XBfkT5Ja7oxffTZ2sKcR2FvvCLeyondZ2
         sxQFdZJipG6xqEVpjgxp5jBQzqr+IL+5JiE6xgvBsz2qA/AsSAzDy93FsTtTuBCSvb
         0OYW5YI5gmMrDwttJpcFFOv5Jdp39ilpzgW6Fy/bID4q+8BF4Tefj+BAut51qmOcZe
         qVyYwC/NKe0fCH0u5xvgV9F93U3xEFvvdakf/Ril7rBsLTz59j5qfa22VEBj4bQLPD
         PPP/GzlRbGxP5YjGan2mmm18xsNDVUi41ZhiHUSFKpaVZFK/ceZG+vVyI8Z0cFcMf8
         i35lvqBrBGU3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jorge Lopez <jorge.lopez2@hp.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 20/36] platform/x86: hp-wmi: Setting thermal profile fails with 0x06
Date:   Sun,  9 Oct 2022 19:52:06 -0400
Message-Id: <20221009235222.1230786-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235222.1230786-1-sashal@kernel.org>
References: <20221009235222.1230786-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit 00b1829294b7c88ecba92c661fbe6fe347b364d2 ]

Error 0x06 (invalid command parameter) is reported by hp-wmi module
when reading the current thermal profile and then proceed to set it
back. The failing condition occurs in Linux NixOS after user
configures the thermal profile to ‘quiet mode’ in Windows.  Quiet Fan
Mode is supported in Windows but was not supported in hp-wmi module.

This fix adds support for PLATFORM_PROFILE_QUIET in hp-wmi module for
HP notebooks other than HP Omen series.  Quiet thermal profile is not
supported in HP Omen series notebooks.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/20220912192603.4001-1-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index bc7020e9df9e..fc8dbbd6fc7c 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -177,7 +177,8 @@ enum hp_thermal_profile_omen_v1 {
 enum hp_thermal_profile {
 	HP_THERMAL_PROFILE_PERFORMANCE	= 0x00,
 	HP_THERMAL_PROFILE_DEFAULT		= 0x01,
-	HP_THERMAL_PROFILE_COOL			= 0x02
+	HP_THERMAL_PROFILE_COOL			= 0x02,
+	HP_THERMAL_PROFILE_QUIET		= 0x03,
 };
 
 #define IS_HWBLOCKED(x) ((x & HPWMI_POWER_FW_OR_HW) != HPWMI_POWER_FW_OR_HW)
@@ -1194,6 +1195,9 @@ static int hp_wmi_platform_profile_get(struct platform_profile_handler *pprof,
 	case HP_THERMAL_PROFILE_COOL:
 		*profile =  PLATFORM_PROFILE_COOL;
 		break;
+	case HP_THERMAL_PROFILE_QUIET:
+		*profile = PLATFORM_PROFILE_QUIET;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1216,6 +1220,9 @@ static int hp_wmi_platform_profile_set(struct platform_profile_handler *pprof,
 	case PLATFORM_PROFILE_COOL:
 		tp =  HP_THERMAL_PROFILE_COOL;
 		break;
+	case PLATFORM_PROFILE_QUIET:
+		tp = HP_THERMAL_PROFILE_QUIET;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1263,6 +1270,8 @@ static int thermal_profile_setup(void)
 
 		platform_profile_handler.profile_get = hp_wmi_platform_profile_get;
 		platform_profile_handler.profile_set = hp_wmi_platform_profile_set;
+
+		set_bit(PLATFORM_PROFILE_QUIET, platform_profile_handler.choices);
 	}
 
 	set_bit(PLATFORM_PROFILE_COOL, platform_profile_handler.choices);
-- 
2.35.1

