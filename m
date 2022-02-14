Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B94B4A11
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348266AbiBNKfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348046AbiBNKec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384A3CD1;
        Mon, 14 Feb 2022 02:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6B2860B33;
        Mon, 14 Feb 2022 10:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CB2C340EF;
        Mon, 14 Feb 2022 10:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832874;
        bh=jDo5x2v7N8+8V51OVZjkSFtEpo9lxkpc0iqzSltGxko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbgCaF2DmdvepFKkE601kb2LVhmnu5T5lXjKACAWHTFIvPcjwgObm7zl6nTD6/qOf
         DH1I8j5ZEjXz2uASAgPEMyDeZPNojSpyL0IBwdeYW2kAw2wII5pMmYAq120up1FCXC
         l81D5GYgYesseQM4AWjwQqBvX6+vx40KNHIPaXQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Wang <KevinYang.Wang@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 153/203] drm/amd/pm: fix hwmon node of power1_label create issue
Date:   Mon, 14 Feb 2022 10:26:37 +0100
Message-Id: <20220214092515.452156089@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Wang <KevinYang.Wang@amd.com>

[ Upstream commit a8b1e8636a3252daa729762b2e3cc9015cc91a5c ]

it will cause hwmon node of power1_label is not created.

v2:
the hwmon node of "power1_label" is always needed for all ASICs.
and the patch will remove ASIC type check for "power1_label".

Fixes: ae07970a0621d6 ("drm/amd/pm: add support for hwmon control of slow and fast PPT limit on vangogh")

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index f8370d54100e8..d31719b3418fa 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -3451,8 +3451,7 @@ static umode_t hwmon_attributes_visible(struct kobject *kobj,
 	     attr == &sensor_dev_attr_power2_cap_min.dev_attr.attr ||
 		 attr == &sensor_dev_attr_power2_cap.dev_attr.attr ||
 		 attr == &sensor_dev_attr_power2_cap_default.dev_attr.attr ||
-		 attr == &sensor_dev_attr_power2_label.dev_attr.attr ||
-		 attr == &sensor_dev_attr_power1_label.dev_attr.attr))
+		 attr == &sensor_dev_attr_power2_label.dev_attr.attr))
 		return 0;
 
 	return effective_mode;
-- 
2.34.1



