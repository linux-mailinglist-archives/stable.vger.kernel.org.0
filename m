Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8917922F0CE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbgG0O1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732512AbgG0OZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A304021D95;
        Mon, 27 Jul 2020 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859949;
        bh=IpPNz01uO1QjtLxilmlnsg8OVIYlMpAGWMPWTCRk9qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFOD3vstBmEsbBLAwWUYDRnqfGDEzQoyNVvpDR5pFIdhAgKVHm/FLiT5XWNorCEcJ
         Pq76vU6Tjt4tzaLmatvglRIiSqFsfGa9ZwzzLqB8Mx8T8eCa2wNEW+RzSapFSrp1Mg
         elz1sPdvgewuvlIN2wbLVRz+f5GBX5KFC4hGMY4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Gronowski?= <me@woland.xyz>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 167/179] drm/amdgpu: Fix NULL dereference in dpm sysfs handlers
Date:   Mon, 27 Jul 2020 16:05:42 +0200
Message-Id: <20200727134940.796558955@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Gronowski <me@woland.xyz>

commit 38e0c89a19fd13f28d2b4721035160a3e66e270b upstream.

NULL dereference occurs when string that is not ended with space or
newline is written to some dpm sysfs interface (for example pp_dpm_sclk).
This happens because strsep replaces the tmp with NULL if the delimiter
is not present in string, which is then dereferenced by tmp[0].

Reproduction example:
sudo sh -c 'echo -n 1 > /sys/class/drm/card0/device/pp_dpm_sclk'

Signed-off-by: Paweł Gronowski <me@woland.xyz>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -775,8 +775,7 @@ static ssize_t amdgpu_set_pp_od_clk_volt
 		tmp_str++;
 	while (isspace(*++tmp_str));
 
-	while (tmp_str[0]) {
-		sub_str = strsep(&tmp_str, delimiter);
+	while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
 		ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 		if (ret)
 			return -EINVAL;
@@ -1036,8 +1035,7 @@ static ssize_t amdgpu_read_mask(const ch
 	memcpy(buf_cpy, buf, bytes);
 	buf_cpy[bytes] = '\0';
 	tmp = buf_cpy;
-	while (tmp[0]) {
-		sub_str = strsep(&tmp, delimiter);
+	while ((sub_str = strsep(&tmp, delimiter)) != NULL) {
 		if (strlen(sub_str)) {
 			ret = kstrtol(sub_str, 0, &level);
 			if (ret)
@@ -1634,8 +1632,7 @@ static ssize_t amdgpu_set_pp_power_profi
 			i++;
 		memcpy(buf_cpy, buf, count-i);
 		tmp_str = buf_cpy;
-		while (tmp_str[0]) {
-			sub_str = strsep(&tmp_str, delimiter);
+		while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
 			ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 			if (ret)
 				return -EINVAL;


