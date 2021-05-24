Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A934038EC55
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhEXPOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234771AbhEXPIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F1DE6191B;
        Mon, 24 May 2021 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867902;
        bh=Sg+oHbjPM3EyWs9U+wsYp0uv2MQ9sKDApoykKutJ+x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBzuKH0lK+Yiga5M86w8E3kWQZ6Cl5WBtDe3NBP1O9qLRunoxuCS9EneqfRS8C4YX
         kn0LieLKcSHzOrEeo2IsTWk6JmExbyE88PeCCieMBJ9gIcebr8GhpV79BxbY7DEm3U
         4FzpJSki4L+RcJ+MX3kqIOcimwJjM49WPi2Bzwhm3Au86LgDb0dTgv9HtDpix1ayYY
         q/b8M8VSIbAHFJYUFJjyC7W9yBGfsYkfzb7dKryDVsd3So0lrK4NVSENFARuIWwley
         EOiwJd9ETh0AcYYqUgzlec+qi/d293kFO1xkvphdM8KaKRT9d9HvJJN4uSvKvg7WzD
         gp2xxJIZE4YhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/16] media: dvb: Add check on sp8870_readreg return
Date:   Mon, 24 May 2021 10:51:23 -0400
Message-Id: <20210524145130.2499829-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145130.2499829-1-sashal@kernel.org>
References: <20210524145130.2499829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Emad <alaaemadhossney.ae@gmail.com>

[ Upstream commit c6d822c56e7fd29e6fa1b1bb91b98f6a1e942b3c ]

The function sp8870_readreg returns a negative value when i2c_transfer
fails so properly check for this and return the error if it happens.

Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-60-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/sp8870.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index e87ac30d7fb8..b43135c5a960 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -293,7 +293,9 @@ static int sp8870_set_frontend_parameters(struct dvb_frontend *fe)
 	sp8870_writereg(state, 0xc05, reg0xc05);
 
 	// read status reg in order to clear pending irqs
-	sp8870_readreg(state, 0x200);
+	err = sp8870_readreg(state, 0x200);
+	if (err < 0)
+		return err;
 
 	// system controller start
 	sp8870_microcontroller_start(state);
-- 
2.30.2

