Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC863BCC2E
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhGFLSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhGFLSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C22061A14;
        Tue,  6 Jul 2021 11:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570143;
        bh=co4ViAOkLJgTbOD/bShjc5Cfzwin0PgwlTQtXi3wqAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGhBJe5iC+A/EeGQvdeuD3ldn7FcQIm7X1Y8PFq8zz8KEbcCRuyKB2uO99KEvZwtq
         NmXolCL0KlEKDwekCSTsnaueYLt9AudlfX5BeMoeOC1iey9t9HtdnRMALBuDyIT7PU
         xcanBjFAJEmAaRfXzXGxYi5byTYoPAz8CZ9ySMXs4mUV7M/RhaQcqgE1UauPap/gZ2
         ZAsMgk/UuAjJvpJGMMap52eEu9+7KwV2cXq83i5YPd1vj4ev3Hx1OcMNhA6zZMBgRL
         NG1KFiUqAUuBC71HSfFDZrWKG9ctuJ+5uA+8NjALssc8CpnLw/CRSB+LF3xA/sDu+s
         PGXJsO8T3FMtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 068/189] drm/amd/display: Avoid HDCP over-read and corruption
Date:   Tue,  6 Jul 2021 07:12:08 -0400
Message-Id: <20210706111409.2058071-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 2cbd931363bd..6d26d9c63ab2 100644
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

