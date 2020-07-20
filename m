Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C4B226B33
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgGTQkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbgGTPrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:47:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A46C2064B;
        Mon, 20 Jul 2020 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260055;
        bh=Swp8vPi5pt2DL5xSBSuUFqwdNoRvMuvcU4GsNIbyCe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xf0ojegXZsH49EYPpWMqpGOU08L5iJnPuqOe0yhSDVw4tFtehJvqvmBme8hCqxbSd
         uyvXvq+3ciUqx9jB74jMY8l8Bq6+Fl1A3M2odDRVkagGLyAirVsePak3Sjn9cf3FYN
         /rIzr1qB+W50mPN156X8z8pyym0r4PFkPBMQwKZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/125] arm64: alternative: Use true and false for boolean values
Date:   Mon, 20 Jul 2020 17:36:39 +0200
Message-Id: <20200720152805.933322350@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit 3c4d9137eefecf273a520d392071ffc9df0a9a7a ]

Return statements in functions returning bool should use true or false
instead of an integer value. This code was detected with the help of
Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/alternative.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 5c4bce4ac381a..b9045d8d05d88 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -47,11 +47,11 @@ static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 	unsigned long replptr;
 
 	if (kernel_text_address(pc))
-		return 1;
+		return true;
 
 	replptr = (unsigned long)ALT_REPL_PTR(alt);
 	if (pc >= replptr && pc <= (replptr + alt->alt_len))
-		return 0;
+		return false;
 
 	/*
 	 * Branching into *another* alternate sequence is doomed, and
-- 
2.25.1



