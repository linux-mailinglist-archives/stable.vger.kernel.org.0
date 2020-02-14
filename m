Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5B515E727
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393113AbgBNQwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:52:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404791AbgBNQT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C602724702;
        Fri, 14 Feb 2020 16:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697167;
        bh=S+s3cWclEBY8U+vBbH0trtzvecUl92KL8gjlYd0sTYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qr2sByWBhEVn05zbtPF1IMXA30YQB0ydz8itazOzesEds1r64NU7i1+UitbPEAimX
         Qqsy+j3cTBSpawVbqXyCe2yUoc525fH08qFNL8/wdZ4ZDJT8agBurthJvwDdxH9Rn8
         zi7Yj6uPqR4+CEq6I0ZO307o17y/hNhMWTsEcN80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dingchen Zhang <dingchen.zhang@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 102/186] drm: remove the newline for CRC source name.
Date:   Fri, 14 Feb 2020 11:15:51 -0500
Message-Id: <20200214161715.18113-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
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
index 2901b7944068d..6858c80d2eb50 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -101,8 +101,8 @@ static ssize_t crc_control_write(struct file *file, const char __user *ubuf,
 	if (IS_ERR(source))
 		return PTR_ERR(source);
 
-	if (source[len] == '\n')
-		source[len] = '\0';
+	if (source[len - 1] == '\n')
+		source[len - 1] = '\0';
 
 	spin_lock_irq(&crc->lock);
 
-- 
2.20.1

