Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83AF395C1A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhEaN23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhEaN0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C7B6140A;
        Mon, 31 May 2021 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467278;
        bh=Sg+oHbjPM3EyWs9U+wsYp0uv2MQ9sKDApoykKutJ+x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7Iln5PAqmDx7IoO/IW/jwP1jLsVMpb/BwbpLCo0+eZ9FilvIkHc3ynJH4pIJSybZ
         hcXfLDGvpp2RaDCEirlhJB+mp61T6N0FIrzYSITTVt1vrqxXOzmwXENLpIyiNMpwEu
         +Di2ppgdQDgTnsFixjSZ+6Wt0k0TrzOuqZ83Ljvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 47/66] media: dvb: Add check on sp8870_readreg return
Date:   Mon, 31 May 2021 15:14:20 +0200
Message-Id: <20210531130637.748204364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



