Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70FC657E1B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiL1PuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiL1PuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:50:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB0318682
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:50:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BAF4613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82963C433EF;
        Wed, 28 Dec 2022 15:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242602;
        bh=9HvOEQbQmJQMCPPSxuy7oPpJ+xnXyQ9GRx5pwrDqMPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD8+N4uiZb8NqkvuwKLj4aeq75687oiuYGqC1ej1ZkdW8LdXlL5tGnpS4kMxm07xc
         IdQsYRKomMkl35mpgSc0FF8lMpSA72AWZujhQj07K6aovkvk2hIbjzIUD9/kqb0efM
         HTU9Z6l1D5eBKBpb3I1wo+Gm3DjuBYDayKLrLx1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 624/731] ACPICA: Fix error code path in acpi_ds_call_control_method()
Date:   Wed, 28 Dec 2022 15:42:11 +0100
Message-Id: <20221228144314.619093268@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index 8e011e59b9b4..ee1832ba39a2 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -517,7 +517,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
 	if (!info) {
 		status = AE_NO_MEMORY;
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	info->parameters = &this_walk_state->operands[0];
@@ -529,7 +529,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	ACPI_FREE(info);
 	if (ACPI_FAILURE(status)) {
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	next_walk_state->method_nesting_depth =
@@ -575,6 +575,12 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
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



