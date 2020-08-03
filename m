Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B027C23A6FD
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHCM4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgHCMV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD602076B;
        Mon,  3 Aug 2020 12:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457316;
        bh=ixOj0L2zhR7RM2hV2j31sXovmLSwVRFOPEE5uFKzjAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BC4NJfBmHQXgi954FXmJmpzKQQnpxls4D5qJQnvIoMRoTF4Ke5RTZfkCd5niflVkg
         fQfByt8BVXIMl7jfIOyGMUvsmPwVyPnsHfnNQ7NKvCYy3eixGK4+1OKu+bHbQvtFZI
         g3ff/qWD7n4vDZ5ZBnyOFoqf5ZDQCY/Oq8LqeWvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 023/120] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"
Date:   Mon,  3 Aug 2020 14:18:01 +0200
Message-Id: <20200803121903.976679481@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
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
@@ -775,7 +775,8 @@ static ssize_t amdgpu_set_pp_od_clk_volt
 		tmp_str++;
 	while (isspace(*++tmp_str));
 
-	while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+	while (tmp_str[0]) {
+		sub_str = strsep(&tmp_str, delimiter);
 		ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 		if (ret)
 			return -EINVAL;
@@ -1035,7 +1036,8 @@ static ssize_t amdgpu_read_mask(const ch
 	memcpy(buf_cpy, buf, bytes);
 	buf_cpy[bytes] = '\0';
 	tmp = buf_cpy;
-	while ((sub_str = strsep(&tmp, delimiter)) != NULL) {
+	while (tmp[0]) {
+		sub_str = strsep(&tmp, delimiter);
 		if (strlen(sub_str)) {
 			ret = kstrtol(sub_str, 0, &level);
 			if (ret)
@@ -1632,7 +1634,8 @@ static ssize_t amdgpu_set_pp_power_profi
 			i++;
 		memcpy(buf_cpy, buf, count-i);
 		tmp_str = buf_cpy;
-		while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+		while (tmp_str[0]) {
+			sub_str = strsep(&tmp_str, delimiter);
 			ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 			if (ret)
 				return -EINVAL;


