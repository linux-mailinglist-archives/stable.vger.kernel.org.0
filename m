Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4040B243350
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 06:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgHME3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 00:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgHME3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 00:29:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32790C061383
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 21:29:11 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y10so504026plr.11
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 21:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ir/TwzXKrJIx51xeXWtP2nIBfHcRYk10KeY/pHei49E=;
        b=cw5cxSfF05qeFRq/yk4IykzVTQKt+ejdPbbRjGsyg/WGZhkFrKF00uBXuRFmqkBWBm
         98GqMuTdvn6Mtq462o7lNv0ssoRrhq5Zaqd+sPVDqifRhHFQMCB7ldDQtH38zcb8oicr
         c2TPJLMk56kk3nZFMw06Qc7bs3wnqYZw2wGnPNJ8QvhGJX/pLIktodr7y8ETRFwa+rK3
         gFgwLS1CCmHfM7ZsfQNhSuuwymXv1An9GAZonvlgOcr/gen2W33MQX/ksR3PoVLxwTT3
         5UugXjZLpAx8CUMMcrMtOtNVHhOAxRHoz+oBziu8uolZhrZ8iksDpxLOThUGpPgMo7ql
         +sww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ir/TwzXKrJIx51xeXWtP2nIBfHcRYk10KeY/pHei49E=;
        b=oRO+NrNYDeGboNX3iyXLPbLvtgnKKM2b/PZ0yCpoER2Ym998OsVuE7rHTLUnzcZBvd
         izs5sJA0dZER3YC1DXbvuu8RT063xEjyxicyhA1qi3oPSBGu4ao4Idm14IozG6xFnLQj
         PCW6Df34awNtrc3R4okUxKsqldmvyvxcDCnRHzWxnHcFkhHoPf4XJdwHyvZUD4bj/F6V
         EU/grbsV2y5YkUe7NR3lgwXQsdA6dhApjOWUsNTBg/cBWl1uZcBBdrts76FZ8zaFqqF5
         6cY94tBJztIl7ZZw6FpQnJ9GaafOqXQs8L8Rp3w7Q6OJFiBbJCTrVNYLrk0te6H2k0pQ
         XJtg==
X-Gm-Message-State: AOAM530BiQw6EKupamwyZHNb7WwzsJvfbWh4V7NI2WU7Mau/7V5yusO7
        rZm02gyFeqkScADvhHgfjbFCew==
X-Google-Smtp-Source: ABdhPJw7kd7Nj7HnhrH5uzzC1xBDC35wPSobc/wx1hyTVReps59e9du1sKbdnJmSDTiVT+nD1YJs9A==
X-Received: by 2002:a17:902:8b8b:: with SMTP id ay11mr2405922plb.241.1597292950502;
        Wed, 12 Aug 2020 21:29:10 -0700 (PDT)
Received: from localhost ([171.79.32.211])
        by smtp.gmail.com with ESMTPSA id w7sm4008522pfi.164.2020.08.12.21.29.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Aug 2020 21:29:09 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rajendra Nayak <rnayak@codeaurora.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>, mka@chromium.org,
        sibis@codeaurora.org, "v5 . 3+" <stable@vger.kernel.org>,
        Sajida Bhanu <sbhanu@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/4] opp: Enable resources again if they were disabled earlier
Date:   Thu, 13 Aug 2020 09:58:58 +0530
Message-Id: <c6bba235a9a6fd777255bb4f1d16492fdcabc847.1597292833.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <1597043179-17903-1-git-send-email-rnayak@codeaurora.org>
References: <1597043179-17903-1-git-send-email-rnayak@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

dev_pm_opp_set_rate() can now be called with freq = 0 in order
to either drop performance or bandwidth votes or to disable
regulators on platforms which support them.

In such cases, a subsequent call to dev_pm_opp_set_rate() with
the same frequency ends up returning early because 'old_freq == freq'

Instead make it fall through and put back the dropped performance
and bandwidth votes and/or enable back the regulators.

Cc: v5.3+ <stable@vger.kernel.org> # v5.3+
Fixes: cd7ea582 ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes")
Reported-by: Sajida Bhanu <sbhanu@codeaurora.org>
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
[ Viresh: Don't skip clk_set_rate() and massaged changelog ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Rajendra,

I wasn't able to test this stuff, please give it a try. I have
simplified your patch and cleaned up a bunch of stuff as well.

 drivers/opp/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index bdb028c7793d..9668ea04cc80 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -934,10 +934,13 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 
 	/* Return early if nothing to do */
 	if (old_freq == freq) {
-		dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
-			__func__, freq);
-		ret = 0;
-		goto put_opp_table;
+		if (!opp_table->required_opp_tables && !opp_table->regulators &&
+		    !opp_table->paths) {
+			dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
+				__func__, freq);
+			ret = 0;
+			goto put_opp_table;
+		}
 	}
 
 	/*
-- 
2.14.1

