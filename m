Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9656569862D
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjBOUsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBOUrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662A94391B;
        Wed, 15 Feb 2023 12:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442C361DA6;
        Wed, 15 Feb 2023 20:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F95C433A1;
        Wed, 15 Feb 2023 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494014;
        bh=byYUexaPJPAmBnEC6Lt4VbHe7WyASuTrTCvR4mx5I34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxtvC9j8Z+zp62T3FYPuIxoFasLbi3oIPBTYHDn3MV/SfhjDb4HgAf1Ts9cEIEbmb
         Hm0ymL6RnA29NLxWkpxJKGnTISvRBt0Fq/oiwpboB6zsBYypGeUUByDNB50wiASFZh
         pEpckdkKlLMDT8sNDAf4nqUS6jTs5dV2BcNR+iW1cilvPlcOCe5fx4Ri9u4zAr2sIC
         /KMYehfyRcBlt3R7pQnsxrlRuaDW5PBCGzMCg1k/h6qlYBun8XfNwo2Esp4Mkdbyr2
         w9xSaO8gP5RbZ8LqFUxZYacxnpAr+GJ5scC029C/k1dOCeaZ5/Pl/RTVh6Pq1/R0F+
         0u7VwFPpKeI2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, dave.jiang@intel.com,
        ira.weiny@intel.com, rafael@kernel.org, nvdimm@lists.linux.dev,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/8] ACPI: NFIT: fix a potential deadlock during NFIT teardown
Date:   Wed, 15 Feb 2023 15:46:45 -0500
Message-Id: <20230215204649.2761225-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204649.2761225-1-sashal@kernel.org>
References: <20230215204649.2761225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit fb6df4366f86dd252bfa3049edffa52d17e7b895 ]

Lockdep reports that acpi_nfit_shutdown() may deadlock against an
opportune acpi_nfit_scrub(). acpi_nfit_scrub () is run from inside a
'work' and therefore has already acquired workqueue-internal locks. It
also acquiires acpi_desc->init_mutex. acpi_nfit_shutdown() first
acquires init_mutex, and was subsequently attempting to cancel any
pending workqueue items. This reversed locking order causes a potential
deadlock:

    ======================================================
    WARNING: possible circular locking dependency detected
    6.2.0-rc3 #116 Tainted: G           O     N
    ------------------------------------------------------
    libndctl/1958 is trying to acquire lock:
    ffff888129b461c0 ((work_completion)(&(&acpi_desc->dwork)->work)){+.+.}-{0:0}, at: __flush_work+0x43/0x450

    but task is already holding lock:
    ffff888129b460e8 (&acpi_desc->init_mutex){+.+.}-{3:3}, at: acpi_nfit_shutdown+0x87/0xd0 [nfit]

    which lock already depends on the new lock.

    ...

    Possible unsafe locking scenario:

          CPU0                    CPU1
          ----                    ----
     lock(&acpi_desc->init_mutex);
                                  lock((work_completion)(&(&acpi_desc->dwork)->work));
                                  lock(&acpi_desc->init_mutex);
     lock((work_completion)(&(&acpi_desc->dwork)->work));

    *** DEADLOCK ***

Since the workqueue manipulation is protected by its own internal locking,
the cancellation of pending work doesn't need to be done under
acpi_desc->init_mutex. Move cancel_delayed_work_sync() outside the
init_mutex to fix the deadlock. Any work that starts after
acpi_nfit_shutdown() drops the lock will see ARS_CANCEL, and the
cancel_delayed_work_sync() will safely flush it out.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/20230112-acpi_nfit_lockdep-v1-1-660be4dd10be@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 99e23a5df0267..2306abb09f7f5 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3687,8 +3687,8 @@ void acpi_nfit_shutdown(void *data)
 
 	mutex_lock(&acpi_desc->init_mutex);
 	set_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
-	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
+	cancel_delayed_work_sync(&acpi_desc->dwork);
 
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
-- 
2.39.0

