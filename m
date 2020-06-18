Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A181FE5E8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgFRC32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgFRBQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B6B221D79;
        Thu, 18 Jun 2020 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442971;
        bh=nZJGhbo9IBSAjzvkZkeVSYjGPNmAlmVn/KRbXGPmTRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bpd7WL6baf3QA5Pbgk40JFRk2iHTqBQwtJa3w/FE+GcJgkNAFSx2d3gxi+AfCdowr
         txs7of+h0jPupQLVi4LdjIzftTFFLNFrLVKqeHA2C90rtaTIEbxgL64DXSgfEt9Zlv
         QeXjI4MUdAngeJWb4C27x+ajzzn9Na44ecr2ZL4E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, kbuild test robot <lkp@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 375/388] x86/mce/dev-mcelog: Fix -Wstringop-truncation warning about strncpy()
Date:   Wed, 17 Jun 2020 21:07:52 -0400
Message-Id: <20200618010805.600873-375-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d089567a9ce8..bcb379b2fd42 100644
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

