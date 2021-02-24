Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6890323DE5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhBXNUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhBXNKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:10:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE6264D8F;
        Wed, 24 Feb 2021 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171318;
        bh=Hodl3P/Z2rwYON5zwFKUkrcQzjWsue/ipAK5ILCslgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7VwWLKXvMhEi7yMvbVqzotUP8GuubbIOzFpWi/p8DpLG1eIhNm2oY6AruF/Rs2Zu
         K1tH07o9qdvrDG7QHj8cQpx3f8vv/x+/gPe1bStgqUcUrOLDgW6jj4cdvEFHzI9fPt
         whXKaKkke9ApshFIas46dGzY2zSNA8kCbX2V0p5iDHAGR/JBaLqFhs+MxTPJXObLCj
         ifwc17lnO2iO/jjnijb1ed0cfsqkRpq50ON9PiI8HB7lHL8AJwfWqNtxKoU20p6uNR
         KNh38puKT8aa6NPvjwaxL1VuL0KLqK1vGVkKR/Ss/O4oMHxW4DdN0+f4hPg7PNRrRt
         KEXIZy5h21HuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 03/16] vt/consolemap: do font sum unsigned
Date:   Wed, 24 Feb 2021 07:55:00 -0500
Message-Id: <20210224125514.483935-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
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
index a5f88cf0f61d5..a2c1a02f04078 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -493,7 +493,7 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 
 	p2[unicode & 0x3f] = fontpos;
 	
-	p->sum += (fontpos << 20) + unicode;
+	p->sum += (fontpos << 20U) + unicode;
 
 	return 0;
 }
-- 
2.27.0

