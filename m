Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0748323D61
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhBXNIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235589AbhBXND3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE39964F6D;
        Wed, 24 Feb 2021 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171224;
        bh=RAoTi5Dprf/uf0+U4QNMVYiDmLtb4puaDr//W+I7JZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxBV5KvWnwLl6AWXGFzeidYq6h2HxMjcL5yd0OQyJolbLCa5ms+lDUWQRZItuhn8Z
         tAqfT8P+nOK+3qIsPGGQyITCWLuZYJlR4CY1xyZlRC0mUJ4ri5o0FrbLxr4Kvg06Vq
         eXrnP3CIQFMnKaPj0Q6FxdJa/AO5Iu2e+OD1qa/3j/h2uvLwubgHv2smrxLX2JjTny
         CuenJZ1bcgn6s1PrDr8COvYrNzp1ru707b86yHOCkxoG+p7l9YIsucE2XmcUnUr33J
         D+gxAHgRMRviJ2XJ4pHniQMIiyJY87A9p6qXnnkjw5wdHiOQTgOPkN4yE4GR68pSRt
         pNG+48kF2zG4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 03/40] vt/consolemap: do font sum unsigned
Date:   Wed, 24 Feb 2021 07:53:03 -0500
Message-Id: <20210224125340.483162-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
index b28aa0d289f89..251c02af1fc3e 100644
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

