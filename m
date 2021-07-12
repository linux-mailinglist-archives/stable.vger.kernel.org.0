Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45683C5335
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350729AbhGLHyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244895AbhGLHsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3BE61973;
        Mon, 12 Jul 2021 07:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075775;
        bh=kE+mONDQs2a3rSEQGh2NE3UymG72w/TTf67C7IdCxH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3lhCTKbdB9SHcEs2Vpk0ZYczHda9RUvHeX2tPdJYYTClEsbLSn3KjsKpIuu10EOK
         NbUtzXopIGEtaX+NRWem0P4KCZZxDKXXt+4jLaLaw+/OXYXhzYyLpqQFI/fsTQ0wlC
         VN/H7fwFRub/bNKfrotW/FZuWl3QUH51UwuI9hqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 359/800] x86/hyperv: fix logical processor creation
Date:   Mon, 12 Jul 2021 08:06:22 +0200
Message-Id: <20210712061005.291212610@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Praveen Kumar <kumarpraveen@linux.microsoft.com>

[ Upstream commit 450605c28d571eddca39a65fdbc1338add44c6d9 ]

Microsoft Hypervisor expects the logical processor index to be the same
as CPU's index during logical processor creation. Using cpu_physical_id
confuses hypervisor's scheduler. That causes the root partition not boot
when core scheduler is used.

This patch removes the call to cpu_physical_id and uses the CPU index
directly for bringing up logical processor. This scheme works for both
classic scheduler and core scheduler.

Fixes: 333abaf5abb3 (x86/hyperv: implement and use hv_smp_prepare_cpus)
Signed-off-by: Praveen Kumar <kumarpraveen@linux.microsoft.com>
Link: https://lore.kernel.org/r/20210531074046.113452-1-kumarpraveen@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 22f13343b5da..4fa0a4280895 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -236,7 +236,7 @@ static void __init hv_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_present_cpu(i) {
 		if (i == 0)
 			continue;
-		ret = hv_call_add_logical_proc(numa_cpu_node(i), i, cpu_physical_id(i));
+		ret = hv_call_add_logical_proc(numa_cpu_node(i), i, i);
 		BUG_ON(ret);
 	}
 
-- 
2.30.2



