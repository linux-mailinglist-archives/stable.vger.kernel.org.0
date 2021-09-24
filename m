Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26FE417413
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbhIXNCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345279AbhIXNAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A92C61374;
        Fri, 24 Sep 2021 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488024;
        bh=q43d9dHE/JmL9up6SwWESpl+Xc+kWdvnCoQBNXlFneM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUIz5xtaInDdSxHqr/eXuHC/aLZR1bX/tz+tuIOV+6tcvkWxPqxdbtN2mP2drS2kt
         +kJ7RA5ZoBztvYo+RNvbV3ePR6aso1b9in8ZXHkTwCfYjcm/SLdXLlosUhkjeYAg6k
         +4cYTsCrNpFItJjmSgWNKKonCO9KKLkdwOZDGG6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Trent Piepho <tpiepho@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 036/100] math: RATIONAL_KUNIT_TEST should depend on RATIONAL instead of selecting it
Date:   Fri, 24 Sep 2021 14:43:45 +0200
Message-Id: <20210924124342.670318956@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 8ba739ede49dec361ddcb70afe24986b4b8cfe17 ]

RATIONAL_KUNIT_TEST selects RATIONAL, thus enabling an optional feature
the user may not want to have enabled.  Fix this by making the test depend
on RATIONAL instead.

Link: https://lkml.kernel.org/r/20210706100945.3803694-3-geert@linux-m68k.org
Fixes: b6c75c4afceb8bc0 ("lib/math/rational: add Kunit test cases")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5ddd575159fb..021bc9cd43da 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2460,8 +2460,7 @@ config SLUB_KUNIT_TEST
 
 config RATIONAL_KUNIT_TEST
 	tristate "KUnit test for rational.c" if !KUNIT_ALL_TESTS
-	depends on KUNIT
-	select RATIONAL
+	depends on KUNIT && RATIONAL
 	default KUNIT_ALL_TESTS
 	help
 	  This builds the rational math unit test.
-- 
2.33.0



