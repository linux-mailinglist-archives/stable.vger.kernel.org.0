Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF33BD4DA
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhGFMRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235093AbhGFLd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4E2261E0B;
        Tue,  6 Jul 2021 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570588;
        bh=kCdTWq7fWYA1GEGr+aSKfE6tn0rSyjfSV023TumUpz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfHda4bEKP4jBM/M2+ZJENrT46aYh1+g8hujnPFm4Kw+mqVBeiox9wtvAnlWqjws1
         0aN5gtkvH3iB3DZl5QETQwoxzfGobsRJAA9CTCiN773oZ655+4/QZW3GU2PusdfkFJ
         QoBZ8aUq0eBKkxIsG+X+8pY0jKqdZJR+S5GJNNBYIdqwR8ioz1UXVsONJ9pqcTa5lu
         KMhnE5P5wtLpLpJGPv1RB+ZGNKz8CRL/JlBMYb/67nwDj0S6HmDIZXbX5qD6QakKwb
         8GMNDIsGYj3qn9q9dP2wCmoGEJQDJi2T5BZvip9Dmu6rJmzvTv2Cw2wSloV+Osmrs8
         pDyN4MDkltRiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 050/137] drm/amd/display: Avoid HDCP over-read and corruption
Date:   Tue,  6 Jul 2021 07:20:36 -0400
Message-Id: <20210706112203.2062605-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 06888d571b513cbfc0b41949948def6cb81021b2 ]

Instead of reading the desired 5 bytes of the actual target field,
the code was reading 8. This could result in a corrupted value if the
trailing 3 bytes were non-zero, so instead use an appropriately sized
and zero-initialized bounce buffer, and read only 5 bytes before casting
to u64.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
index f244b72e74e0..53eab2b8e2c8 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
@@ -29,8 +29,10 @@ static inline enum mod_hdcp_status validate_bksv(struct mod_hdcp *hdcp)
 {
 	uint64_t n = 0;
 	uint8_t count = 0;
+	u8 bksv[sizeof(n)] = { };
 
-	memcpy(&n, hdcp->auth.msg.hdcp1.bksv, sizeof(uint64_t));
+	memcpy(bksv, hdcp->auth.msg.hdcp1.bksv, sizeof(hdcp->auth.msg.hdcp1.bksv));
+	n = *(uint64_t *)bksv;
 
 	while (n) {
 		count++;
-- 
2.30.2

