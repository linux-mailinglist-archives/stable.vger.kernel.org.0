Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2260710BBE2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbfK0VQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:16:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732618AbfK0VNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1DB0215F1;
        Wed, 27 Nov 2019 21:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889223;
        bh=nHVmU/oIFzQsYfQS/3JhrMAgd1hf4fvK2RzpONW5VZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5ncSDYf8Nnlo5o6V1aHiTK/BlmKrrjBmPPekQDLKSAwLjeRCLTD1gvXzzyn4jLw4
         At1UVw2lCxTpqtffdi0Ra5miXFWVhN/Me3c2Ahl4PmZaaE+dDzCVccIu+mV2YBxdtt
         6JJu4Z0Q6J7rnkEs2+/bSiA8bKYFdFJ6QcyZXHO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Shen <shenkai8@huawei.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 35/66] cpufreq: Add NULL checks to show() and store() methods of cpufreq
Date:   Wed, 27 Nov 2019 21:32:30 +0100
Message-Id: <20191127202713.995299070@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Shen <shenkai8@huawei.com>

commit e6e8df07268c1f75dd9215536e2ce4587b70f977 upstream.

Add NULL checks to show() and store() in cpufreq.c to avoid attempts
to invoke a NULL callback.

Though some interfaces of cpufreq are set as read-only, users can
still get write permission using chmod which can lead to a kernel
crash, as follows:

chmod +w /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
echo 1 >  /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

This bug was found in linux 4.19.

Signed-off-by: Kai Shen <shenkai8@huawei.com>
Reported-by: Feilong Lin <linfeilong@huawei.com>
Reviewed-by: Feilong Lin <linfeilong@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
[ rjw: Subject & changelog ]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -933,6 +933,9 @@ static ssize_t show(struct kobject *kobj
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret;
 
+	if (!fattr->show)
+		return -EIO;
+
 	down_read(&policy->rwsem);
 	ret = fattr->show(policy, buf);
 	up_read(&policy->rwsem);
@@ -947,6 +950,9 @@ static ssize_t store(struct kobject *kob
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret = -EINVAL;
 
+	if (!fattr->store)
+		return -EIO;
+
 	/*
 	 * cpus_read_trylock() is used here to work around a circular lock
 	 * dependency problem with respect to the cpufreq_register_driver().


