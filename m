Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4053C395CAB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhEaNg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232708AbhEaNeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83396613EE;
        Mon, 31 May 2021 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467489;
        bh=NVhnBFxxbsod3bZ71tcKvqdmuRUUR+JQxC8nBsemxoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOMBNZcleDlUyUMShTXu7y6Tr8O+TTkNrVNKyBhtiNZQQ+dRf7e3plpmM6tkoAXPV
         Hggp1O33Ur2FqC7T/L9/DsG55hBOsGHxtLaL5wiJqYDM2A/3C8qA7EZ+zN/PUshZS2
         N7PEKloboCRcc2Uh7FccxM1EpGHbqJLVanlryNfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/116] media: dvb: Add check on sp8870_readreg return
Date:   Mon, 31 May 2021 15:14:21 +0200
Message-Id: <20210531130643.030295334@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
index 8d31cf3f4f07..3a577788041d 100644
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



