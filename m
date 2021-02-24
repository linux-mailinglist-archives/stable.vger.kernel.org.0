Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4C323C94
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhBXMv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235109AbhBXMv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:51:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F93264ED1;
        Wed, 24 Feb 2021 12:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171034;
        bh=z7tAcqTmdQ1mcVuw2w62DS7gSBJPS8jweKLjCRJd+ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GocUSImpz8emMleyu7FCgfyqaULS/xHnO3lzuIwSxzdE/7SMq53eh3plZjnMB9K8E
         dhdyEiD1Zao5c1eVlP4pqoWlPyts9issa9FDkqIPq0p+0rECDvNsAuPaEEGFfmf4RU
         wOrq/jjNVKz6AgKnF7yDxeS3irzdpiAKWg4GHBjnxwr9xVsQM7qWKcsecp8Gtd2HbK
         nEIEIHHDj10wpkF0LydLPHHJfV48TPPwOVPJOLgNQzZXPWEcH7MWsXgW/LYrwGymap
         j87rlP6Ddgv7FRdPOnsFIDr0bkNIIsXoXEqmOqu4uT629Dcv4b5rl10TbLBBhe8MH/
         Ux/GcL4Mm0pEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 06/67] vt/consolemap: do font sum unsigned
Date:   Wed, 24 Feb 2021 07:49:24 -0500
Message-Id: <20210224125026.481804-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index f7d015c67963d..d815ac98b39e3 100644
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

