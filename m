Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A4E323E1C
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhBXNY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:24:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236146AbhBXNOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87EBE64FB4;
        Wed, 24 Feb 2021 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171364;
        bh=kE7cLZshOEuoCki2tIAuGRhd+2IphhHu9B+CoWarbrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j00USz2iPG9+M2PF8Wsou8q4smQEICGm47bpAW5dYp1XgflZmC6C4OJ/JCnVlbTSD
         Re9Q04j2dwc+/zeFaFv15YsTUE2YpdVvzEc0gKwD4Q4YOxMKIwIbfIIyNIoveG4a2g
         0Y0oyQq2ApNKR8s2SvbaUSGNS6bS3k3dfjTi2iF6fp/3Hr8oLjOkeRcWCH2WYvebqE
         +MMrqXOryoTCWonWqVdY3a3qRXR/ca5pPsAGhmGTs8tPnKXOxAdoF8nvrmIe9KbKAl
         bEnCO8u1ocZ+aSVZ65x5a9XZotozqIA5KZTO8Srphe7zEQsRE9qP2Yl1qYbUh8dPac
         KgpgxpHa9U5zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 03/11] vt/consolemap: do font sum unsigned
Date:   Wed, 24 Feb 2021 07:55:51 -0500
Message-Id: <20210224125600.484437-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125600.484437-1-sashal@kernel.org>
References: <20210224125600.484437-1-sashal@kernel.org>
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
index c8c91f0476a22..e8301dcf4c847 100644
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

