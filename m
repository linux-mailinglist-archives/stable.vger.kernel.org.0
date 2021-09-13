Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997DA40947E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbhIMObb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346887AbhIMO3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C032615A7;
        Mon, 13 Sep 2021 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541048;
        bh=qQ8jGAPDTJUFuzuBdGRvDqaxOg8Q2tXTxaqa0Oocntc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpICZtoBRwxJKY5lv7KSSd/RjTyfHoZWO5M7FW2bzNgqpNC9DE5HcSXDMw3IcLbbA
         lOIxjGSyarNskWHWT+0kpiJbN3B8SDSK5bBHLrqeZg73qn84gSBmSRshoBIolcMqj5
         TtCII80DdhRkMDG3yIgSlOYK84fEYE4WzD9Us36o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 142/334] lib/test_scanf: Handle n_bits == 0 in random tests
Date:   Mon, 13 Sep 2021 15:13:16 +0200
Message-Id: <20210913131118.151910188@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fe8e3ee0d588566c1f44f28a555042ef50eba491 ]

UBSAN reported (via LKP)

[   11.021349][    T1] UBSAN: shift-out-of-bounds in lib/test_scanf.c:275:51
[   11.022782][    T1] shift exponent 32 is too large for 32-bit type 'unsigned int'

When n_bits == 0, the shift is out of range. Switch code to use GENMASK
to handle this case.

Fixes: 50f530e176ea ("lib: test_scanf: Add tests for sscanf number conversion")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210727150132.28920-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_scanf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_scanf.c b/lib/test_scanf.c
index 84fe09eaf55e..abae88848972 100644
--- a/lib/test_scanf.c
+++ b/lib/test_scanf.c
@@ -271,7 +271,7 @@ static u32 __init next_test_random(u32 max_bits)
 {
 	u32 n_bits = hweight32(prandom_u32_state(&rnd_state)) % (max_bits + 1);
 
-	return prandom_u32_state(&rnd_state) & (UINT_MAX >> (32 - n_bits));
+	return prandom_u32_state(&rnd_state) & GENMASK(n_bits, 0);
 }
 
 static unsigned long long __init next_test_random_ull(void)
@@ -280,7 +280,7 @@ static unsigned long long __init next_test_random_ull(void)
 	u32 n_bits = (hweight32(rand1) * 3) % 64;
 	u64 val = (u64)prandom_u32_state(&rnd_state) * rand1;
 
-	return val & (ULLONG_MAX >> (64 - n_bits));
+	return val & GENMASK_ULL(n_bits, 0);
 }
 
 #define random_for_type(T)				\
-- 
2.30.2



