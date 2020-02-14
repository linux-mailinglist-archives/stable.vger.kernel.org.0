Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE95515F1F9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388160AbgBNSFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731738AbgBNPzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED19524673;
        Fri, 14 Feb 2020 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695719;
        bh=UG/BD9hscKmWK0RNNprICbSWct+Wubtc4+D89CyPTMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIiUBh6M+CyJmftPuL1oDEstF2TCykDcIc3ZHDokNpi8d2+2yc/sskG37S63yXy9w
         e2P+N/UHLz0v0FRMfXjvTU76uurQn2eMKAmR6WxzjL7UAmPc0KGBHB/uaiDcZ1+Xm9
         lUrGwzZGRzPYF7ibToPJtzdNgw0PwqnaSrE5bR5E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dingchen Zhang <dingchen.zhang@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 296/542] drm: remove the newline for CRC source name.
Date:   Fri, 14 Feb 2020 10:44:48 -0500
Message-Id: <20200214154854.6746-296-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

