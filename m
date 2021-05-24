Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AE138EA95
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhEXO4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhEXOxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:53:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EFFC61420;
        Mon, 24 May 2021 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867706;
        bh=HbHEhZjevRB4CeDDwC7R5m9J42CXq3lr/RUWKX8V39w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdF0PbUubV5p4mcfbcaHmVnAaY+XcimrDCty7Al1C/9SlxXXBauY9331M0CVIdpnu
         Ko/OVgnzIQ5jZVyrMViHNcltsu3k5jyCERJGHwYfrR56pCA33FQxFKNoN828IJsGZc
         jx+KFunxpBnSqh7CZEzgu6ezEwxAKalRHujVTHlo7e8goXFtAAfDAJCm+5W+SW9Zy1
         Ew/6eL6Uz8h1PHzErJ6quytcbvGL4qXsPwGFcWei5Xi4RrqLmX7fNUjZ9xPMg08230
         jHHF+bIYuqbjU9xon9vSrSIqdXM6O1H5lTlOImar5Ly/XMzH2VGngLxCGyQ1wJ8J9J
         sERWGGdU5id2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/62] media: dvb: Add check on sp8870_readreg return
Date:   Mon, 24 May 2021 10:47:15 -0400
Message-Id: <20210524144744.2497894-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index ee893a2f2261..9767159aeb9b 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -280,7 +280,9 @@ static int sp8870_set_frontend_parameters(struct dvb_frontend *fe)
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

