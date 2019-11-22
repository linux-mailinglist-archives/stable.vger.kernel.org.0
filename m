Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC45C106CA0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfKVKxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40804 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730206AbfKVKx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:27 -0500
Received: by mail-wr1-f67.google.com with SMTP id 4so4734649wro.7
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PNM5lccoBtUfm9iFogx92X5PMCn4g3/BVdMdr/P978Y=;
        b=tux3SSPuh61SEjBLSCOgxDUMtLXrokKpBYuA5SeC4hYQHhnAuaiO9mOOKAM1MMqxTZ
         TW0+3T2Gg+9sL6joIRKeEZl2DOKx0tPW4O2G1IxK13WWBnlhIqOaKLOtW4POBLOtqyb6
         b1T9vmNUZSqxLIUkvvg0DoHBnJMs8KRlIdRsDlatwVtulgv9X2Lf63/PGGLaHTTIADpz
         ZEUNs/sQjTONDfIWR6yfKsvj60whpSaHSaKZ+dy+HlzLn7f60HVosrjdvdyeKLQlXela
         vzKpX0IvRa5Sxdyxokum6c7ysww+TahF1Z5lwyd2R/aH2rQP7hWmqOrsaNtN1TyStxZh
         1slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNM5lccoBtUfm9iFogx92X5PMCn4g3/BVdMdr/P978Y=;
        b=LWfUFr2oLUsNRSr3K4dZQ5E557DJ2pYmM0K3YkAqpWv3MQjT4n08gy6L+a3QFY2/fE
         Rcb6cdPYvonzgW9avEwjAEpifkBsF/5i/S76udo7kL5rXHDFujpwzm3uRuhneWRbgZyB
         /gd8XfcnQ55vp8DwSjB8g59AsoukgZN+VFdjYtOYqXCpB73a5pSwzyTm7qu5bOdY2nhw
         SajbVDqDOmdj5mIh9WawmEnmPvGUperjYMCTRu2dMWajkYnFX4OexaTR3jtTz0UeJJm5
         oz+JxznWKDDzCM39XbaeYKck60l+4byl+BM06UfGo2lOWepZx5eX0Clenqi3O9swKDGv
         SnfQ==
X-Gm-Message-State: APjAAAWNqJwJBJwCww4QpUYhPYIiEx6wklJhWyid8dwhvmMeXNCQLpmh
        t88LC1byQqZ7JXKElmK6k62cQQ==
X-Google-Smtp-Source: APXvYqzfypZZYlCptFZIW8n8lxROI1kcnpbn7Cf/kMBjqyqEqIdm5ThZ4yEC25Z4QHss0XdH17rVTA==
X-Received: by 2002:a05:6000:104:: with SMTP id o4mr16469149wrx.309.1574420005608;
        Fri, 22 Nov 2019 02:53:25 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:25 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 4/8] cpufreq: Skip cpufreq resume if it's not suspended
Date:   Fri, 22 Nov 2019 10:52:49 +0000
Message-Id: <20191122105253.11375-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
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
index d43cd983a7ec..04101a6dc7f5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1646,6 +1646,9 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	if (unlikely(!cpufreq_suspended))
+		return;
+
 	cpufreq_suspended = false;
 
 	if (!has_target() && !cpufreq_driver->resume)
-- 
2.24.0

