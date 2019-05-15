Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1C61ED74
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfEOLJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbfEOLJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FAED2084F;
        Wed, 15 May 2019 11:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918571;
        bh=Pv+cuU1oQq8sv5bQHcuM70TsMYPx2umA4E6VGL4RuXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zykT1a+jGj3zbveM0ZR/7QzYYXnzA4xkUDp7ZLbjV9knpe+LTDqwCMr7T2NR6kIUG
         r45C8QLo9xOrElHHW7kbymqhYcHzdNfNof1q2QN12SGgIdA2jKwSkfBKKnBT8sZK7M
         eqTWr7Gyh1Sx8w14UpMmYr4YC15gkrbgNHBjyZtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 183/266] x86/MCE: Save microcode revision in machine check records
Date:   Wed, 15 May 2019 12:54:50 +0200
Message-Id: <20190515090729.120763201@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit fa94d0c6e0f3431523f5701084d799c77c7d4a4f upstream.

Updating microcode used to be relatively rare. Now that it has become
more common we should save the microcode version in a machine check
record to make sure that those people looking at the error have this
important information bundled with the rest of the logged information.

[ Borislav: Simplify a bit. ]

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Link: http://lkml.kernel.org/r/20180301233449.24311-1-tony.luck@intel.com
[bwh: Backported to 4.4:
 - Also add earlier fields to struct mce, to match upstream UAPI
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/uapi/asm/mce.h  |    4 ++++
 arch/x86/kernel/cpu/mcheck/mce.c |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/include/uapi/asm/mce.h
+++ b/arch/x86/include/uapi/asm/mce.h
@@ -26,6 +26,10 @@ struct mce {
 	__u32 socketid;	/* CPU socket ID */
 	__u32 apicid;	/* CPU initial apic ID */
 	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
+	__u64 synd;	/* MCA_SYND MSR: only valid on SMCA systems */
+	__u64 ipid;	/* MCA_IPID MSR: only valid on SMCA systems */
+	__u64 ppin;	/* Protected Processor Inventory Number */
+	__u32 microcode;/* Microcode revision */
 };
 
 #define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -138,6 +138,8 @@ void mce_setup(struct mce *m)
 	m->socketid = cpu_data(m->extcpu).phys_proc_id;
 	m->apicid = cpu_data(m->extcpu).initial_apicid;
 	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
+
+	m->microcode = boot_cpu_data.microcode;
 }
 
 DEFINE_PER_CPU(struct mce, injectm);
@@ -258,7 +260,7 @@ static void print_mce(struct mce *m)
 	 */
 	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
 		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
-		cpu_data(m->extcpu).microcode);
+		m->microcode);
 
 	/*
 	 * Print out human-readable details about the MCE error,


