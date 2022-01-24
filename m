Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817A249A977
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322607AbiAYDWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56570 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356389AbiAXUbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C734F61507;
        Mon, 24 Jan 2022 20:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88B7C340E7;
        Mon, 24 Jan 2022 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056306;
        bh=jSECrfroaRL6gnqItNOsQdsp2IFqaB2YwhTsNYAREpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbkL7rZcAadjGGXiERffxLUBraxnHOt+gS5W3FLHh8bW2GzSm0cQiDXQguUIZFGCF
         ZAUs0937BkD1Uvx+bbpiLg6CqyoMT3QiZeP53zbVroQp6Q84nqkjwCYac3fRQEY0Lf
         CHYNCQr46COSyH0EzURxWBRq36DGvP/0/ISTaoCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/846] powerpc/xive: Add missing null check after calling kmalloc
Date:   Mon, 24 Jan 2022 19:39:18 +0100
Message-Id: <20220124184116.179143525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



