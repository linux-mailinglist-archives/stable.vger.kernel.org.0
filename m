Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5B239621A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhEaOvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234016AbhEaOtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:49:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D7C61C94;
        Mon, 31 May 2021 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469421;
        bh=HbHEhZjevRB4CeDDwC7R5m9J42CXq3lr/RUWKX8V39w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/IhyixjhCgwl4utvglupWnUqz9hqcEBVl4eyvxS85lSxAZIHKO/Zn/ftGP6W5iJt
         1qAqCw1ujxJ1qFiZXYsCPzypTUqbUekYxGuwpnzJbH60GfVIGCdfsgE1S4/SGDbTdn
         JfrXwqSP658CQpnjG5c4jobRdEFW0bN4Mvxzfx0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 191/296] media: dvb: Add check on sp8870_readreg return
Date:   Mon, 31 May 2021 15:14:06 +0200
Message-Id: <20210531130710.295465213@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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



