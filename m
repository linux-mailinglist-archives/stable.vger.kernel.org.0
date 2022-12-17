Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F7664FAC6
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiLQPkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiLQPj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:39:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1892180;
        Sat, 17 Dec 2022 07:30:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A5DB802C6;
        Sat, 17 Dec 2022 15:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C8CC43398;
        Sat, 17 Dec 2022 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671291041;
        bh=SLuoQTM+ujcjCEbGzYCHnjy9/9SF/cw1bs9ZM2PIfms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeraZjixlbJD5ox+1vsBB1sKf4HkdQPn8A8LoPAckNS0D/qcHMcIs3r8mVG8DbjT4
         BCx4maw6kphy9kf23Yrf/7xIrcFI9JNTJbcV9wzEg1DhgXyvg9Nagr4a2RzXo9ThlQ
         Vd/gd4Q2tEx2qPnnAw43KfLQGXe+41q71/z6goy5jQ8bAGVNhD3nfNorJvjG9aeEmz
         XlR1seggMvd47A+Gf5XFon2exO7+mWuTUY66DhTSQC9GZmK35vYeAfsziQ7o2rJGz3
         TjEPsqA+tyk4XRj4B+j+cNtWEssQN7YqFHCikcq4b7TF1J7T/JrYrSXzfHdC2zQbmz
         Op3pmxcIdFw/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Sasha Levin <sashal@kernel.org>, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 4/8] ACPICA: Fix error code path in acpi_ds_call_control_method()
Date:   Sat, 17 Dec 2022 10:30:27 -0500
Message-Id: <20221217153033.99394-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217153033.99394-1-sashal@kernel.org>
References: <20221217153033.99394-1-sashal@kernel.org>
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
index d7fc36917c67..88e729e24314 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -551,7 +551,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
 	if (!info) {
 		status = AE_NO_MEMORY;
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	info->parameters = &this_walk_state->operands[0];
@@ -563,7 +563,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	ACPI_FREE(info);
 	if (ACPI_FAILURE(status)) {
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	/*
@@ -595,6 +595,12 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
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

