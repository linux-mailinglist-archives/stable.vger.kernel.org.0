Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357F0B1E94
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388972AbfIMNLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388969AbfIMNL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:29 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BD9208C2;
        Fri, 13 Sep 2019 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380289;
        bh=1mChLguwNvmsTCWxCMHukNMunGzA705l+b8oIxjE6ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdAGFfjkQpv5XR90UrJaR0gOgqQmb5CgahLHhxwMS/zpx0CGuCzOk13qMBIq960mb
         tRDFNEfBfbbHqVorxi/NStFnsfCYdVpTPgWf9A3FU19X6KzrNPlgjkmGWV/oCuldAd
         thFZvJDjPVcL7RCHOOkm99KSZ2009PUq+gctul+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/190] timekeeping: Use proper ktime_add when adding nsecs in coarse offset
Date:   Fri, 13 Sep 2019 14:04:32 +0100
Message-Id: <20190913130600.943205156@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0354c1a3cdf31f44b035cfad14d32282e815a572 ]

While this doesn't actually amount to a real difference, since the macro
evaluates to the same thing, every place else operates on ktime_t using
these functions, so let's not break the pattern.

Fixes: e3ff9c3678b4 ("timekeeping: Repair ktime_get_coarse*() granularity")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lkml.kernel.org/r/20190621203249.3909-1-Jason@zx2c4.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 443edcddac8ab..c2708e1f0c69f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -823,7 +823,7 @@ ktime_t ktime_get_coarse_with_offset(enum tk_offsets offs)
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	return base + nsecs;
+	return ktime_add_ns(base, nsecs);
 }
 EXPORT_SYMBOL_GPL(ktime_get_coarse_with_offset);
 
-- 
2.20.1



