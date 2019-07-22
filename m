Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783926F9B3
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 08:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfGVGwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 02:52:01 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35419 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfGVGwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 02:52:01 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so18750704plp.2
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 23:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KviHflI7215zrUthnS1gXggMXKtV9Y/Ymw3VDs2vemM=;
        b=xiI+A7LzjIZ4RN3YaVr53KXlrp2CjtY3C1XCvK2GvNMkkQaKB9HpK5kD9nEbHP0uIs
         mQBzYgXLgvecOewN+yajjz+T0mSbKjLF7Rls8iljtb2HrWSoqn6TCQwPK6r3jMQNmLVO
         J1W43UoCtyWi+Bbakiasf8/S53w3OqG9gSxOPByXpcCrjvFGCMgk9m6mXJrUoAOpxBgv
         bLf5M540QjWlTbL/YcQycqGBDcaNLH6/65xZWVyTvRGbcGxHA8+kUBJoFtZPfiqMzdIO
         795kSv2AeYwn0M6bKRtKPAA6HYNKae6WvxSxVTqnM6RrH9gzqld2gAgo7y9XqzL+HUw7
         e0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KviHflI7215zrUthnS1gXggMXKtV9Y/Ymw3VDs2vemM=;
        b=NWLjuNeoO9z45DePLPny5KTzR/c6Eq1OAohAFzQxvapJavaFb+vHqRaXmp3Ul/C3Jo
         cZDjxje0fnDmfN89mHqq5nHhhKq7ADt9XjorFV9IMZiXL3nLGrkBrRw9JzDYOSDdruzl
         xmFdoiDXm/mQMqpwDPlrRWya+MTYpHHX4zPh2VgdtZKhSZtljkCCzQJ1ZJnRACWNd7zE
         MDJyVrGwN18zwaA+cPwLXtjMxD4m3yFiZwCSMz11JcMjgohJjORH1NSrPhDDBfKemsDg
         jtK8/UstHzLyXTHIcH7sc+Y4gt9MNf3UZauQXX5JG5tY+2caxXQgaCI6JQ1Ls2CBOsne
         2WvA==
X-Gm-Message-State: APjAAAVc7gtsMaeq2Gb7wRjRIiqMBHnsPzOEssaKDkFYivH50PJ7E8SE
        rVV/G4HGqdwJDxL3ztC0y7tQ4g==
X-Google-Smtp-Source: APXvYqyskF2od7lC4dY3iR56zhJTnZuJbzasgdAgdKCNvqPPXPkz7toOARqZnaz7ud673gnA5zEXow==
X-Received: by 2002:a17:902:7448:: with SMTP id e8mr73804121plt.85.1563778320961;
        Sun, 21 Jul 2019 23:52:00 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id b6sm34300949pgq.26.2019.07.21.23.52.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 23:52:00 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Rafael Wysocki <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        joel@joelfernandes.org, dsmythies@telus.net,
        "v4 . 18+" <stable@vger.kernel.org>,
        Doug Smythies <doug.smythies@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Mon, 22 Jul 2019 12:21:57 +0530
Message-Id: <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To avoid reducing the frequency of a CPU prematurely, we skip reducing
the frequency if the CPU had been busy recently.

This should not be done when the limits of the policy are changed, for
example due to thermal throttling. We should always get the frequency
within limits as soon as possible.

Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
Reported-by: Doug Smythies <doug.smythies@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
@Doug: Please try this patch, it must fix the issue you reported.

 kernel/sched/cpufreq_schedutil.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 636ca6f88c8e..b53c4f02b0f1 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -447,7 +447,7 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
 	struct sugov_policy *sg_policy = sg_cpu->sg_policy;
 	unsigned long util, max;
 	unsigned int next_f;
-	bool busy;
+	bool busy = false;
 
 	sugov_iowait_boost(sg_cpu, time, flags);
 	sg_cpu->last_update = time;
@@ -457,7 +457,9 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
 	if (!sugov_should_update_freq(sg_policy, time))
 		return;
 
-	busy = sugov_cpu_is_busy(sg_cpu);
+	/* Limits may have changed, don't skip frequency update */
+	if (!sg_policy->need_freq_update)
+		busy = sugov_cpu_is_busy(sg_cpu);
 
 	util = sugov_get_util(sg_cpu);
 	max = sg_cpu->max;
-- 
2.21.0.rc0.269.g1a574e7a288b

