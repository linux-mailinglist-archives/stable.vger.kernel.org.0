Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627E91A5014
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgDKMOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgDKMOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 129762084D;
        Sat, 11 Apr 2020 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607252;
        bh=OAXT5E/SSyW+JX7nZSn+6Jurvzzq/yW8/4K4NfgDWaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbFursIztlEWN9ejkjtts2BsRZUFcAhvpdeeK9mqxdc6qaeY0hfKIjDJOmmAS36nC
         lySAmdCm2dWPJ7IeG+dAoa9H9ooHAXQXLhtKxM1ykpOMOnhXD9DeWG+odRrXTdl2qe
         0ndZY3ODZrugsneOy5yS+ahIzn7h4mKwSLfRKD/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arun KS <arunks@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 35/38] arm64: Fix size of __early_cpu_boot_status
Date:   Sat, 11 Apr 2020 14:09:19 +0200
Message-Id: <20200411115441.248030906@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
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
@@ -558,7 +558,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 


