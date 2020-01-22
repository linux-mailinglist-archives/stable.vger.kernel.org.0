Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1916E145530
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgAVNTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729732AbgAVNTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:37 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFA0324685;
        Wed, 22 Jan 2020 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699177;
        bh=4mZaHo6CGGEjhoLAyszHVHx7u6Ppbk9GFGCtN7ajr8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0PhzQ381w7pDeE3XHyMn3qRghTCqr/VroqC3Dl7czhNl+ox+QRa4JIC8Virti+JZ
         BcxgffppOVG1GDwOCWpKUXcc1kZdUYfsuA6UWMdA5mv8vs+2d+x3ymKmUkqzn6WBnj
         KPJLG6i9YkWgztpMcU/V9ymNhdvsi6WoSrd7lKSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 063/222] x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained
Date:   Wed, 22 Jan 2020 10:27:29 +0100
Message-Id: <20200122092838.232080512@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit a006483b2f97af685f0e60f3a547c9ad4c9b9e94 upstream.

If the SME and SEV features are present via CPUID, but memory encryption
support is not enabled (MSR 0xC001_0010[23]), the feature flags are cleared
using clear_cpu_cap(). However, if get_cpu_cap() is later called, these
feature flags will be reset back to present, which is not desired.

Change from using clear_cpu_cap() to setup_clear_cpu_cap() so that the
clearing of the flags is maintained.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 4.16.x-
Link: https://lkml.kernel.org/r/226de90a703c3c0be5a49565047905ac4e94e8f3.1579125915.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -615,9 +615,9 @@ static void early_detect_mem_encrypt(str
 		return;
 
 clear_all:
-		clear_cpu_cap(c, X86_FEATURE_SME);
+		setup_clear_cpu_cap(X86_FEATURE_SME);
 clear_sev:
-		clear_cpu_cap(c, X86_FEATURE_SEV);
+		setup_clear_cpu_cap(X86_FEATURE_SEV);
 	}
 }
 


