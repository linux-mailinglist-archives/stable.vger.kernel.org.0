Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA48205DEC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389623AbgFWUSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389616AbgFWUR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 521F12064B;
        Tue, 23 Jun 2020 20:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943477;
        bh=4dCn1E3y2lsNH/aZZpCpK8OpPJhFa/TNxEoJEzBdOJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHp54yvqZXAB9oCLJ7R1aLO2wD22BidZ7/EyHy5na4ntQGfZtRgP4lkf2938e2wMJ
         BZ41AnCS+sxAfgrB5ysa4NiqVRebGsNjE6UPgv7HyB9UkCH6pLsBiSeMi8cgp4UkcT
         OpKMRHmOrlQG4I4XWHVNHwYjVinMft/84ueSwX8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 367/477] x86/mce/dev-mcelog: Fix -Wstringop-truncation warning about strncpy()
Date:   Tue, 23 Jun 2020 21:56:04 +0200
Message-Id: <20200623195424.879067556@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 7ccddc4613db446dc3cbb69a3763ba60ec651d13 ]

The kbuild test robot reported this warning:

  arch/x86/kernel/cpu/mce/dev-mcelog.c: In function 'dev_mcelog_init_device':
  arch/x86/kernel/cpu/mce/dev-mcelog.c:346:2: warning: 'strncpy' output \
    truncated before terminating nul copying 12 bytes from a string of the \
    same length [-Wstringop-truncation]

This is accurate, but I don't care that the trailing NUL character isn't
copied. The string being copied is just a magic number signature so that
crash dump tools can be sure they are decoding the right blob of memory.

Use memcpy() instead of strncpy().

Fixes: d8ecca4043f2 ("x86/mce/dev-mcelog: Dynamically allocate space for machine check records")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200527182808.27737-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/dev-mcelog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/dev-mcelog.c b/arch/x86/kernel/cpu/mce/dev-mcelog.c
index d089567a9ce82..bcb379b2fd42e 100644
--- a/arch/x86/kernel/cpu/mce/dev-mcelog.c
+++ b/arch/x86/kernel/cpu/mce/dev-mcelog.c
@@ -343,7 +343,7 @@ static __init int dev_mcelog_init_device(void)
 	if (!mcelog)
 		return -ENOMEM;
 
-	strncpy(mcelog->signature, MCE_LOG_SIGNATURE, sizeof(mcelog->signature));
+	memcpy(mcelog->signature, MCE_LOG_SIGNATURE, sizeof(mcelog->signature));
 	mcelog->len = mce_log_len;
 	mcelog->recordlen = sizeof(struct mce);
 
-- 
2.25.1



