Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31040487F9B
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 00:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiAGXve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 18:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiAGXve (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 18:51:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607E5C061574;
        Fri,  7 Jan 2022 15:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A54B827AB;
        Fri,  7 Jan 2022 23:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82029C36AE5;
        Fri,  7 Jan 2022 23:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641599491;
        bh=HDgvXZEnOpD6pk/1GkFzCDWzQxYhAnwtgl62foas9U8=;
        h=Date:From:To:Subject:From;
        b=y/MIe32HBNDqVPFTMou+lTttn8gDLmtRc1H8zcHvX9yEDv2ELez1lSOuoSNHlltau
         YgNb8dJyfU91xswEfPqZDtBAYZhbDvH15lMYZ5fEDPmlffYYTO7Dn7kxXo+mj4oFkW
         qkKi2G4UdeGXFlu3VGRfGiFbtR6rWftcBREgBWF0=
Date:   Fri, 07 Jan 2022 15:51:30 -0800
From:   akpm@linux-foundation.org
To:     deller@gmx.de, mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [to-be-updated]
 usercopy-do-not-fail-on-memory-from-former-init-sections.patch removed from
 -mm tree
Message-ID: <20220107235130.0tLfuD1h7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: usercopy: do not fail on memory from former init sections
has been removed from the -mm tree.  Its filename was
     usercopy-do-not-fail-on-memory-from-former-init-sections.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: usercopy: do not fail on memory from former init sections

On some platforms the memory area between the _stext and the _etext
symbols includes the init sections (parisc and csky).  If the init
sections are freed after bootup, the kernel may reuse this memory.

In one test the usercopy checks if the given address is inside the .text
section (from _stext to _etext), and it wrongly fails on the mentioned
platforms if the memory is from the former init section.

Fix this failure by first checking against the init sections before
checking against the _stext/_etext section.

Link: https://lkml.kernel.org/r/YdeHDDAP+TY5wNeT@ls3530
Fixes: 98400ad75e95 ("parisc: Fix backtrace to always include init funtion names")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/usercopy.c~usercopy-do-not-fail-on-memory-from-former-init-sections
+++ a/mm/usercopy.c
@@ -113,6 +113,15 @@ static bool overlaps(const unsigned long
 	return true;
 }
 
+static bool inside_init_area(const unsigned long ptr, unsigned long n,
+		char *start, char *end)
+{
+	unsigned long initlow = (unsigned long) start;
+	unsigned long inithigh = (unsigned long) end;
+
+	return (ptr >= initlow && (ptr + n) < inithigh);
+}
+
 /* Is this address range in the kernel text area? */
 static inline void check_kernel_text_object(const unsigned long ptr,
 					    unsigned long n, bool to_user)
@@ -121,6 +130,12 @@ static inline void check_kernel_text_obj
 	unsigned long texthigh = (unsigned long)_etext;
 	unsigned long textlow_linear, texthigh_linear;
 
+	/* Ok if inside the former init sections */
+	if (inside_init_area(ptr, n, __init_begin, __init_end))
+		return;
+	if (inside_init_area(ptr, n, _sinittext, _einittext))
+		return;
+
 	if (overlaps(ptr, n, textlow, texthigh))
 		usercopy_abort("kernel text", NULL, to_user, ptr - textlow, n);
 
_

Patches currently in -mm which might be from deller@gmx.de are


