Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498FA1A504D
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgDKMQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgDKMQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB62620644;
        Sat, 11 Apr 2020 12:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607385;
        bh=dpfyoqYK+cIid3t/XNrCEQrJnEpFdEWoOdbgFnCpj9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueH+lVx8n4v5MHMBRB8+uwjseSy7LSwMm0PwViGH6YBdUEztiGo9KztJJh5qOy7rw
         9a9GBkPvaeGKOsU19PKDGZhr5jwLvzlQBob53sZy3FQiu8+8ntB7CyV9RK784fn0Zj
         YC6yXBvo7GIwuHnQXaepRpabJzbz/yJ30fAmzu+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arun KS <arunks@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 51/54] arm64: Fix size of __early_cpu_boot_status
Date:   Sat, 11 Apr 2020 14:09:33 +0200
Message-Id: <20200411115513.777221979@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
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
@@ -667,7 +667,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 


