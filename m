Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2079D2E3E57
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437855AbgL1O1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503377AbgL1OZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B99C420731;
        Mon, 28 Dec 2020 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165542;
        bh=3XF4aZgmHdWRYFyRJHXvr/hC0GRTsv7IjCHdkyT1OWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOka8U3u4sWo7EmVzyslWhq2Dm1DuG5bRp5eFXqaxo5dRO8IjIQtrNuC6KRp3LQ4z
         f8uRP5M/+I8ji2XOJ0eJn04zyOf1doUIwfsvYk15xvE+DREfsxtOu1SerLbCCNMVLy
         LCCmH5QRYiVtz3hEhpr/OCqx8rgJn5WL4uyC7p0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 568/717] perf/x86/intel/lbr: Fix the return type of get_lbr_cycles()
Date:   Mon, 28 Dec 2020 13:49:26 +0100
Message-Id: <20201228125048.119381827@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit f8129cd958b395575e5543ce25a8434874b04d3a upstream.

The cycle count of a timed LBR is always 1 in perf record -D.

The cycle count is stored in the first 16 bits of the IA32_LBR_x_INFO
register, but the get_lbr_cycles() return Boolean type.

Use u16 to replace the Boolean type.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201125213720.15692-2-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/lbr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -919,7 +919,7 @@ static __always_inline bool get_lbr_pred
 	return !(info & LBR_INFO_MISPRED);
 }
 
-static __always_inline bool get_lbr_cycles(u64 info)
+static __always_inline u16 get_lbr_cycles(u64 info)
 {
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
 	    !(x86_pmu.lbr_timed_lbr && info & LBR_INFO_CYC_CNT_VALID))


