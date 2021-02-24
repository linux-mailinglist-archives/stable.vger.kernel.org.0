Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62A323DC6
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhBXNRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235906AbhBXNIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7734B64F5D;
        Wed, 24 Feb 2021 12:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171279;
        bh=6pGVQAxAiQ+z2ohZ83omDEemHLtN63JK40Vm6GKNJoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/aSwaKDVt9yOpF5tsqScq1+amcqeON104EkY2yzPoYewoMsYl0DS3MlIairIA45F
         Ya/xeZ5Pr5faY53IQWeD2oOvInUF7FoUbnpzo3XQVv9IqKQICFICkib6tqa58FqP5P
         JIU+2/Gy78Xbz434X7ZTLev8d7HlgIWC/5J9ddbrEJ3MGUJWNDkcw3biGLxN4V8qdU
         VtRg2O/4kWwVkZxTec+J+bNmO/ZFxdQ0G5qSjVEeVoQMcDAk6Pn0Ymc6QzB2KxPD+f
         PNTPiPd7YUOILR2B4KyboHezwQki8eulrYzvL4q5Yky5H41FIu5GhMlgizBy/m3KZ4
         Oz3nBFooVnzcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 03/26] vt/consolemap: do font sum unsigned
Date:   Wed, 24 Feb 2021 07:54:11 -0500
Message-Id: <20210224125435.483539-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 9777f8e60e718f7b022a94f2524f967d8def1931 ]

The constant 20 makes the font sum computation signed which can lead to
sign extensions and signed wraps. It's not much of a problem as we build
with -fno-strict-overflow. But if we ever decide not to, be ready, so
switch the constant to unsigned.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210105120239.28031-7-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/consolemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 7c7ada0b3ea00..90c6e10b1ef96 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -495,7 +495,7 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 
 	p2[unicode & 0x3f] = fontpos;
 	
-	p->sum += (fontpos << 20) + unicode;
+	p->sum += (fontpos << 20U) + unicode;
 
 	return 0;
 }
-- 
2.27.0

