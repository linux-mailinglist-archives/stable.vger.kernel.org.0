Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E01A55E0
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgDKXMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbgDKXMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB7A20787;
        Sat, 11 Apr 2020 23:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646767;
        bh=PB5LeeK9gLfULaoWaG7wXKIYwJxE6ymIS5vN8CaVL9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePvTPnzf5A6BAC8iTwvp5a020KB0hgmu1wixFlxS7zqZ1zMoDTW7MwnF9zqHlsUkw
         MKz10fqkYkZc2F4dUxrMmd9vEhtMF9NazqmE5c7/AMlaenBwmacgCEVPJd4OPZ9NVM
         Ijk/evkXsup+UgmLG2IlbvCxnVS8QfWVZJfJOSLo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yannick Fertre <yannick.fertre@st.com>,
        Philippe Cornu <philippe.cornu@st.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 36/66] drm/stm: ltdc: check crtc state before enabling LIE
Date:   Sat, 11 Apr 2020 19:11:33 -0400
Message-Id: <20200411231203.25933-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Fertre <yannick.fertre@st.com>

[ Upstream commit a6bd58c51ac43083f3977057a7ad668def55812f ]

Following investigations of a hardware bug, the LIE interrupt
can occur while the display controller is not activated.
LIE interrupt (vblank) don't have to be set if the CRTC is not
enabled.

Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Acked-by: Philippe Cornu <philippe.cornu@st.com>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1579601650-7055-1-git-send-email-yannick.fertre@st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 477d0a27b9a5d..75d108db127c8 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -612,9 +612,14 @@ static const struct drm_crtc_helper_funcs ltdc_crtc_helper_funcs = {
 static int ltdc_crtc_enable_vblank(struct drm_crtc *crtc)
 {
 	struct ltdc_device *ldev = crtc_to_ltdc(crtc);
+	struct drm_crtc_state *state = crtc->state;
 
 	DRM_DEBUG_DRIVER("\n");
-	reg_set(ldev->regs, LTDC_IER, IER_LIE);
+
+	if (state->enable)
+		reg_set(ldev->regs, LTDC_IER, IER_LIE);
+	else
+		return -EPERM;
 
 	return 0;
 }
-- 
2.20.1

