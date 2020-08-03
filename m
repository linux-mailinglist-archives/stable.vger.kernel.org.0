Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5226523A62C
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgHCMp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbgHCM1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E865204EC;
        Mon,  3 Aug 2020 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457651;
        bh=bnXW+kq4TokSOv/tJwzDwPvCTCgcOvHAglygsZOHc0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPvfxEgjf93l8b3IVqCKCWbTy/cYLrkbWbb5NsFLVRtr495md53vS6Rh6XWDxV41J
         3Qoo2fzPEoATBWQgUqNTMoWYdngmUobC5rtAfvTMO0J3v1dNRkkTl/KIKKKgL2K9do
         DWk1XEMTWv2UmprjIiHP+fzJPV8yjqEFKK+bjW9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 24/90] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"
Date:   Mon,  3 Aug 2020 14:18:46 +0200
Message-Id: <20200803121858.796616416@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 87004abfbc27261edd15716515d89ab42198b405 upstream.

This regressed some working configurations so revert it.  Will
fix this properly for 5.9 and backport then.

This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -691,7 +691,8 @@ static ssize_t amdgpu_set_pp_od_clk_volt
 		tmp_str++;
 	while (isspace(*++tmp_str));
 
-	while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+	while (tmp_str[0]) {
+		sub_str = strsep(&tmp_str, delimiter);
 		ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 		if (ret)
 			return -EINVAL;
@@ -882,7 +883,8 @@ static ssize_t amdgpu_read_mask(const ch
 	memcpy(buf_cpy, buf, bytes);
 	buf_cpy[bytes] = '\0';
 	tmp = buf_cpy;
-	while ((sub_str = strsep(&tmp, delimiter)) != NULL) {
+	while (tmp[0]) {
+		sub_str = strsep(&tmp, delimiter);
 		if (strlen(sub_str)) {
 			ret = kstrtol(sub_str, 0, &level);
 			if (ret)
@@ -1298,7 +1300,8 @@ static ssize_t amdgpu_set_pp_power_profi
 			i++;
 		memcpy(buf_cpy, buf, count-i);
 		tmp_str = buf_cpy;
-		while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+		while (tmp_str[0]) {
+			sub_str = strsep(&tmp_str, delimiter);
 			ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 			if (ret) {
 				count = -EINVAL;


