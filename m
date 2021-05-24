Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36FC38EA6F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhEXOzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233881AbhEXOxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:53:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD4F6141F;
        Mon, 24 May 2021 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867705;
        bh=jLKy2fs+izQ6dpIvDbWD8/SxmqacVqGQoXpuCfbhMlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/cT3NSqnsHrlmT2K/ANHmCY0Ky6EVHpCUuoYHDMIQl3f9Kj9XoH7Thp9Q6P69S4G
         7GCPVNItzo43g4xKiMl8/xhpocTMRZ28s6Molgo4eZcZmnpO6I0fBQHhB+6McejohH
         PRBJOdRoyg6+9kVWLVbIY1OwLXMW0N+83aPdt1rqOE0DVVxEwX3D4MuI93/PUBGq3c
         016X/9Pcsqj4zBTbbLZAxjgSwx7lm9IPTB0kEZoEj2aOfebUNEcve/+EOS4Sq+mdin
         PNlUccP+OwLGA6YkO8fZY6uRKWxNCSmb7w9dooJ14QcsNeiCPZaO9+uATw3HNKywA3
         Ssn9N8e5MPlnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/62] Revert "media: dvb: Add check on sp8870_readreg"
Date:   Mon, 24 May 2021 10:47:14 -0400
Message-Id: <20210524144744.2497894-33-sashal@kernel.org>
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

