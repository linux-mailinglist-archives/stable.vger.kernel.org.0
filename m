Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C886D171A8F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbgB0Nyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbgB0Nyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:54:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4330B20578;
        Thu, 27 Feb 2020 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811691;
        bh=gAkfpv4ncOrLT6/j6G/W8e8xXZzuNMbpqDoVeHHi7gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QttkLMyjbAYDh6QnwWD8Om3jrBg+wQfe6TCOmS55GlK0pxbjEplQ8oEWWVFXuCQmD
         b96ic67PUnXftpoLW06XQTsmJBieTyRVNexA/NJAxdjTUSPMyo7dUIbP9m+0Wr0ObR
         jCqXiY4FX7sIHgSooUXniozMYg9ddyi33iHns/P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christopher Head <chead@chead.ca>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 063/237] x86/sysfb: Fix check for bad VRAM size
Date:   Thu, 27 Feb 2020 14:34:37 +0100
Message-Id: <20200227132301.643019415@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit dacc9092336be20b01642afe1a51720b31f60369 ]

When checking whether the reported lfb_size makes sense, the height
* stride result is page-aligned before seeing whether it exceeds the
reported size.

This doesn't work if height * stride is not an exact number of pages.
For example, as reported in the kernel bugzilla below, an 800x600x32 EFI
framebuffer gets skipped because of this.

Move the PAGE_ALIGN to after the check vs size.

Reported-by: Christopher Head <chead@chead.ca>
Tested-by: Christopher Head <chead@chead.ca>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206051
Link: https://lkml.kernel.org/r/20200107230410.2291947-1-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 85195d447a922..f3215346e47fd 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -94,11 +94,11 @@ __init int create_simplefb(const struct screen_info *si,
 	if (si->orig_video_isVGA == VIDEO_TYPE_VLFB)
 		size <<= 16;
 	length = mode->height * mode->stride;
-	length = PAGE_ALIGN(length);
 	if (length > size) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
 		return -EINVAL;
 	}
+	length = PAGE_ALIGN(length);
 
 	/* setup IORESOURCE_MEM as framebuffer memory */
 	memset(&res, 0, sizeof(res));
-- 
2.20.1



