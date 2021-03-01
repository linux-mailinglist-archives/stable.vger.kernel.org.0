Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD5332912B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbhCAUUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242998AbhCAUNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1E1965108;
        Mon,  1 Mar 2021 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621682;
        bh=mRdSwgeQd/2G7ngA4pQHNHZ0JtEOtQRqSuRJZ+VPJf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/ct0Y9ELa6xHkW1Y41i2rY3FkoBv2vKJeaLxulyhvJE7w8G9EdKPew57VQgerE8g
         OxObLY3bSllOwO4Q+k1IJ+xcSrgazAmt+DdCyhFZKmd+RqVi7/sqt/psd1LM6Iopmc
         f+gRBciCC0bsNOLgr2vIEj2dI3Q0jB0e9u+4+xQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Kevin Hao <haokexin@gmail.com>
Subject: [PATCH 5.11 606/775] Revert "MIPS: Octeon: Remove special handling of CONFIG_MIPS_ELF_APPENDED_DTB=y"
Date:   Mon,  1 Mar 2021 17:12:54 +0100
Message-Id: <20210301161231.361106972@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit fe82de91af83a9212b6c704b1ce6cf6d129a108b upstream.

This reverts commit d9df9fb901d25b941ab2cfb5b570d91fb2abf7a3.

For the OCTEON boards, it need to patch the built-in DTB before using
it. Previously it judges if it is a built-in DTB by checking
fw_passed_dtb. But after commit 37e5c69ffd41 ("MIPS: head.S: Init
fw_passed_dtb to builtin DTB", the fw_passed_dtb is initialized even
when using built-in DTB. This causes the OCTEON boards boot broken due
to an unpatched built-in DTB is used. Revert the commit d9df9fb901d2 to
restore the codes before the fw_passed_dtb is used and then fix this
issue.

Fixed: 37e5c69ffd41 ("MIPS: head.S: Init fw_passed_dtb to builtin DTB")
Cc: stable@vger.kernel.org
Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/cavium-octeon/setup.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -1149,12 +1149,15 @@ void __init device_tree_init(void)
 	bool do_prune;
 	bool fill_mac;
 
-	if (fw_passed_dtb) {
-		fdt = (void *)fw_passed_dtb;
+#ifdef CONFIG_MIPS_ELF_APPENDED_DTB
+	if (!fdt_check_header(&__appended_dtb)) {
+		fdt = &__appended_dtb;
 		do_prune = false;
 		fill_mac = true;
 		pr_info("Using appended Device Tree.\n");
-	} else if (octeon_bootinfo->minor_version >= 3 && octeon_bootinfo->fdt_addr) {
+	} else
+#endif
+	if (octeon_bootinfo->minor_version >= 3 && octeon_bootinfo->fdt_addr) {
 		fdt = phys_to_virt(octeon_bootinfo->fdt_addr);
 		if (fdt_check_header(fdt))
 			panic("Corrupt Device Tree passed to kernel.");


