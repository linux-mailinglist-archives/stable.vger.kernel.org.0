Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E6E323DFD
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbhBXNVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236097AbhBXNNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:13:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC2E964DAF;
        Wed, 24 Feb 2021 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171344;
        bh=0yc8M/MBQ5fgxvg4gQSuDXj8OG+1+X9MKx8JqLuWdto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzUFUU52qRp0jb4Ww6Ewx0AUBjxmwlVRyAbpoJIwvwbwmEeHG+dTcO7V7W7tsu5Do
         JTMhVdZRhtXxAtmiOMBNc1Db3HvPhjiN/biqqnAEeYC1R0pFdFMspEJ8mcaxcJbxQE
         NjQnKqPG3CPiLc/K/nIRiofORiNlaDDJNYf2TejGDo0pnrnCOjT8uTYhETa37XYkDC
         TIfBT5Qt2NQz/1q/C4Oh+GoUYZOpJSKchkZSFJZoubo1KsCicg8MAMJGXKmzDvDfPD
         Et9MGOZN1VPVjAWWQjeNEEcy1v+7xDghea/4dzm0f7i9cbe+mBpQvbH+D/qtP1CMzO
         92tEJLQRvSInw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 03/12] vt/consolemap: do font sum unsigned
Date:   Wed, 24 Feb 2021 07:55:31 -0500
Message-Id: <20210224125540.484221-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125540.484221-1-sashal@kernel.org>
References: <20210224125540.484221-1-sashal@kernel.org>
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
index 9d7ab7b66a8a1..3e668d7c4b57e 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -494,7 +494,7 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 
 	p2[unicode & 0x3f] = fontpos;
 	
-	p->sum += (fontpos << 20) + unicode;
+	p->sum += (fontpos << 20U) + unicode;
 
 	return 0;
 }
-- 
2.27.0

