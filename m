Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED64C24BE0B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgHTNRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgHTJet (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229DF207DE;
        Thu, 20 Aug 2020 09:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916089;
        bh=8eyZqrQdSc8PNwaGCnhdZg1jsbuGpXLV1x4V+wSRQOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJEiDToEA+iT/p5yjdUlNZc/MG2KtDnqk03vGJzjQPS8t4S4sD2s9lhJpdqT1A+Fi
         Df12TOs30LI2rYZwyUMmoRRz/hILxn8lTEbuaGycJphoEYd71hsQZikAeLjvqomd0v
         ly9dmPw2MwDanduQCp1pd/cOkXLC1qsQHTVDUfpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 219/232] sh: fault: Fix duplicate printing of "PC:"
Date:   Thu, 20 Aug 2020 11:21:10 +0200
Message-Id: <20200820091623.398844230@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 845d9156febcd6b3b20c0c2c8d73b461b48e844c ]

Somewhere along the patch handling path, both the old "printk(KERN_ALERT
....)" and the new "pr_alert(...)" were retained, leading to the
duplicate printing of "PC:".

Drop the old one.

Fixes: eaabf98b0932a540 ("sh: fault: modernize printing of kernel messages")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/mm/fault.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sh/mm/fault.c b/arch/sh/mm/fault.c
index fbe1f2fe9a8c8..acd1c75994983 100644
--- a/arch/sh/mm/fault.c
+++ b/arch/sh/mm/fault.c
@@ -208,7 +208,6 @@ show_fault_oops(struct pt_regs *regs, unsigned long address)
 	if (!oops_may_print())
 		return;
 
-	printk(KERN_ALERT "PC:");
 	pr_alert("BUG: unable to handle kernel %s at %08lx\n",
 		 address < PAGE_SIZE ? "NULL pointer dereference"
 				     : "paging request",
-- 
2.25.1



