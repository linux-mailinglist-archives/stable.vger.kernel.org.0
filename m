Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21928E7E1
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 22:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgJNU2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 16:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgJNU2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 16:28:47 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F90C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 13:28:46 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u19so892941ion.3
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFd5sfWdeHXHFOZx8/l1qxcGoOkTDfGlH2jelssAjy8=;
        b=EK8FTderXi3TwLhqaGJxPuVO9Ylz9DSP6UF77Mo9Nc2RVmM2SjkUySb/0jAeUMg93i
         A/2f5O+TvmWSThYDRID8mCVOWYMmySSd1HwU1IUB8uMChQnMoJQuqX/aOF5hs/6uXSol
         pa/X6fcALwR2TMdAX/BDzuuW5Q8AJyWjQJHuQ99ff0dgDy9Ov45jCAGt8iItXcCiz62y
         Z45qo2L/PgIDjdKzxvMviTWCKVOO0hSTZo+Q+eV6iyX8wqj78s4rkq2WxGr6NxMrl22N
         sVY8tP+dxgT7S4KzoBqYyapIMnU+9+b5wd+nT/K/4sWY02B09OjRPA4lbESklOUjypqy
         BT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFd5sfWdeHXHFOZx8/l1qxcGoOkTDfGlH2jelssAjy8=;
        b=bwdSteFfNGy0bQNbGIvW6RWc3JXhPkxxG6OFCDV6chrDe/WvLnijag9uCZaTysNGAS
         LIwPFnB3YnhIrHN/Zxlxg5jdfddcq3X7bUKS6qHUEe3SADCskbaspt7WUE49uzSbM8Oz
         k55neYP+cYuKGyBgXCwIZIfSOXbxXJADn3JbAvSmyyh8OoXMasDRqAqIsOSL+hORVN9n
         zRmJSx+IewD/jWKJ+hsXmG3TXR/lr5AtPDr2jt60ib7Z+QztH3kvwQIVDeOn4KkE4M1c
         iRUIC0TEphCuqb+o9WcfZc2YVWPy0QaTS6k62e2UXjY6X5L4nI29267Q8sizfTHraDcT
         e0qA==
X-Gm-Message-State: AOAM530QDpjguHg695B6sPC12WXPovNS6Ch7m/lSQE6oS1YkvVtJQcH6
        P33o+/OBd14MFxIcBwY/8zR1QQYJHwU=
X-Google-Smtp-Source: ABdhPJwxGjvmf1gm23Pt/C/v/k4ZPNJhTTlt9oFCJTwQtJ/wpEi27ADj4nDd3kUU03h1/je88GHwNg==
X-Received: by 2002:a5e:cb4c:: with SMTP id h12mr927673iok.112.1602707325320;
        Wed, 14 Oct 2020 13:28:45 -0700 (PDT)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id i29sm439042ile.45.2020.10.14.13.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 13:28:44 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"
Date:   Wed, 14 Oct 2020 16:28:36 -0400
Message-Id: <20201014202836.240347-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This regressed some working configurations so revert it.  Will
fix this properly for 5.9 and backport then.

This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.

This needs to be applied to 5.9 as well.  -next (5.10) has this
already, but 5.9 missed it.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1334
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
(cherry picked from commit 87004abfbc27261edd15716515d89ab42198b405)
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index e4dbf14320b6..5bf4212d2857 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -796,7 +796,8 @@ static ssize_t amdgpu_set_pp_od_clk_voltage(struct device *dev,
 		tmp_str++;
 	while (isspace(*++tmp_str));
 
-	while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+	while (tmp_str[0]) {
+		sub_str = strsep(&tmp_str, delimiter);
 		ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 		if (ret)
 			return -EINVAL;
@@ -1066,7 +1067,8 @@ static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 	memcpy(buf_cpy, buf, bytes);
 	buf_cpy[bytes] = '\0';
 	tmp = buf_cpy;
-	while ((sub_str = strsep(&tmp, delimiter)) != NULL) {
+	while (tmp[0]) {
+		sub_str = strsep(&tmp, delimiter);
 		if (strlen(sub_str)) {
 			ret = kstrtol(sub_str, 0, &level);
 			if (ret)
@@ -1695,7 +1697,8 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 			i++;
 		memcpy(buf_cpy, buf, count-i);
 		tmp_str = buf_cpy;
-		while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+		while (tmp_str[0]) {
+			sub_str = strsep(&tmp_str, delimiter);
 			ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 			if (ret)
 				return -EINVAL;
-- 
2.25.4

