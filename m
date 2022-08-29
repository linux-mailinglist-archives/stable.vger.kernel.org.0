Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133A65A49E2
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiH2Lab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiH2L3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B056BD6E;
        Mon, 29 Aug 2022 04:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E68B80EF9;
        Mon, 29 Aug 2022 11:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BB8C433C1;
        Mon, 29 Aug 2022 11:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771866;
        bh=TIdyKdAkcSSW5Rd2m+KBqi/gONXq4wuVg3dZijXOv2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxTcStK967DHoez9dtsYnvIQ4A+xyK+u+UxzMENMvs/OrQHNCn7ih1AkgzmP8huGs
         d0OWJ7KudS4XpBL00uSC1nBQiovy5fysv3ztVECu8iDH8am4FTSndydA6v2qF4Iisd
         0kdEAQqdLjtGkPjr65VlMqbeOVcBPfNJ4/Xr8sp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <Jeremy.Linton@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Riwen Lu <luriwen@kylinos.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.19 124/158] ACPI: processor: Remove freq Qos request for all CPUs
Date:   Mon, 29 Aug 2022 12:59:34 +0200
Message-Id: <20220829105814.298494854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
@@ -151,7 +151,7 @@ void acpi_thermal_cpufreq_exit(struct cp
 	unsigned int cpu;
 
 	for_each_cpu(cpu, policy->related_cpus) {
-		struct acpi_processor *pr = per_cpu(processors, policy->cpu);
+		struct acpi_processor *pr = per_cpu(processors, cpu);
 
 		if (pr)
 			freq_qos_remove_request(&pr->thermal_req);


