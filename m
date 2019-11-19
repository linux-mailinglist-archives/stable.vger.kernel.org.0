Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE381016C7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbfKSFyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbfKSFyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F77B21850;
        Tue, 19 Nov 2019 05:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142841;
        bh=YRs4s1sjG7eJRwKwYyVft9OLeY3xfnyFEOZciMSfYyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQ2VYrdXkm6OwoV+fbXQ/I7SQOsnmRrNGI+iOT6AwdCvcAkVqs9+hOCkqi8K8z2/R
         zyouo8RsGYR6LYrtwy8J1ok6yunHI9kJ/jpia9JoC3fxZ1bKCWDFZ8S1+cPYs+go8Y
         rMEc+aJEuGNV+NxTUBMJfw1ZbtNZlFZHmTRixooY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 168/239] x86/mce-inject: Reset injection struct after injection
Date:   Tue, 19 Nov 2019 06:19:28 +0100
Message-Id: <20191119051333.812788327@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 7401a633c34adc7aefd3edfec60074cb0475a3e8 ]

Clear the MCE struct which is used for collecting the injection details
after injection.

Also, populate it with more details from the machine.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20180905081954.10391-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 8fec687b3e44e..f12141ba9a76d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -108,6 +108,9 @@ static void setup_inj_struct(struct mce *m)
 	memset(m, 0, sizeof(struct mce));
 
 	m->cpuvendor = boot_cpu_data.x86_vendor;
+	m->time	     = ktime_get_real_seconds();
+	m->cpuid     = cpuid_eax(1);
+	m->microcode = boot_cpu_data.microcode;
 }
 
 /* Update fake mce registers on current CPU. */
@@ -576,6 +579,9 @@ static int inj_bank_set(void *data, u64 val)
 	m->bank = val;
 	do_inject();
 
+	/* Reset injection struct */
+	setup_inj_struct(&i_mce);
+
 	return 0;
 }
 
-- 
2.20.1



