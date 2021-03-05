Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2D232EAEA
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhCEMk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhCEMkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0689664E84;
        Fri,  5 Mar 2021 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948042;
        bh=wbmkcUqPiCV/4tE1uJG/lJv6hlg+wZVX5hO7HXeR1XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEIuapTDVFKU0ggxB5oN24BL/DMgLK0E9sTqsrwafMs7INJ+6Sj2OhoWuuy/7j21d
         4NEq1Pq1NJaob06NP/QyNsnD4bEBUpLsGAu1YTwXOrPb8NanUUlFDkTrR32EU3PoMe
         2upqmax5fPf7l7jOj8bGmwrwlIRuF8Ulo8mnc1OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/39] vt/consolemap: do font sum unsigned
Date:   Fri,  5 Mar 2021 13:22:20 +0100
Message-Id: <20210305120852.834587657@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a5f88cf0f61d..a2c1a02f0407 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -493,7 +493,7 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 
 	p2[unicode & 0x3f] = fontpos;
 	
-	p->sum += (fontpos << 20) + unicode;
+	p->sum += (fontpos << 20U) + unicode;
 
 	return 0;
 }
-- 
2.30.1



