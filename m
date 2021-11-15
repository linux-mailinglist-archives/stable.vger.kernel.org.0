Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D5245249F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381528AbhKPBka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241362AbhKOS1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:27:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CFBB6343F;
        Mon, 15 Nov 2021 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999015;
        bh=04nlsfCbqECDzqv36aCkLubUFGayCyA6UJibP0ieFj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbdftVZ0h8WYB4jk2VtCRSLMXKt54wWPkOZDRi7S8n3gv2oFM1MEKXbvNvYSRX4fV
         ZxgsdO4wYntgKzYqxcFNk2VjYCIbmDscjGEL7hLx2J5zgoDiIlX91nCPBOQCo2GVZX
         EdGPdbCzry3gV02XCo2690k6hU4B88pM5x93/rH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5.14 138/849] perf/x86/intel/uncore: Fix invalid unit check
Date:   Mon, 15 Nov 2021 17:53:41 +0100
Message-Id: <20211115165424.796341945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit e2bb9fab08cbcc7922050c7eb0bd650807abfa4e upstream.

The uncore unit with the type ID 0 and the unit ID 0 is missed.

The table3 of the uncore unit maybe 0. The
uncore_discovery_invalid_unit() mistakenly treated it as an invalid
value.

Remove the !unit.table3 check.

Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1629991963-102621-3-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_discovery.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/uncore_discovery.h
+++ b/arch/x86/events/intel/uncore_discovery.h
@@ -30,7 +30,7 @@
 
 
 #define uncore_discovery_invalid_unit(unit)			\
-	(!unit.table1 || !unit.ctl || !unit.table3 ||	\
+	(!unit.table1 || !unit.ctl || \
 	 unit.table1 == -1ULL || unit.ctl == -1ULL ||	\
 	 unit.table3 == -1ULL)
 


