Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB1510AB0C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfK0HWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40620 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfK0HWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so750732wrn.7
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PNM5lccoBtUfm9iFogx92X5PMCn4g3/BVdMdr/P978Y=;
        b=YsChHgYggeUZO9x9e9+MAA/wLPYwxtb0tTDqUgr7RhlxiTZCy1wfvID4f0ZLOFFZel
         cx5N/hOLowxN/G8aa7qDfaEFMDayLwYP3QIxEGMAyDFmYXDvu5lEnO72YLs0yZbuVra+
         xVVLqRIatINBrLPqBsjqxMCtdoakS7Ks9t3b/gH0pD3Ixn1IprUoR3VbV8qI9ApObG8c
         A+PuCnL8iU1w/YODr7JmsYJ+XPfHRli5u7SYp/mghJYaN/HptA35YdZ4XKCRTCZzZLGv
         CXBJ07Olkemq0kjMBAEemfiRvoteINGEW6dFGUnCbqlzUtf1ZFwVhuqBv020BJhYg54l
         LmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNM5lccoBtUfm9iFogx92X5PMCn4g3/BVdMdr/P978Y=;
        b=GJWq54cLyrGIhj1iy8aAlrFaj1eT73bPZUXGqNtgjyEhQ/UR6x1mpa4Bhkhl9VA93Q
         XCCjt0ZSJpBCpQdqwLD0Boew679oqUgFjn/MCxeANRtiMfRkkinCR6AX30HlsB2SzNSf
         mpqKXQYgfrkgya06jbm6ueqegSzAfZLxdkHsctrk6+X9cZgigiarAUiJ1AY+MdvOLbHO
         9a0wisT6Bi7nCdBBIWcG3EoHbcjWBPxj9h0Ivn6DvIDQFNY0UdvVmk9ArXXbc7kv7TvZ
         uvUfdJrqCuk5u+XOtLjBS+x4ViB8kvePsHhBKEcupkMEzcfAK6sLCX5Eg9+iHaAWRNWp
         uCTg==
X-Gm-Message-State: APjAAAUfJWtO9WL993m88CwowB/b0Pa8TfRFSfPYuyfEHwT1ZH2nTl2t
        JRXP1tUvqSTlg0FQLG4Hd7P+rPLFkB8=
X-Google-Smtp-Source: APXvYqx2GiWnWgJSEImTcGFOCpsJ7wTCIhYJSkOFhpMurndriKoKGpw2HSKHK0XrCFSYqe4ovnidBQ==
X-Received: by 2002:adf:b193:: with SMTP id q19mr40155798wra.78.1574839326144;
        Tue, 26 Nov 2019 23:22:06 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id e16sm17983130wrj.80.2019.11.26.23.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:05 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 4/6] cpufreq: Skip cpufreq resume if it's not suspended
Date:   Wed, 27 Nov 2019 07:21:42 +0000
Message-Id: <20191127072144.30537-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072144.30537-1-lee.jones@linaro.org>
References: <20191127072144.30537-1-lee.jones@linaro.org>
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

