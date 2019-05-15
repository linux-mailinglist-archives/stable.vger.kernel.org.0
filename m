Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840651F1BB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfEOLRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbfEOLRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6EC120644;
        Wed, 15 May 2019 11:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919061;
        bh=AgWPtJhCmV9gDH7+N7t6urqs1UeMX2JOWmXIAWuPI8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJvXWSlLbgD8zKZLi8ferpDHlgwiHO+pRch0goH87apJy3tAkEzLynnjayGb6rFBf
         j979b4NpqUvTYVDATqFin28XhaDhurRAXbx7C8YMA3MOkwekKiTUjBjvgIWk1AROw1
         1UxzHUHq77MQGwe7JL93gfxEI0HMddZD+6x7Fo0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 050/115] media: adv7604: when the EDID is cleared, unconfigure CEC as well
Date:   Wed, 15 May 2019 12:55:30 +0200
Message-Id: <20190515090703.223751213@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index d2108aad3c658..26c3ec573a565 100644
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



