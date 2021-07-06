Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B904B3BCF22
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhGFL2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbhGFL0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36D9161363;
        Tue,  6 Jul 2021 11:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570381;
        bh=Rq6Vllx5aizCaYRvGFri4AYkM3uXqJdalDaJzcbLmwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8Uw1ttOyu6RXwDQAY4ou+z6T+tEqATtza6KcuX9sACNGBTCzdI2SSYBZU/hwPQ7P
         43nNIN/Ezp/PTlQedNwm8ZNPQQyYk1CA0EdDpT/jeusqoYeao4tlyThJpxA0o2HJcP
         OfX2QI+uYeS0MpZVybBTT1f4gv+B5dKCi4kjxnhrDfkqwZ7JLEQ4VGo3954xAB19sU
         ALwyJcPe6nZVwM8B0k6xH6dyB250MUs9Df4XKslR4uDyubaP9KVkbXW3anVJhDRwD1
         YlVvsKGu+LK3YYHPGVleLpz/v7A0oEe2A42dhLjLtQMm9KNHuMxgSOXgrLFTqyA2LU
         muQqw5JjYH0EA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 056/160] drm/amd/display: Avoid HDCP over-read and corruption
Date:   Tue,  6 Jul 2021 07:16:42 -0400
Message-Id: <20210706111827.2060499-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 73ca49f05bd3..eb56526ec32c 100644
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

