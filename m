Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F131A4FEE
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgDKMM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbgDKMM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:12:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC0B21556;
        Sat, 11 Apr 2020 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607175;
        bh=RF/7FtoBkCdZOIx0FeDbeiEBYc97KygmB04xbOTg00U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tqor+f8FqUcXOxvuRyGIdas6cjLJH9BXbJEcD523MLPhRSW/LdB9SBM2xi5Vc7lQV
         LSWog2CEDdl8vfe8q1fRiqi2Vakq5BYAAcZ87BPlvBa5nhHGusWAIedz9pABVvp8Iw
         e6FQBcpWu/TMBTh4SLCECK67of2oIXhGPMyZCkhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arun KS <arunks@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 30/32] arm64: Fix size of __early_cpu_boot_status
Date:   Sat, 11 Apr 2020 14:09:09 +0200
Message-Id: <20200411115422.711354253@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun KS <arunks@codeaurora.org>

commit 61cf61d81e326163ce1557ceccfca76e11d0e57c upstream.

__early_cpu_boot_status is of type long. Use quad
assembler directive to allocate proper size.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Arun KS <arunks@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -650,7 +650,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 


