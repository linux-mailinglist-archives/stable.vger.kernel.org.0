Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EBC64FA69
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiLQPlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiLQPj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:39:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D6813E13;
        Sat, 17 Dec 2022 07:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A838B8049B;
        Sat, 17 Dec 2022 15:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D98DC433F1;
        Sat, 17 Dec 2022 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671291062;
        bh=UwPT3DNk5t4dSFGTTejzKR0Qkzhat5PlsoNZ741aEzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZJQucnrKN80HbgGkfK0666V8R2xqe/aavTiEYu0lYbS3XTCAcX/RIpY8eH3IC/V4
         rR74Jj8F3PDSxldheDLea6BOh/yRHVOcZanQE2BNLyiBSMjibaf1Cpqgwv6Lj0tJq6
         o6qRc7PNNFyCZLKRNib1DBja22MJJ5a8v03qeGVYOoRI3rlrgQnWNhDV8VPAobY3t9
         OJffmsp0Hl2EpvB75q0qfXmcVCyoTlTIFPS7+PlxNAWjYdU3Y+uO0UNHINzoqDaCht
         Jfo8vKjrMkI+ixNhImIxpH9LCoEwMJxpaZFtDiHKwTe8+VGMVq2WPsPbJabYkrLU3d
         JeGicaVcyhvBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Sasha Levin <sashal@kernel.org>, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 4.9 4/8] ACPICA: Fix error code path in acpi_ds_call_control_method()
Date:   Sat, 17 Dec 2022 10:30:48 -0500
Message-Id: <20221217153053.99513-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217153053.99513-1-sashal@kernel.org>
References: <20221217153053.99513-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 404ec60438add1afadaffaed34bb5fe4ddcadd40 ]

A use-after-free in acpi_ps_parse_aml() after a failing invocaion of
acpi_ds_call_control_method() is reported by KASAN [1] and code
inspection reveals that next_walk_state pushed to the thread by
acpi_ds_create_walk_state() is freed on errors, but it is not popped
from the thread beforehand.  Thus acpi_ds_get_current_walk_state()
called by acpi_ps_parse_aml() subsequently returns it as the new
walk state which is incorrect.

To address this, make acpi_ds_call_control_method() call
acpi_ds_pop_walk_state() to pop next_walk_state from the thread before
returning an error.

Link: https://lore.kernel.org/linux-acpi/20221019073443.248215-1-chenzhongjin@huawei.com/ # [1]
Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 2b3210f42a46..b77d6b86e3f9 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -547,7 +547,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
 	if (!info) {
 		status = AE_NO_MEMORY;
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	info->parameters = &this_walk_state->operands[0];
@@ -559,7 +559,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	ACPI_FREE(info);
 	if (ACPI_FAILURE(status)) {
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	/*
@@ -591,6 +591,12 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	return_ACPI_STATUS(status);
 
+pop_walk_state:
+
+	/* On error, pop the walk state to be deleted from thread */
+
+	acpi_ds_pop_walk_state(thread);
+
 cleanup:
 
 	/* On error, we must terminate the method properly */
-- 
2.35.1

