Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2E438EBDF
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhEXPHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234784AbhEXPFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99FD961406;
        Mon, 24 May 2021 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867854;
        bh=xtLMumVgtJEQDYmH/yfxN1UxvNic+puxMIyGP/3wjBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmPuz6Vr476fbDb4BKXtGzIvpGA9f8x77gPv8RzDivfC4gM+4MOPLh6FXv5ZAoY9h
         Vlf3u6vKkE/4fIzLI6lUC7gnThc49LdO97wNKiQ9Fw+bcWlXbj22h06AzgxPiCXeJ9
         CNiejh5vUOfHyYKNdgRHY0NmGnqBehKqRWqVzZNN8uoL68po+5wJzbEVLRnvEd3pwE
         JVMyEJM0kl+TA05rHAHDN9ZKYH3ZxA59gQ5ItMGD6Ix3jlVGARDsJCMFMwHPuYPdc0
         4ZSbyM/2bWHThsiCC6yK4IZL2noClNwhYGyq6sqOegeTS1NkYcFPHMqFKDIMxIYCgi
         KYC5XV+MYzWIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/21] media: dvb: Add check on sp8870_readreg return
Date:   Mon, 24 May 2021 10:50:30 -0400
Message-Id: <20210524145040.2499322-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
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
index 04454cb78467..a5782d1133df 100644
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

