Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13E25AAF7E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiIBMkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbiIBMiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A52D65E6;
        Fri,  2 Sep 2022 05:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 111B462160;
        Fri,  2 Sep 2022 12:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19934C433C1;
        Fri,  2 Sep 2022 12:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121723;
        bh=j/8XAWMQ7PlP+5WrROnEfX7lfhQhIwUDBWAojUg3vvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bce+ex7L1Isuslx8Z5x0OKXBF8m02AmNP+lbK0/sIMcnvNLZX+f/oVfO9FadtgbEm
         Bkt+/tdt8ADZc/1+EEgIdCExc3MSiRSNtWJJnhg51a2XGOC4PZqB2tkKDk1cb19/Lo
         G0mz4nxDjtPvMib5chsCUMoBXgemLyydD/3Lmo8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <Jeremy.Linton@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Riwen Lu <luriwen@kylinos.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 44/77] ACPI: processor: Remove freq Qos request for all CPUs
Date:   Fri,  2 Sep 2022 14:18:53 +0200
Message-Id: <20220902121405.116990661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riwen Lu <luriwen@kylinos.cn>

commit 36527b9d882362567ceb4eea8666813280f30e6f upstream.

The freq Qos request would be removed repeatedly if the cpufreq policy
relates to more than one CPU. Then, it would cause the "called for unknown
object" warning.

Remove the freq Qos request for each CPU relates to the cpufreq policy,
instead of removing repeatedly for the last CPU of it.

Fixes: a1bb46c36ce3 ("ACPI: processor: Add QoS requests for all CPUs")
Reported-by: Jeremy Linton <Jeremy.Linton@arm.com>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -150,7 +150,7 @@ void acpi_thermal_cpufreq_exit(struct cp
 	unsigned int cpu;
 
 	for_each_cpu(cpu, policy->related_cpus) {
-		struct acpi_processor *pr = per_cpu(processors, policy->cpu);
+		struct acpi_processor *pr = per_cpu(processors, cpu);
 
 		if (pr)
 			freq_qos_remove_request(&pr->thermal_req);


