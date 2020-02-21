Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B83D2167780
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgBUHw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgBUHwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:52:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A0220578;
        Fri, 21 Feb 2020 07:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271572;
        bh=UG/BD9hscKmWK0RNNprICbSWct+Wubtc4+D89CyPTMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+5yPewOWtFAsuCoNDyfvW0FzjLxsiFWEA4h2IgMCgh863Xysi3Xo+xw1atoFi5Qo
         eR6doAcG9ieAWIOxcM0Lu/7sZX4u2BWMD07urCnMzfBce76+OGM5GS1IZe+tjyacks
         cnXIvww17MUpdgeAc07Jl0fIpKN0hFt3e7PZk8Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Dingchen Zhang <dingchen.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 217/399] drm: remove the newline for CRC source name.
Date:   Fri, 21 Feb 2020 08:39:02 +0100
Message-Id: <20200221072424.090869833@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dingchen Zhang <dingchen.zhang@amd.com>

[ Upstream commit 72a848f5c46bab4c921edc9cbffd1ab273b2be17 ]

userspace may transfer a newline, and this terminating newline
is replaced by a '\0' to avoid followup issues.

'len-1' is the index to replace the newline of CRC source name.

v3: typo fix (Sam)

v2: update patch subject, body and format. (Sam)

Cc: Leo Li <sunpeng.li@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Dingchen Zhang <dingchen.zhang@amd.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610134751.14356-1-dingchen.zhang@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs_crc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_debugfs_crc.c b/drivers/gpu/drm/drm_debugfs_crc.c
index ca3c55c6b8155..2ece2957da1af 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -140,8 +140,8 @@ static ssize_t crc_control_write(struct file *file, const char __user *ubuf,
 	if (IS_ERR(source))
 		return PTR_ERR(source);
 
-	if (source[len] == '\n')
-		source[len] = '\0';
+	if (source[len - 1] == '\n')
+		source[len - 1] = '\0';
 
 	ret = crtc->funcs->verify_crc_source(crtc, source, &values_cnt);
 	if (ret)
-- 
2.20.1



