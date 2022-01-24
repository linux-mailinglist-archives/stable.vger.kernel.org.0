Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B894994E0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358464AbiAXUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387548AbiAXUgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAC0C038AF6;
        Mon, 24 Jan 2022 11:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48FDD6091B;
        Mon, 24 Jan 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29261C340E5;
        Mon, 24 Jan 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053810;
        bh=8y110tx3r7t2HN8cFeLXNOvhc6Q0LIpe9KAMP9H6Dxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gN0aZgyOiAMJQk9itrkddYd46pTxGb+zZ7UhY3GUmJOBAZFzsCIcoQI/0SPlh8hp
         jNHKw2EM7MLCRhtpG53hIX6PHwNIQSaRJh8c7OvIYhbUWSHxkvg+J3OJKK52PP1kqn
         vBjgQ5ZW92ZAH1x6ZiYfADR8y8M4+v4R+pyQzXbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/563] um: fix ndelay/udelay defines
Date:   Mon, 24 Jan 2022 19:39:10 +0100
Message-Id: <20220124184030.816062435@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5f8539e2ff962e25b57742ca7106456403abbc94 ]

Many places in the kernel use 'udelay' as an identifier, and
are broken with the current "#define udelay um_udelay". Fix
this by adding an argument to the macro, and do the same to
'ndelay' as well, just in case.

Fixes: 0bc8fb4dda2b ("um: Implement ndelay/udelay in time-travel mode")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/delay.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/delay.h b/arch/um/include/asm/delay.h
index 56fc2b8f2dd01..e79b2ab6f40c8 100644
--- a/arch/um/include/asm/delay.h
+++ b/arch/um/include/asm/delay.h
@@ -14,7 +14,7 @@ static inline void um_ndelay(unsigned long nsecs)
 	ndelay(nsecs);
 }
 #undef ndelay
-#define ndelay um_ndelay
+#define ndelay(n) um_ndelay(n)
 
 static inline void um_udelay(unsigned long usecs)
 {
@@ -26,5 +26,5 @@ static inline void um_udelay(unsigned long usecs)
 	udelay(usecs);
 }
 #undef udelay
-#define udelay um_udelay
+#define udelay(n) um_udelay(n)
 #endif /* __UM_DELAY_H */
-- 
2.34.1



