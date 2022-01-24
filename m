Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A954998E4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453653AbiAXVaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38990 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450514AbiAXVUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:20:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B927B8122A;
        Mon, 24 Jan 2022 21:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DDDC340E4;
        Mon, 24 Jan 2022 21:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059242;
        bh=jSECrfroaRL6gnqItNOsQdsp2IFqaB2YwhTsNYAREpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FK+WdRPGTGbxXmsYUEMr4CGo1hbxvACrv9wdL7J2lY6KR4QnbFBSiyS4hctE3lxO7
         rB5PXpFVyxXDqSY0JeJtP8Dx9P61EAISci+W21z9KfpiXawQ+bvX73MwLtpCWTeYXh
         8vFmOhxgWmgIUNSYsvO57qXZHLfYoTlZHvhivRhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0517/1039] powerpc/xive: Add missing null check after calling kmalloc
Date:   Mon, 24 Jan 2022 19:38:26 +0100
Message-Id: <20220124184142.670010140@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gmail.com>

[ Upstream commit 18dbfcdedc802f9500b2c29794f22a31d27639c0 ]

Commit 930914b7d528fc ("powerpc/xive: Add a debugfs file to dump
internal XIVE state") forgot to add a null check.

Add it.

Fixes: 930914b7d528fc6b0249bffc00564100bcf6ef75 ("powerpc/xive: Add a debugfs file to dump internal XIVE state")
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211226135314.251221-1-ammar.faizi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/spapr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index f143b6f111ac0..1179632560b8d 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -653,6 +653,9 @@ static int xive_spapr_debug_show(struct seq_file *m, void *private)
 	struct xive_irq_bitmap *xibm;
 	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
+	if (!buf)
+		return -ENOMEM;
+
 	list_for_each_entry(xibm, &xive_irq_bitmaps, list) {
 		memset(buf, 0, PAGE_SIZE);
 		bitmap_print_to_pagebuf(true, buf, xibm->bitmap, xibm->count);
-- 
2.34.1



