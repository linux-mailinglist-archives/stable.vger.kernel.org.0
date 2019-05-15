Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19C81F1E2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfEOL4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbfEOLRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9414320644;
        Wed, 15 May 2019 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919064;
        bh=zumhebDlMS+1xOtQgAdOJf5PiuJ3GAZZf018nQT37s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FssqqGYWu7DipBd8B3M69Tc56riIo8yu6EWtYvt/eulqakU8d5civH1oJ+3n5apyL
         7ZFUh2TlcjRQkWHGOL26f6qqHDOyIR1P9WAKGqTqnRoWte7a0JnUAISgkTzW6DS6lH
         rvZRfMAxwuIkinwnZZFqMjeN04WTEIpedY+KzsBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 051/115] media: adv7842: when the EDID is cleared, unconfigure CEC as well
Date:   Wed, 15 May 2019 12:55:31 +0200
Message-Id: <20190515090703.304859002@linuxfoundation.org>
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

[ Upstream commit ab83203e181015b099720aff43ffabc1812e0fb3 ]

When there is no EDID the CEC adapter should be unconfigured as
well. So call cec_phys_addr_invalidate() when this happens.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.18 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/media/i2c/adv7842.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index f9c23173c9fa0..dcce8d030e5db 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -799,8 +799,10 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	/* Disable I2C access to internal EDID ram from HDMI DDC ports */
 	rep_write_and_or(sd, 0x77, 0xf3, 0x00);
 
-	if (!state->hdmi_edid.present)
+	if (!state->hdmi_edid.present) {
+		cec_phys_addr_invalidate(state->cec_adap);
 		return 0;
+	}
 
 	pa = cec_get_edid_phys_addr(edid, 256, &spa_loc);
 	err = cec_phys_addr_validate(pa, &pa, NULL);
-- 
2.20.1



