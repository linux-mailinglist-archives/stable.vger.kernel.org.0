Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925FF29B64E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797303AbgJ0PWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796875AbgJ0PWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94CB820728;
        Tue, 27 Oct 2020 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812164;
        bh=Kga7vEfZO3kPRLsus9Py7qIoN3l60BwB1lXwXne9Ku8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiSkXMmxzT18/aWUcn2rg0J8LcbMfrshl2zWtmVFms9k90A3bIpyIiDchIfth7hBf
         eEd3GcZK9gVKJ5upNeKfgpVjKnaS3eB/ZnXdevqThtmVCrvTtg0sbf/Y5RoIqxH8ps
         loRscj8JC12HbKOD3YneAIS+xPtsoF79sJraM+Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Meyer <kyle.meyer@hpe.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexei Budankov <alexey.budankov@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 107/757] perf/x86/intel/uncore: Fix for iio mapping on Skylake Server
Date:   Tue, 27 Oct 2020 14:45:57 +0100
Message-Id: <20201027135455.571628328@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Antonov <alexander.antonov@linux.intel.com>

[ Upstream commit f797f05d917ffef94249ee0aec4c14a5b50517b2 ]

Introduced early attributes /sys/devices/uncore_iio_<pmu_idx>/die* are
initialized by skx_iio_set_mapping(), however, for example, for multiple
segment platforms skx_iio_get_topology() returns -EPERM before a list of
attributes in skx_iio_mapping_group will have been initialized.
As a result the list is being NULL. Thus the warning
"sysfs: (bin_)attrs not set by subsystem for group: uncore_iio_*/" appears
and uncore_iio pmus are not available in sysfs. Clear IIO attr_update
to properly handle the cases when topology information cannot be
retrieved.

Fixes: bb42b3d39781 ("perf/x86/intel/uncore: Expose an Uncore unit to IIO PMON mapping")
Reported-by: Kyle Meyer <kyle.meyer@hpe.com>
Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alexei Budankov <alexey.budankov@linux.intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/20200928102133.61041-1-alexander.antonov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 62e88ad919ffc..ccfa1d6b6aa0d 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3749,7 +3749,9 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 
 	ret = skx_iio_get_topology(type);
 	if (ret)
-		return ret;
+		goto clear_attr_update;
+
+	ret = -ENOMEM;
 
 	/* One more for NULL. */
 	attrs = kcalloc((uncore_max_dies() + 1), sizeof(*attrs), GFP_KERNEL);
@@ -3781,8 +3783,9 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 	kfree(eas);
 	kfree(attrs);
 	kfree(type->topology);
+clear_attr_update:
 	type->attr_update = NULL;
-	return -ENOMEM;
+	return ret;
 }
 
 static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
-- 
2.25.1



