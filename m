Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765AF24BFC4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgHTNx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgHTJZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:25:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14C422D07;
        Thu, 20 Aug 2020 09:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915520;
        bh=A5/9brDvRPF70ERveEC5pLTQSGpg8dEFelBfyXyhmX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1384vXAv469WmQNv17oDsMyj4oXRBJN/ONLJ7XOaGFQUgwWQlMEkJ4lrzaFiWDXIx
         RxPNoOUez459yJd+wMZIOaIWbxvIMOwFimeqn62qCFK6qr6WDz0RZoA3LOS3KPdAIQ
         v+Dd+Xr9OHjFZr0GLKcq8ELI/goH7zyuhnTHLFnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.8 043/232] arm64: perf: Correct the event index in sysfs
Date:   Thu, 20 Aug 2020 11:18:14 +0200
Message-Id: <20200820091614.868071475@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

commit 539707caa1a89ee4efc57b4e4231c20c46575ccc upstream.

When PMU event ID is equal or greater than 0x4000, it will be reduced
by 0x4000 and it is not the raw number in the sysfs. Let's correct it
and obtain the raw event ID.

Before this patch:
cat /sys/bus/event_source/devices/armv8_pmuv3_0/events/sample_feed
event=0x001
After this patch:
cat /sys/bus/event_source/devices/armv8_pmuv3_0/events/sample_feed
event=0x4001

Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1592487344-30555-3-git-send-email-zhangshaokun@hisilicon.com
[will: fixed formatting of 'if' condition]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/perf_event.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -155,7 +155,7 @@ armv8pmu_events_sysfs_show(struct device
 
 	pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
 
-	return sprintf(page, "event=0x%03llx\n", pmu_attr->id);
+	return sprintf(page, "event=0x%04llx\n", pmu_attr->id);
 }
 
 #define ARMV8_EVENT_ATTR(name, config)						\
@@ -244,10 +244,13 @@ armv8pmu_event_attr_is_visible(struct ko
 	    test_bit(pmu_attr->id, cpu_pmu->pmceid_bitmap))
 		return attr->mode;
 
-	pmu_attr->id -= ARMV8_PMUV3_EXT_COMMON_EVENT_BASE;
-	if (pmu_attr->id < ARMV8_PMUV3_MAX_COMMON_EVENTS &&
-	    test_bit(pmu_attr->id, cpu_pmu->pmceid_ext_bitmap))
-		return attr->mode;
+	if (pmu_attr->id >= ARMV8_PMUV3_EXT_COMMON_EVENT_BASE) {
+		u64 id = pmu_attr->id - ARMV8_PMUV3_EXT_COMMON_EVENT_BASE;
+
+		if (id < ARMV8_PMUV3_MAX_COMMON_EVENTS &&
+		    test_bit(id, cpu_pmu->pmceid_ext_bitmap))
+			return attr->mode;
+	}
 
 	return 0;
 }


