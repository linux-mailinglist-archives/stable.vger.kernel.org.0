Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D055E2E344F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 06:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgL1F3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 00:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgL1F3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 00:29:10 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671B9C061795
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 21:28:30 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s15so5111960plr.9
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 21:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3oz21Ub57lWDH8p5jFu652FsrPXlKogfC2kiSGZUKOQ=;
        b=SvA4JT7MAFuwp9CQ6cuq8DL+TCJ2DsQxbu+hdbTjLKxrSMynLkEHR6xUklwa7YoW5Q
         XwlsrF57LtmrOpYlahHLPGBEsXjBK0aSiWmJcldWFEm1N/M+uk+lKlM3eCAyTt+EUxYW
         4pA+ydtxyXGKgkgXa0TQS7xznu34l0U88QhCKJuEcDdY7ry2XuK1fXd2RNCjVhCn5E3Q
         Owy+126qF3oWD+fjp/kdBZswVKmSX7+/j9X1auJcwHaBU8Km/0UT8q40ey4CA5Q3GQaz
         /jmAJsFk98TpUypvhSF1K7FHHJQvjPd3RVPoofl+uYnJAQVPWAWzesxpB4BocKXRBvFv
         0Obw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3oz21Ub57lWDH8p5jFu652FsrPXlKogfC2kiSGZUKOQ=;
        b=HywZ3wak4diQjt5O3q3xGdt0T+VVMuxKI4hENyU7nMr6g42iaB/7SBs2x/1K8FlL4p
         IyJKXbxH38/HSEVKUknwuAFIx0YtXYJsMVAE7KFOgud5iaAFU5AQkT2Agu+oLWzAw31A
         tqYsB0fhiuqHMmdERoxpa4BxGCSQZ6hhOl9ike6UPBgD3P5XTnecUABpQy9T5NFjbCQw
         ygPtWhipo+aemhbd9wrFXwEm0k84O2Xsb15Cvb+W98VQOL5/kzQl+rfanrEsAeeqYK7Q
         93ovNNN8LRwUICGCZBzvEbnsdOnwhzmnvDKZuP1g4nv1r61KxasBc9my7PJvPccOsCxy
         OqPg==
X-Gm-Message-State: AOAM532f8zBBUVg4YPwH/cRYD3IlCjFZ9QsRNeQxT5yETUtK4AXwN8no
        HfMw+MpjZq1jMCiH8Hc9OlQTNQ==
X-Google-Smtp-Source: ABdhPJy1JAI4TTJp55VsTyJnfdEhOTvktuLnYwC+MftyBcUZ8fYv8WVgIZhvCLKRLgnCeTOcgkilGw==
X-Received: by 2002:a17:90a:e005:: with SMTP id u5mr19325143pjy.64.1609133309944;
        Sun, 27 Dec 2020 21:28:29 -0800 (PST)
Received: from localhost ([122.172.20.109])
        by smtp.gmail.com with ESMTPSA id p3sm12399613pjg.53.2020.12.27.21.28.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Dec 2020 21:28:29 -0800 (PST)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        quanyang.wang@windriver.com, "v5 . 10" <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] opp: Call the missing clk_put() on error
Date:   Mon, 28 Dec 2020 10:58:21 +0530
Message-Id: <0e1d9ca1766f5d95fb881f57b6c4a1ffa63d4648.1609133256.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
In-Reply-To: <20201224104927.722763-1-quanyang.wang@windriver.com>
References: <20201224104927.722763-1-quanyang.wang@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the clock reference counting by calling the missing clk_put() in the
error path.

Cc: v5.10 <stable@vger.kernel.org> # v5.10
Fixes: dd461cd9183f ("opp: Allow dev_pm_opp_get_opp_table() to return -EPROBE_DEFER")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/opp/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index c9e50836b4c2..8c905aabacc0 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1101,7 +1101,7 @@ static struct opp_table *_allocate_opp_table(struct device *dev, int index)
 	ret = dev_pm_opp_of_find_icc_paths(dev, opp_table);
 	if (ret) {
 		if (ret == -EPROBE_DEFER)
-			goto remove_opp_dev;
+			goto put_clk;
 
 		dev_warn(dev, "%s: Error finding interconnect paths: %d\n",
 			 __func__, ret);
@@ -1113,6 +1113,9 @@ static struct opp_table *_allocate_opp_table(struct device *dev, int index)
 
 	return opp_table;
 
+put_clk:
+	if (!IS_ERR(opp_table->clk))
+		clk_put(opp_table->clk);
 remove_opp_dev:
 	_remove_opp_dev(opp_dev, opp_table);
 err:
-- 
2.25.0.rc1.19.g042ed3e048af

