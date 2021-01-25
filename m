Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC6C3033C2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbhAZFEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbhAYSxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62D122063A;
        Mon, 25 Jan 2021 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600781;
        bh=fw0AKS6yGr6dhQxufmepSzV+/4ZNy/50A218e2CH1wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ojs8wSWWrb6e6XDyustOjgvNrKJGtLLJFjB13wK+V5D3tsqoiNz/gi/2bmZjOkWHD
         zLjTKsi0saZVTUyBLbpzIoqlvDnAxItA46Q+dQ0d+JPI7MognOERJyEGHRVdkLUYf0
         MRue+GIg6n0ZPj3dEcywyYnMJchcvjXLb8/ZeNHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnathan Smithinovic <johnathan.smithinovic@gmx.at>,
        Rafael Kitover <rkitover@gmail.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 148/199] x86/cpu/amd: Set __max_die_per_package on AMD
Date:   Mon, 25 Jan 2021 19:39:30 +0100
Message-Id: <20210125183222.461739577@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
@@ -569,12 +569,12 @@ static void bsp_init_amd(struct cpuinfo_
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


