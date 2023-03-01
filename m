Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF126A72B5
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCASIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjCASIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:08:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECDA125B5
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 308A3B810DB
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708EEC4339B;
        Wed,  1 Mar 2023 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694107;
        bh=zamaA9Vk1EzkiScf96QeTHqC+OYlLZY2JBcDp5P9DuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jryWgMK0OmOe01HMe7gkU7tyuYqkU3jxXPnbow6PhYmbU0gGt0bVYKNrPj0EhFpzP
         FZVLccuIMWZZQqtRF1gxTuMqK1c30mW0WqczjDO5uUnWAKzPCL9zx1RBQjunQ+6BF3
         VwHGGOtF9s6Xc6lR363e+5XLFslNNrfZJGkRwRrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/13] ACPI: NFIT: fix a potential deadlock during NFIT teardown
Date:   Wed,  1 Mar 2023 19:07:26 +0100
Message-Id: <20230301180651.294761437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
References: <20230301180651.177668495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 0fe4f3ed72ca4..793b8d9d749a0 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3599,8 +3599,8 @@ void acpi_nfit_shutdown(void *data)
 
 	mutex_lock(&acpi_desc->init_mutex);
 	set_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
-	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
+	cancel_delayed_work_sync(&acpi_desc->dwork);
 
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
-- 
2.39.0



