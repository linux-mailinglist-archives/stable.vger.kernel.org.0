Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B526109F86
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfKZNs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39016 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfKZNs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:56 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so19418243wrt.6
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o6tdnQdXhY6/zbnPRQz5gsdIvhllvIceiXLYdtiRQVc=;
        b=Yexc471GQhKXS9R7cWIqe9+fqxo4Hr7jdQ4HUYzls0LXnptQl2pL7m0R2tPEthUw7K
         3d38dV/1TbClXFdeFNQtEiV1pj4NXXJtFU1Z+bwJ4Fqlk4FIsRUTEnnjhGjMwqwr/yrs
         82QkjjkADkZ0RSveNzA9vO3cica32CcyO9a6ahBhX2oxPgMlQrSaRsBSjPKkuIITygMP
         InNZJu/2A74pU6BU6R3NJTyLGJxJ9xM+Lv8rUCk14lpfRA4H84jF4AGQ1MaXBxWSD84Q
         A8L6D5Uatj83LB3sUDbcU+FuHMBUP3/NML5LBDdLPF8LY71biZuf+Mqp/yGu4mFqixA1
         mHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6tdnQdXhY6/zbnPRQz5gsdIvhllvIceiXLYdtiRQVc=;
        b=hAVeDAQ3TJWWHLMnusBK7B/IhRcT9jXsEU2CNqKVM1yujsdpFCkpW8odzDInvLSz63
         uj0GLoRtETnPuJ1okrKqnzCS/ef9iaHHy/vSJqU/PmSMe6+7d9jW/z69LbDqSymX5GZJ
         GeVcCNdw+r0T99HevdJXYDZLdhg4xc4fyE7UpLDKXtPeJwYziN4hVIUbscUg7q9AHQqw
         amsaXBmz6Sd+UzXWDbsw7Dao8JSNqIoJi9Y6UKBhyrhEEpacyXkdbIZgEVGnJqQ2Z/U/
         RqLKMu3uMWfCBnyH50BBEIqUrybXZk0UIIrAOHnSejELLgHJ0yYKccNZAdN2HXVm7Ez7
         EaWQ==
X-Gm-Message-State: APjAAAXSOHU7VBfcsMyQXou0iY8jqWzuyhFj6u2V/5KPZW6+4Ri1Fjjp
        YS3IPCarAifgI+9tHcgH4eOFMQPW1Mo=
X-Google-Smtp-Source: APXvYqxyF0foe3x2m7iWAbWSQk2FTL4dfVyzFERnPE1ty1H9+wmMMvtaEyjNEL4W978QF5THzs8RkA==
X-Received: by 2002:a5d:4810:: with SMTP id l16mr21688298wrq.127.1574776132261;
        Tue, 26 Nov 2019 05:48:52 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id m9sm14374131wro.66.2019.11.26.05.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:51 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 4/5] cpufreq: Skip cpufreq resume if it's not suspended
Date:   Tue, 26 Nov 2019 13:48:29 +0000
Message-Id: <20191126134830.12747-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126134830.12747-1-lee.jones@linaro.org>
References: <20191126134830.12747-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo Yan <byan@nvidia.com>

[ Upstream commit 7815c05f24b49fe6e70505905e3773cd27c17b6c ]

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
index 4aa3c5331666..52fc08a92bb9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1673,6 +1673,9 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	if (unlikely(!cpufreq_suspended))
+		return;
+
 	cpufreq_suspended = false;
 
 	if (!has_target() && !cpufreq_driver->resume)
-- 
2.24.0

