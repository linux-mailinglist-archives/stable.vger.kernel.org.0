Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF50C302AA1
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbhAYSqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbhAYSqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 448B6230FE;
        Mon, 25 Jan 2021 18:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600351;
        bh=2KWXftzJXx4/7PwmMtGWo/SJnUinIX1hbGIBvqflhiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uexNLcUA7iTyZTnWp0z2kwQf5mBzgQ2QYTp5KyILYSstYgubFvR91vQ0rZ2lF4J4
         ejXAsq5ofAi/mIOgbHo5Ic+RSozcBCtnmJF7kf35xIiQ2m2tBgXDSRikS8TYSZWEcF
         z76dGHdsEyssRJMpOYe+EC6cxgPprtppPMpYu2VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnathan Smithinovic <johnathan.smithinovic@gmx.at>,
        Rafael Kitover <rkitover@gmail.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 68/86] x86/cpu/amd: Set __max_die_per_package on AMD
Date:   Mon, 25 Jan 2021 19:39:50 +0100
Message-Id: <20210125183203.918912093@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <Yazen.Ghannam@amd.com>

commit 76e2fc63ca40977af893b724b00cc2f8e9ce47a4 upstream.

Set the maximum DIE per package variable on AMD using the
NodesPerProcessor topology value. This will be used by RAPL, among
others, to determine the maximum number of DIEs on the system in order
to do per-DIE manipulations.

 [ bp: Productize into a proper patch. ]

Fixes: 028c221ed190 ("x86/CPU/AMD: Save AMD NodeId as cpu_die_id")
Reported-by: Johnathan Smithinovic <johnathan.smithinovic@gmx.at>
Reported-by: Rafael Kitover <rkitover@gmail.com>
Signed-off-by: Yazen Ghannam <Yazen.Ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Johnathan Smithinovic <johnathan.smithinovic@gmx.at>
Tested-by: Rafael Kitover <rkitover@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=210939
Link: https://lkml.kernel.org/r/20210106112106.GE5729@zn.tnic
Link: https://lkml.kernel.org/r/20210111101455.1194-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -545,12 +545,12 @@ static void bsp_init_amd(struct cpuinfo_
 		u32 ecx;
 
 		ecx = cpuid_ecx(0x8000001e);
-		nodes_per_socket = ((ecx >> 8) & 7) + 1;
+		__max_die_per_package = nodes_per_socket = ((ecx >> 8) & 7) + 1;
 	} else if (boot_cpu_has(X86_FEATURE_NODEID_MSR)) {
 		u64 value;
 
 		rdmsrl(MSR_FAM10H_NODE_ID, value);
-		nodes_per_socket = ((value >> 3) & 7) + 1;
+		__max_die_per_package = nodes_per_socket = ((value >> 3) & 7) + 1;
 	}
 
 	if (!boot_cpu_has(X86_FEATURE_AMD_SSBD) &&


