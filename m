Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ABE24F7DB
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHXJWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728730AbgHXJWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 05:22:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D2DC061575
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 02:22:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d4so3886458pjx.5
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 02:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4UM9mPQ/Wl0010YGua3xqk8lRiomnoA+4Ucmsd+rGg=;
        b=Gc08fz17RCgg9vthCMAjs4eBGBC6yt0YsaI2PhMPrOxts9oM0gRBNRn2RMlw2xVToq
         Za9M5hDNMxv9nR2/JIGOV2VXJfAcE0XqMxnNBEjrd+FWxJoKnrcBAgL5oPIV3/ZlzYSk
         d6K1V7hpnhCYXtAy15L0w7s3lOvU7R4OyDGUYSa3tm6Tn8Wb5Fi4p9BNe5hrCQjGsln/
         v6J24L8ogceKQ94aboLJR6bR64R3IP7MfdMzOCkO3NEOzCYp9IYBJ6ZLuiWoJv/TJ7B5
         IrrO9fpNkCp6BjadZd+oSMwNofjhEd/QF++8XKSd/uoCRjPUdQ6JuLtkxZpPcK4whAkk
         qctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4UM9mPQ/Wl0010YGua3xqk8lRiomnoA+4Ucmsd+rGg=;
        b=Agwh7CYU1zjSzwZUmnhw3YmFsDazDMXArgAQbQ4UV6LerSlreobsNVfNftHSvGgvJK
         q4Qox+dQqM7gJjSA4qepBSF/BsNRRHAunf+aOo0Y5Ujn+kf+h1HkK/k1g20LqjgnbzWX
         SzRytqyw2S5id+5Upc/ZOAMhbdxxAT+yEBEH4KGl7b33bLz5UOdP9sKnD60QqHZ9aEKN
         GLFm60TG37n+TMMSyGHBLzqtYAmHks/FMZuXpOpZGYxPyuD09q7ROK2VpjXL8wKzeAY0
         Ts35FQyHRVQv7+Cux0oznDT4AG4M94dH5gSxnmoqAjgGhydMpGMG6bA82aCgsXfWD8hh
         rVbQ==
X-Gm-Message-State: AOAM5334Q9RpxrVWCBvzT714BbD5VlrryqkojvrjIWcX/dSGU+nfEq6y
        Lu5qkl/RE0eMKz654XThoYlFrTEIYWOrng==
X-Google-Smtp-Source: ABdhPJzr/+V5/Xvr7hHGMeg9kPul3msU5ZfPAjcPIANC22Uv5q3G4hAz2I/TVnaLNhp/C7LmbkSUcA==
X-Received: by 2002:a17:90a:ead1:: with SMTP id ev17mr3973550pjb.147.1598260951510;
        Mon, 24 Aug 2020 02:22:31 -0700 (PDT)
Received: from localhost ([122.172.43.13])
        by smtp.gmail.com with ESMTPSA id w23sm9021621pgj.5.2020.08.24.02.22.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 02:22:30 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Viresh Kumar <vireshk@kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Sajida Bhanu <sbhanu@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH - stable v5.4 and v5.7] opp: Enable resources again if they were disabled earlier
Date:   Mon, 24 Aug 2020 14:52:23 +0530
Message-Id: <31f315cf2b0c4afd60b07b7121058dcaa6e4afa1.1598260882.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

commit a4501bac0e553bed117b7e1b166d49731caf7260 upstream.

dev_pm_opp_set_rate() can now be called with freq = 0 in order
to either drop performance or bandwidth votes or to disable
regulators on platforms which support them.

In such cases, a subsequent call to dev_pm_opp_set_rate() with
the same frequency ends up returning early because 'old_freq == freq'

Instead make it fall through and put back the dropped performance
and bandwidth votes and/or enable back the regulators.

Cc: v5.3+ <stable@vger.kernel.org> # v5.3+
Fixes: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes")
Reported-by: Sajida Bhanu <sbhanu@codeaurora.org>
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
[ Viresh: Don't skip clk_set_rate() and massaged changelog ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
[ Viresh: Updated the patch to apply to v5.4 ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/opp/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 9ff0538ee83a..518442be638d 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -843,10 +843,12 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 
 	/* Return early if nothing to do */
 	if (old_freq == freq) {
-		dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
-			__func__, freq);
-		ret = 0;
-		goto put_opp_table;
+		if (!opp_table->required_opp_tables) {
+			dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
+				__func__, freq);
+			ret = 0;
+			goto put_opp_table;
+		}
 	}
 
 	temp_freq = old_freq;
-- 
2.25.0.rc1.19.g042ed3e048af

