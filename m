Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E218B10B7E6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfK0UiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:38:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728644AbfK0Uh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:37:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B3BD217AB;
        Wed, 27 Nov 2019 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887077;
        bh=lq0PX3Vu7TeZOispeOZS+KeWZBBffeqQ/ZHaoCr8Tbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGdEfx6Q7o1AFzUXjcUDbmTq6FrHxW2n9AiqeUW1MPgF5PLoDpVP5QCzJq4BZ6KrL
         Ubc6uWyxt35p+IUFv20C/zJ6BHY4gx5scqTxKGYdoowOb5phYeU4hKYpBF//3eiwGR
         4zRU6tkGXmJWehkfDeskvrd2P1tM70p4+0vmIjNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo Yan <byan@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 103/132] cpufreq: Skip cpufreq resume if its not suspended
Date:   Wed, 27 Nov 2019 21:31:34 +0100
Message-Id: <20191127203025.194756012@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo Yan <byan@nvidia.com>

commit 703cbaa601ff3fb554d1246c336ba727cc083ea0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

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


