Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C45E10AB12
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfK0HWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:22 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50737 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfK0HWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:22 -0500
Received: by mail-wm1-f67.google.com with SMTP id l17so5907648wmh.0
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yrZu99BLvlhrth7qw3JOZy62Wr9zwC7/qBHtCS/hJhk=;
        b=ZjmzfNUdXO+aIr1Wqss30fYLj3iyDh+W3fpfe2SMcvyCWhR6QS5EBcNx1wcM9V3dJy
         mOIRI57IQ8MU6gBTGccDcVsEy4/CFbmDSvX+9PwuVOyAyoaIfDFvBwRWIsT7Z7lAxg1T
         8vhfK2Ql5N5tGmqRlBFxb7lZFhQNtKSoU6wKmT21kmlpXp7y2GZP2YFttITIeeTd6a21
         6O3YZQxL3v4EMoW+hnbWBHDJrAkU6hpDCxeoMdNYWa/bveavu4Jb/w1I4hqafmg3b6VG
         JKNXsxeXN8lq/ez7SQgSZVTLVYzB8Kio00x/EZHeD56XKDe7fjCk7opp2tPZw+F1NqXZ
         z5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yrZu99BLvlhrth7qw3JOZy62Wr9zwC7/qBHtCS/hJhk=;
        b=Omy98L1W/rRkxT8tNGsA6SjYuM4y1D224YOIksz4AfEBylDd76XgefX5KBVeuQhx8B
         q1VGh5m6h4UVwYw0UPMTn7PKbJQSVmoMJYKocBzpY97Y3qCFKgAgjyOePwIaWd1fnC/z
         wO/3t0m3Q/94fHH5TlWeD85ivAr5Bt8KdLMynGqh1LeVxY26PUxhYyLNAqBHsExyuzfD
         MTcxJs55/iLcw7G59rBQ+s7BIYCn9k2PDnGQNxlB25vIKrCw5l+kfALRFh/aj65EGk4q
         fAes+p+FOvxxVu2saW2TXDEqsAT4Ny+WKMZTkoYbuwFD1LOr8ZFdwq15OI9X6QYwUGzi
         UJlQ==
X-Gm-Message-State: APjAAAWqsVn1Gn3QeCd0B8yVJMy3hiER+OVfFXzLH30XafPtqH92zGG6
        jVo227qvQl+a03ledyv3FfjmWqVxkFU=
X-Google-Smtp-Source: APXvYqwldIEV0Cw2tPko1xVBupeyoYkQTJmgUOLygmqV8E6kY2s62IYEd5a/CzOU3PkFSo6j9rQQ3A==
X-Received: by 2002:a7b:c5d0:: with SMTP id n16mr2873459wmk.78.1574839339774;
        Tue, 26 Nov 2019 23:22:19 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id d20sm19406915wra.4.2019.11.26.23.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:19 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 4/5] cpufreq: Skip cpufreq resume if it's not suspended
Date:   Wed, 27 Nov 2019 07:22:01 +0000
Message-Id: <20191127072202.30625-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072202.30625-1-lee.jones@linaro.org>
References: <20191127072202.30625-1-lee.jones@linaro.org>
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

