Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B132F78F7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbhAOMaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbhAOMaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4519C223E0;
        Fri, 15 Jan 2021 12:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713766;
        bh=2lfO5BMhBRCISYYSfisVBIn98GspxvrD9EFkcEhvGtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zk3xv8JoSA85lsreprLcNctPHL6oqbmSgBumugsB7yhw9U2MtJI0Q5Zb4PuwxrzgG
         f7NzCnFbh1KtDiAjtd+0N49A2pb2Y8UwTQiRdikJPCQb/pPaOWdmsOCAfghdgTNKC8
         a5JYHQFCIv0DX20VKl1z8P5fbookJM+2hBkjBwcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Colin Ian King <colin.king@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 13/18] cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()
Date:   Fri, 15 Jan 2021 13:27:41 +0100
Message-Id: <20210115121955.763178014@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
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


