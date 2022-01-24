Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36382499696
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445863AbiAXVFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391136AbiAXUq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38380C0619CD;
        Mon, 24 Jan 2022 11:57:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A2EB8128F;
        Mon, 24 Jan 2022 19:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DBBC33DA3;
        Mon, 24 Jan 2022 19:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054240;
        bh=e/pMVKumLe2FHFOwgK2m3U8iURjNJRFnpl9Hmy2/nEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wY6sXAsiJCr/+Sa/3mEg7RN8fC08hrtMERN+z/2JIG8MTwzJ8+Y4QGlVax1zjwrt5
         Xxv5CklEJIv70W68kWph5nL9APbxJs3ZpAbBnEvHGDYpNwPDrHFccj7YQaQiwwFHI/
         q9vmf/fGzgqIni8HA5VNu80EcD+wu6ICotjrP8Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/563] powerpc/xive: Add missing null check after calling kmalloc
Date:   Mon, 24 Jan 2022 19:40:56 +0100
Message-Id: <20220124184034.517499362@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 1e3674d7ea7bc..b57eeaff7bb33 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -658,6 +658,9 @@ static int xive_spapr_debug_show(struct seq_file *m, void *private)
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



