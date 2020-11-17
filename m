Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764F92B63C8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgKQNlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733100AbgKQNla (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36177206A5;
        Tue, 17 Nov 2020 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620489;
        bh=UEn0ZFjxedI0aPXmovHTbuX/YSC2lScuXPP+OvKagi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLyx1EDMgnb6hyTCyCHXmOGAkh7+aAom6pA1ZXN2A45upexY9q3wQOvPSB45U5Rvh
         7XDhMMrq0JY+q6KOivcR+zpcovjZZSyprEGpjfB94bfm+hbOarjR1eYfpj3ESgYLRu
         QWNmpOYwERD6U5MTvfBG4SMj9zbKGP9Rzi7dnlSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 237/255] cpufreq: Add strict_target to struct cpufreq_policy
Date:   Tue, 17 Nov 2020 14:06:17 +0100
Message-Id: <20201117122150.471797225@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit ea9364bbadf11f0c55802cf11387d74f524cee84 upstream.

Add a new field to be set when the CPUFREQ_GOV_STRICT_TARGET flag is
set for the current governor to struct cpufreq_policy, so that the
drivers needing to check CPUFREQ_GOV_STRICT_TARGET do not have to
access the governor object during every frequency transition.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    2 ++
 include/linux/cpufreq.h   |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2259,6 +2259,8 @@ static int cpufreq_init_governor(struct
 		}
 	}
 
+	policy->strict_target = !!(policy->governor->flags & CPUFREQ_GOV_STRICT_TARGET);
+
 	return 0;
 }
 
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -110,6 +110,12 @@ struct cpufreq_policy {
 	bool			fast_switch_enabled;
 
 	/*
+	 * Set if the CPUFREQ_GOV_STRICT_TARGET flag is set for the current
+	 * governor.
+	 */
+	bool			strict_target;
+
+	/*
 	 * Preferred average time interval between consecutive invocations of
 	 * the driver to set the frequency for this policy.  To be set by the
 	 * scaling driver (0, which is the default, means no preference).


