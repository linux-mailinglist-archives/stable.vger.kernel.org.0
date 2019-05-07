Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1843015B0B
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfEGFj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbfEGFj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC4C21655;
        Tue,  7 May 2019 05:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207596;
        bh=cRV3ZI6rFtbhhrGibaa5WePGHbpNxqpBN/bzCT3qLso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUMpvl0OXr8TR/ktGPVxlc2esU24OxAa0cGjRv9LTHjuhyyDsjA6S9fKmOX7/kTlo
         SzKMoVWVnl0RTrgarKwMs0yZ63PEfJu/86rNE4CQQL6mSmuEmz7EEr8cqZvPLLNTx7
         hq7UFI2C4jFP/aoMGHho+NbTLqPxi4CSE0oibCKg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 45/95] media: adv7604: when the EDID is cleared, unconfigure CEC as well
Date:   Tue,  7 May 2019 01:37:34 -0400
Message-Id: <20190507053826.31622-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

[ Upstream commit e7da89926f6dc6cf855f5ffdf79ef99a1b115ca7 ]

When there is no EDID the CEC adapter should be unconfigured as
well. So call cec_phys_addr_invalidate() when this happens.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.18 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/media/i2c/adv7604.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d2108aad3c65..26c3ec573a56 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2295,8 +2295,10 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		state->aspect_ratio.numerator = 16;
 		state->aspect_ratio.denominator = 9;
 
-		if (!state->edid.present)
+		if (!state->edid.present) {
 			state->edid.blocks = 0;
+			cec_phys_addr_invalidate(state->cec_adap);
+		}
 
 		v4l2_dbg(2, debug, sd, "%s: clear EDID pad %d, edid.present = 0x%x\n",
 				__func__, edid->pad, state->edid.present);
-- 
2.20.1

