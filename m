Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B03395F11
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhEaOHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231670AbhEaOFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAF261954;
        Mon, 31 May 2021 13:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468309;
        bh=jLKy2fs+izQ6dpIvDbWD8/SxmqacVqGQoXpuCfbhMlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZ75mE+mtIsTp0StiOrARYamw8SBmP49Grxbhd9lyMPbUPL4RcjsI4maW0NBDw8xy
         MOg6qXELWjHYl27WgqRNOG/I5w0l2mfngy+gxjFNflu5vRSkG3jIIe7/WtcAAqVTDk
         f/H9teBroSWiIDvgLJ/Bw4nyNqDLleBR3S5dkZyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/252] Revert "media: dvb: Add check on sp8870_readreg"
Date:   Mon, 31 May 2021 15:13:45 +0200
Message-Id: <20210531130703.456789726@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 47e4ff06fa7f5ba4860543a2913bbd0c164640aa ]

This reverts commit 467a37fba93f2b4fe3ab597ff6a517b22b566882.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This commit is not properly checking for an error at all, so if a
read succeeds from this device, it will error out.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-59-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/sp8870.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 655db8272268..ee893a2f2261 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -280,9 +280,7 @@ static int sp8870_set_frontend_parameters(struct dvb_frontend *fe)
 	sp8870_writereg(state, 0xc05, reg0xc05);
 
 	// read status reg in order to clear pending irqs
-	err = sp8870_readreg(state, 0x200);
-	if (err)
-		return err;
+	sp8870_readreg(state, 0x200);
 
 	// system controller start
 	sp8870_microcontroller_start(state);
-- 
2.30.2



