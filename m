Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CE12F208
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfE3ERx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbfE3DPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDED12449A;
        Thu, 30 May 2019 03:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186137;
        bh=dfEg2HOpaul2hogvunM38ZcGW3iNqFcO1GoCYEy8P4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXCgC0qpqaGlWdUqT0r+Y2HWiouWj4JjD3dS0n3La9DnPxYP9pflWqHy8G36A+ocQ
         xY8QP5NXbqNMw3URAtkWR1JjKQLiozGROKJzEaFXzmpGCYGJdgbIjl2ZRNsXz6stnj
         0TpEzXa8pYgU7KAbUhllS8nlCmC6Orj78xy/2h6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 260/346] efifb: Omit memory map check on legacy boot
Date:   Wed, 29 May 2019 20:05:33 -0700
Message-Id: <20190530030554.145227123@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c2999c281ea2d2ebbdfce96cecc7b52e2ae7c406 ]

Since the following commit:

  38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")

efifb_probe() checks its memory range via efi_mem_desc_lookup(),
and this leads to a spurious error message:

   EFI_MEMMAP is not enabled

at every boot on KVM.  This is quite annoying since the error message
appears even if you set "quiet" boot option.

Since this happens on legacy boot, which strangely enough exposes
a EFI framebuffer via screen_info, let's double check that we are
doing an EFI boot before attempting to access the EFI memory map.

Reported-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20190328193429.21373-3-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/efifb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index fd02e8a4841d6..9f39f0c360e0c 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -464,7 +464,8 @@ static int efifb_probe(struct platform_device *dev)
 	info->apertures->ranges[0].base = efifb_fix.smem_start;
 	info->apertures->ranges[0].size = size_remap;
 
-	if (!efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
+	if (efi_enabled(EFI_BOOT) &&
+	    !efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
 		if ((efifb_fix.smem_start + efifb_fix.smem_len) >
 		    (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
 			pr_err("efifb: video memory @ 0x%lx spans multiple EFI memory regions\n",
-- 
2.20.1



