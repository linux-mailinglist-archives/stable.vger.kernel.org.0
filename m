Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE4292C2E
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgJSRCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:02:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32834 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730862AbgJSRCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:43 -0400
Date:   Mon, 19 Oct 2020 17:02:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126962;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=Mm2oJkQBpvOsV9aCBMpH+tripIZzlxiNu5ziJUX+6Ig=;
        b=VHFDNLE/KJ91rOuG9kleyKPLnHxlo4VtA1enELqhwWyZBO1KPcP4RZ9V8e+JvZdOQs/btr
        RG3ibrkZsA9DtbUeDbSLKKhW2fWV+8HHMTP3Ts9R65lhJYIGd+0MQTVlvyul6TOzbBX7SW
        BWJhr/hq2yzWCC1pEK0RYUsE5qAXx3Jcr/aBL8WXHHHC+1KTIlGtLH+ohwWkv9U59HHLAE
        64WbKN9r/5BgojI2Hs94uH+Whp1fwTrh8i1/BSrp8NNNScfvcpa9cnSAYJIsdvJCn93Fvl
        R6cmhwF8ZBiaYXx8pzDZ+5o+GTrFNMPmBiwBwMT6+SXtw3lvTwQZ5gWewaguiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126962;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=Mm2oJkQBpvOsV9aCBMpH+tripIZzlxiNu5ziJUX+6Ig=;
        b=tReg0FhSH4tyV14UAUPhxJWyEVsz+JiILmDcPJU0E4RhK2WVyjjr9dEWvDHdY1gpQiE3lK
        yqxwQhIkVYIQx6BA==
From:   "tip-bot2 for Alex Deucher" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] Revert "drm/amdgpu: Fix NULL dereference in dpm
 sysfs handlers"
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160312696114.7002.3688701594191033856.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     ffdf9f8550ee675d4270bbaa5721a6f3116d137e
Gitweb:        https://git.kernel.org/tip/ffdf9f8550ee675d4270bbaa5721a6f3116d137e
Author:        Alex Deucher <alexander.deucher@amd.com>
AuthorDate:    Thu, 30 Jul 2020 11:02:30 -04:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:22 +02:00

Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"

commit 2456c290a7889be492cb96092b62d16c11176f72 upstream.

This regressed some working configurations so revert it.  Will
fix this properly for 5.9 and backport then.

This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c |  9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index e4dbf14..5bf4212 100644
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
