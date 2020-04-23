Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3887F1B69B4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgDWXZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48154 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727913AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004ZP-4G; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6ep-Jm; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>, "Borislav Petkov" <bp@alien8.de>
Date:   Fri, 24 Apr 2020 00:03:56 +0100
Message-ID: <lsq.1587683028.477119961@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 009/245] x86/microcode/AMD: Add support for fam17h
 microcode loading
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit f4e9b7af0cd58dd039a0fb2cd67d57cea4889abf upstream.

The size for the Microcode Patch Block (MPB) for an AMD family 17h
processor is 3200 bytes.  Add a #define for fam17h so that it does
not default to 2048 bytes and fail a microcode load/update.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@alien8.de>
Link: https://lkml.kernel.org/r/20171130224640.15391.40247.stgit@tlendack-t1.amdoffice.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/microcode/amd.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -154,6 +154,7 @@ static unsigned int verify_patch_size(u8
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
 #define F16H_MPB_MAX_SIZE 3458
+#define F17H_MPB_MAX_SIZE 3200
 
 	switch (family) {
 	case 0x14:
@@ -165,6 +166,9 @@ static unsigned int verify_patch_size(u8
 	case 0x16:
 		max_size = F16H_MPB_MAX_SIZE;
 		break;
+	case 0x17:
+		max_size = F17H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size = F1XH_MPB_MAX_SIZE;
 		break;

