Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3FE13FE2C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404277AbgAPXdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404273AbgAPXdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D8D2073A;
        Thu, 16 Jan 2020 23:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217586;
        bh=az2890KtbyrSb9tOHkx/aXxpV+On7IOFyMfHxl+d5eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wu37+i8BUcjryDR6Cuyvr+HuTecp9n4ycUODA3v2ZmEZYgqXm9skJf01k0lM8b/sF
         MDh3rlevxefRQ+9vPaWMO7pEFVRNB1Dzp7so9ITOt4zLRcUeAhFtmE4B9+MFgtcknM
         6jEMQJietnHOs/LP1f4QY2GkeIO50wD7MDq45eSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH 4.14 32/71] arm64: add sentinel to kpti_safe_list
Date:   Fri, 17 Jan 2020 00:18:30 +0100
Message-Id: <20200116231714.206616625@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 71c751f2a43fa03fae3cf5f0067ed3001a397013 upstream.

We're missing a sentinel entry in kpti_safe_list. Thus is_midr_in_range_list()
can walk past the end of kpti_safe_list. Depending on the contents of memory,
this could erroneously match a CPU's MIDR, cause a data abort, or other bad
outcomes.

Add the sentinel entry to avoid this.

Fixes: be5b299830c63ed7 ("arm64: capabilities: Add support for checks based on a list of MIDRs")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Juerg Haefliger <juergh@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpufeature.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -836,6 +836,7 @@ static bool unmap_kernel_at_el0(const st
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		{ /* sentinel */ }
 	};
 	char const *str = "kpti command line option";
 	bool meltdown_safe;


