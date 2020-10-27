Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E877A29C427
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509917AbgJ0OXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758773AbgJ0OXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2A5207C3;
        Tue, 27 Oct 2020 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808611;
        bh=82GcXZDbIcivgRmlOwbWBv25JRjEbhFhmORh4A3grv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMwHJrtZW09x4BXygPqtAwKoEIl2GzWmEepC02j0627n8Os3JRZe3vFIaKedG+fne
         SC2kXaUnuFjXhgh+TGyVtZGWgCZwNoE5kiz9s5NUHk6JjXkBHhVHxIbFkP1Xb7B55D
         9OqzjhSmgDthYvm+pDENj5yVVK11BXXp5sBesDnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/264] powerpc/perf/hv-gpci: Fix starting index value
Date:   Tue, 27 Oct 2020 14:53:36 +0100
Message-Id: <20201027135438.098827282@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 0f9866f7e85765bbda86666df56c92f377c3bc10 ]

Commit 9e9f60108423f ("powerpc/perf/{hv-gpci, hv-common}: generate
requests with counters annotated") adds a framework for defining
gpci counters.
In this patch, they adds starting_index value as '0xffffffffffffffff'.
which is wrong as starting_index is of size 32 bits.

Because of this, incase we try to run hv-gpci event we get error.

In power9 machine:

command#: perf stat -e hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
          -C 0 -I 1000
event syntax error: '..bie_count_and_time_tlbie_instructions_issued/'
                                  \___ value too big for format, maximum is 4294967295

This patch fix this issue and changes starting_index value to '0xffffffff'

After this patch:

command#: perf stat -e hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/ -C 0 -I 1000
     1.000085786              1,024      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     2.000287818              1,024      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/
     2.439113909             17,408      hv_gpci/system_tlbie_count_and_time_tlbie_instructions_issued/

Fixes: 9e9f60108423 ("powerpc/perf/{hv-gpci, hv-common}: generate requests with counters annotated")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201003074943.338618-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-gpci-requests.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/hv-gpci-requests.h b/arch/powerpc/perf/hv-gpci-requests.h
index e608f9db12ddc..8965b4463d433 100644
--- a/arch/powerpc/perf/hv-gpci-requests.h
+++ b/arch/powerpc/perf/hv-gpci-requests.h
@@ -95,7 +95,7 @@ REQUEST(__field(0,	8,	partition_id)
 
 #define REQUEST_NAME system_performance_capabilities
 #define REQUEST_NUM 0x40
-#define REQUEST_IDX_KIND "starting_index=0xffffffffffffffff"
+#define REQUEST_IDX_KIND "starting_index=0xffffffff"
 #include I(REQUEST_BEGIN)
 REQUEST(__field(0,	1,	perf_collect_privileged)
 	__field(0x1,	1,	capability_mask)
@@ -223,7 +223,7 @@ REQUEST(__field(0,	2, partition_id)
 
 #define REQUEST_NAME system_hypervisor_times
 #define REQUEST_NUM 0xF0
-#define REQUEST_IDX_KIND "starting_index=0xffffffffffffffff"
+#define REQUEST_IDX_KIND "starting_index=0xffffffff"
 #include I(REQUEST_BEGIN)
 REQUEST(__count(0,	8,	time_spent_to_dispatch_virtual_processors)
 	__count(0x8,	8,	time_spent_processing_virtual_processor_timers)
@@ -234,7 +234,7 @@ REQUEST(__count(0,	8,	time_spent_to_dispatch_virtual_processors)
 
 #define REQUEST_NAME system_tlbie_count_and_time
 #define REQUEST_NUM 0xF4
-#define REQUEST_IDX_KIND "starting_index=0xffffffffffffffff"
+#define REQUEST_IDX_KIND "starting_index=0xffffffff"
 #include I(REQUEST_BEGIN)
 REQUEST(__count(0,	8,	tlbie_instructions_issued)
 	/*
-- 
2.25.1



