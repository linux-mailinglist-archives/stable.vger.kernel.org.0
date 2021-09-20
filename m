Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D534411CEC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344516AbhITRPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346016AbhITRNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:13:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E74A619E3;
        Mon, 20 Sep 2021 16:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157065;
        bh=3kytqInYdaIIpA3k8cdBnOFVmrir0kc23ypTP2INWoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=En35OBWEBYsC6ylK96oWSEhc393UY4Mn9EaooYyvNsLw5T1+0cOTlN246tIM0MwzB
         AqZvCSrvS68UTTxDwhqTZ4xdMmprc87pye9dgg8ippoyC8k4XdkUsDsiu9KX9cFt2H
         1Y7ZMeYv/oRD6UEys72SpdSvVZgoPvbnh0NYBKpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 006/217] perf/x86/intel/pt: Fix mask of num_address_ranges
Date:   Mon, 20 Sep 2021 18:40:27 +0200
Message-Id: <20210920163924.821138944@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit c53c6b7409f4cd9e542991b53d597fbe2751d7db ]

Per SDM, bit 2:0 of CPUID(0x14,1).EAX[2:0] reports the number of
configurable address ranges for filtering, not bit 1:0.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lkml.kernel.org/r/20210824040622.4081502-1-xiaoyao.li@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 0661227d935c..990ca9614b23 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -69,7 +69,7 @@ static struct pt_cap_desc {
 	PT_CAP(topa_multiple_entries,	0, CPUID_ECX, BIT(1)),
 	PT_CAP(single_range_output,	0, CPUID_ECX, BIT(2)),
 	PT_CAP(payloads_lip,		0, CPUID_ECX, BIT(31)),
-	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x3),
+	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x7),
 	PT_CAP(mtc_periods,		1, CPUID_EAX, 0xffff0000),
 	PT_CAP(cycle_thresholds,	1, CPUID_EBX, 0xffff),
 	PT_CAP(psb_periods,		1, CPUID_EBX, 0xffff0000),
-- 
2.30.2



