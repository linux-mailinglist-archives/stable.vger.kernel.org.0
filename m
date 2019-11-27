Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E72F10AB05
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfK0HVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:21:55 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34037 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfK0HVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:21:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id j18so4176269wmk.1
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ObvK4D1522uU+aqw4/rA24ESPbrBwV4/rk1T5o0KCo4=;
        b=oFYYA9nyvtJD0NpP4OebCaWnC/qREvinG7lPhmDrsRP77YXfBhQQsom68/0EfHcf5C
         GaIg94d82H3u28J4+gVKRyaUrgG/UPPjbCSPzSBzhjuFjPx9P4tcPBBATh9jT2wZpYdX
         CT12CByXLbx2kNszqYEhIXuCyuleaQlbCp/TBaqUwLW4SNrfWBry8eTCMnBdhLXi99ha
         UdwWkZKggaEqsq4bZ0Y7fdYjk78QTXyYC1U9EDrtWPQZTiEt2y3Ndjb/Oazd9PLeyu/j
         b3OMUhcjse2/Deo3YkUI2MFvT1aPI8DoLURO8YLB/12vtoqHA4R+OjaaLiZrRLjSOP2/
         qUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ObvK4D1522uU+aqw4/rA24ESPbrBwV4/rk1T5o0KCo4=;
        b=QnqcYbFaiJsUM9ulGzkHFLPFUEQYCsj1oRaxGEbhx9vpZ1gPC4VPdJ8PNpmZNoe5NI
         bnQlsCkQM99UywVaZ+r8v6hWaHjSZ18GS7DUBayOxhgvTm3AtIRDYeUNg21iq42LN9vx
         UTpHyxXH4dNWod9WWmHTS7RniakmCu9GxfRFNtQKdZ1TIS826V96CPgymc3uZwwzduWc
         7vX+UhlOwZnza8b/cY1IqAkJYpvRIM1vveil03Pf3FfuH8ScFmtEv22215CLK+KSuYmw
         vaRjXof/m3KPDSkFuFqLic/FXTqXlQo2QpO/FfQ4XixcRsj7t0vKjBOFfpORWEU78Vv3
         y/IQ==
X-Gm-Message-State: APjAAAWaUcxvPPXQIDCNdaBtQnRI7Xtj9h2Jlou45c+7gnceRFbGv3hD
        RseP/lHrlzhHwTopFa+HitrCMsNGhdY=
X-Google-Smtp-Source: APXvYqwOY/gvx63RHry0xjoqrIAo8r02U4NvKYzqKNjlyHPiMmcH86X1/clq5PH7gshun/XeS8dESQ==
X-Received: by 2002:a05:600c:218c:: with SMTP id e12mr2794349wme.30.1574839311282;
        Tue, 26 Nov 2019 23:21:51 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id y6sm18151872wrn.21.2019.11.26.23.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:21:50 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 3/6] cpufreq: Skip cpufreq resume if it's not suspended
Date:   Wed, 27 Nov 2019 07:21:21 +0000
Message-Id: <20191127072124.30445-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072124.30445-1-lee.jones@linaro.org>
References: <20191127072124.30445-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo Yan <byan@nvidia.com>

[ Upstream commit 703cbaa601ff3fb554d1246c336ba727cc083ea0 ]

cpufreq_resume can be called even without preceding cpufreq_suspend.
This can happen in following scenario:

    suspend_devices_and_enter
       --> dpm_suspend_start
          --> dpm_prepare
              --> device_prepare : this function errors out
          --> dpm_suspend: this is skipped due to dpm_prepare failure
                           this means cpufreq_suspend is skipped over
       --> goto Recover_platform, due to previous error
       --> goto Resume_devices
       --> dpm_resume_end
           --> dpm_resume
               --> cpufreq_resume

In case schedutil is used as frequency governor, cpufreq_resume will
eventually call sugov_start, which does following:

    memset(sg_cpu, 0, sizeof(*sg_cpu));
    ....

This effectively erases function pointer for frequency update, causing
crash later on. The function pointer would have been set correctly if
subsequent cpufreq_add_update_util_hook runs successfully, but that
function returns earlier because cpufreq_suspend was not called:

    if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
		return;

The fix is to check cpufreq_suspended first, if it's false, that means
cpufreq_suspend was not called in the first place, so do not resume
cpufreq.

Signed-off-by: Bo Yan <byan@nvidia.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
[ rjw: Dropped printing a message ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0836d2939c7a..a68a2d5ac042 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1627,6 +1627,9 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	if (unlikely(!cpufreq_suspended))
+		return;
+
 	cpufreq_suspended = false;
 
 	if (!has_target())
-- 
2.24.0

