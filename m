Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BE6121870
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfLPR7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbfLPR7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:59:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44ED221582;
        Mon, 16 Dec 2019 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519153;
        bh=2JwDM7TaPeUxhQ0KNFjZ43IsJOHsVpWhexDGziKV0Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGlZOQvJetKflbwAK8hr3OxFcs6F56wWurq3NykBgZY9kY0I1QOvsfdBGSAMqaaVv
         Syb3Xj7TCawnR7Dm1fCU9sHOfXKy6o/aYTVLxsI/MaSYa5EYbeiBw/tA9zk6h1sjjq
         hoSdwc1euwBJtxr22Iqw9ogKdxVLBKfuUKuCXmQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 216/267] cpufreq: powernv: fix stack bloat and hard limit on number of CPUs
Date:   Mon, 16 Dec 2019 18:49:02 +0100
Message-Id: <20191216174914.391297366@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit db0d32d84031188443e25edbd50a71a6e7ac5d1d upstream.

The following build warning occurred on powerpc 64-bit builds:

drivers/cpufreq/powernv-cpufreq.c: In function 'init_chip_info':
drivers/cpufreq/powernv-cpufreq.c:1070:1: warning: the frame size of
1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]

This is with a cross-compiler based on gcc 8.1.0, which I got from:
  https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/8.1.0/

The warning is due to putting 1024 bytes on the stack:

    unsigned int chip[256];

...and it's also undesirable to have a hard limit on the number of
CPUs here.

Fix both problems by dynamically allocating based on num_possible_cpus,
as recommended by Michael Ellerman.

Fixes: 053819e0bf840 ("cpufreq: powernv: Handle throttling due to Pmax capping at chip level")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/powernv-cpufreq.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -1002,9 +1002,14 @@ static struct cpufreq_driver powernv_cpu
 
 static int init_chip_info(void)
 {
-	unsigned int chip[256];
+	unsigned int *chip;
 	unsigned int cpu, i;
 	unsigned int prev_chip_id = UINT_MAX;
+	int ret = 0;
+
+	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
 
 	for_each_possible_cpu(cpu) {
 		unsigned int id = cpu_to_chip_id(cpu);
@@ -1016,8 +1021,10 @@ static int init_chip_info(void)
 	}
 
 	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
-	if (!chips)
-		return -ENOMEM;
+	if (!chips) {
+		ret = -ENOMEM;
+		goto free_and_return;
+	}
 
 	for (i = 0; i < nr_chips; i++) {
 		chips[i].id = chip[i];
@@ -1027,7 +1034,9 @@ static int init_chip_info(void)
 			per_cpu(chip_info, cpu) =  &chips[i];
 	}
 
-	return 0;
+free_and_return:
+	kfree(chip);
+	return ret;
 }
 
 static inline void clean_chip_info(void)


