Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F7210BED4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfK0Uoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbfK0Uoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE5B62158A;
        Wed, 27 Nov 2019 20:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887476;
        bh=k/Dyu9LJWCKBpStK2Cb/skUnpzUZkV2F0/HVhCosvKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbxKO4lmL8awVswfevPYxhD/5ocivcy/TP73Ms0Td7u5tXlUDMp/nKEbpg0EXEwGG
         cRTqwW99JSPZut1sBZt1i9xS6h3Ls+TM76wwtsnXCNJyyD8NJJmQw11mNSoiqENtcb
         SVYSJyYZ7Z1g5QyYw8cgiumyp7fWR2do5vZHiWAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Shen <shenkai8@huawei.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 127/151] cpufreq: Add NULL checks to show() and store() methods of cpufreq
Date:   Wed, 27 Nov 2019 21:31:50 +0100
Message-Id: <20191127203045.863942526@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
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
@@ -875,6 +875,9 @@ static ssize_t show(struct kobject *kobj
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret;
 
+	if (!fattr->show)
+		return -EIO;
+
 	down_read(&policy->rwsem);
 	ret = fattr->show(policy, buf);
 	up_read(&policy->rwsem);
@@ -889,6 +892,9 @@ static ssize_t store(struct kobject *kob
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret = -EINVAL;
 
+	if (!fattr->store)
+		return -EIO;
+
 	get_online_cpus();
 
 	if (cpu_online(policy->cpu)) {


