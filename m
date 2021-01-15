Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF02F7C00
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbhAONHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732353AbhAOMbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9E5F238A0;
        Fri, 15 Jan 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713813;
        bh=2lfO5BMhBRCISYYSfisVBIn98GspxvrD9EFkcEhvGtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftWikzbfvqC6F49ZDp6L8qrAuXaGSvX7Be/3wiT6eLtgNgYmxROQ8WBa6wU8SvNA9
         tE+kTmDnc0HBevYUTqxmwsXDtkVZeVtVJyzgB1repGHsbiqjFD3QJr4X98P1ziyP2R
         Tihch7lLCdDtzxGnThOIgMvgE4aCpl1J+zyfmrjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Colin Ian King <colin.king@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 15/25] cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()
Date:   Fri, 15 Jan 2021 13:27:46 +0100
Message-Id: <20210115121957.436024681@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 943bdd0cecad06da8392a33093230e30e501eccc upstream.

Currently there is an unlikely case where cpufreq_cpu_get() returns a
NULL policy and this will cause a NULL pointer dereference later on.

Fix this by passing the policy to transition_frequency_fidvid() from
the caller and hence eliminating the need for the cpufreq_cpu_get()
and cpufreq_cpu_put().

Thanks to Viresh Kumar for suggesting the fix.

Addresses-Coverity: ("Dereference null return")
Fixes: b43a7ffbf33b ("cpufreq: Notify all policy->cpus in cpufreq_notify_transition()")
Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/powernow-k8.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -887,9 +887,9 @@ static int get_transition_latency(struct
 
 /* Take a frequency, and issue the fid/vid transition command */
 static int transition_frequency_fidvid(struct powernow_k8_data *data,
-		unsigned int index)
+		unsigned int index,
+		struct cpufreq_policy *policy)
 {
-	struct cpufreq_policy *policy;
 	u32 fid = 0;
 	u32 vid = 0;
 	int res;
@@ -921,9 +921,6 @@ static int transition_frequency_fidvid(s
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	policy = cpufreq_cpu_get(smp_processor_id());
-	cpufreq_cpu_put(policy);
-
 	cpufreq_freq_transition_begin(policy, &freqs);
 	res = transition_fid_vid(data, fid, vid);
 	cpufreq_freq_transition_end(policy, &freqs, res);
@@ -978,7 +975,7 @@ static long powernowk8_target_fn(void *a
 
 	powernow_k8_acpi_pst_values(data, newstate);
 
-	ret = transition_frequency_fidvid(data, newstate);
+	ret = transition_frequency_fidvid(data, newstate, pol);
 
 	if (ret) {
 		pr_err("transition frequency failed\n");


