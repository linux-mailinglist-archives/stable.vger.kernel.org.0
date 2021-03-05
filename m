Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83E032E9EB
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhCEMfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:35:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232777AbhCEMfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:35:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CDA365014;
        Fri,  5 Mar 2021 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947722;
        bh=PW2fa8qYx353il6tXa/TNNcw3cuoqbRPun42E3U8Gj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqKd3ZXP4c5IAPlBc3oXCm6NFn8YrITWSuxB5JPOdGn35Mzp17mfdiqOx+DIacWbt
         2I+xdMXsj+TErf+bU9yOKDsI/FCO74Abq03RRsIdN+xypqE3RaEucB8+wMpDAMMVZi
         VUoWVQBOw9GEir+TNxFih4UTIvJ/SIxM9aklo7uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/72] vt/consolemap: do font sum unsigned
Date:   Fri,  5 Mar 2021 13:21:32 +0100
Message-Id: <20210305120858.813352606@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
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
index b28aa0d289f8..251c02af1fc3 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -495,7 +495,7 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 
 	p2[unicode & 0x3f] = fontpos;
 	
-	p->sum += (fontpos << 20) + unicode;
+	p->sum += (fontpos << 20U) + unicode;
 
 	return 0;
 }
-- 
2.30.1



