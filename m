Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51FE6358D5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiKWKDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbiKWKB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA2EE634B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15D561B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2346C433C1;
        Wed, 23 Nov 2022 09:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197243;
        bh=P69XkczsHIbTF3iSIvY2sEtDIH/dFVjsIoFZ8FyFLU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhZgft0of5q8G1srABMhCjU1paMwSeUwN7+NCES+dICMG3L96J+t//RaMyu8JHfmD
         ujP3RV3iwuuHgZjT1To3K61g3numpLiOGOteflcbgjYm+3oUKZuGxDhJ+P1MhnIwfA
         9W90NlqPkmwaYXENCq0HFma+ixITXrkczwG6PSYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, liyupeng@zbhlos.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.0 208/314] platform/x86/amd: pmc: Remove more CONFIG_DEBUG_FS checks
Date:   Wed, 23 Nov 2022 09:50:53 +0100
Message-Id: <20221123084634.962307164@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit a5b5fb0fc47ddc7d1ed6a0365197639a01bc1f3a upstream.

commit b37fe34c8309 ("platform/x86/amd: pmc: remove CONFIG_DEBUG_FS
checks") removed most CONFIG_DEBUG_FS checks, but there were some
left that were reported to cause compile test failures.

Remove the remaining checks, and also the unnecessary CONFIG_SUSPEND
used in the same place.

Reported-by: liyupeng@zbhlos.com
Fixes: b37fe34c8309 ("platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216679
Link: https://lore.kernel.org/r/20221108023323.19304-1-mario.limonciello@amd.com
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -274,7 +274,6 @@ static const struct file_operations amd_
 	.release = amd_pmc_stb_debugfs_release_v2,
 };
 
-#if defined(CONFIG_SUSPEND) || defined(CONFIG_DEBUG_FS)
 static int amd_pmc_setup_smu_logging(struct amd_pmc_dev *dev)
 {
 	if (dev->cpu_id == AMD_CPU_ID_PCO) {
@@ -349,7 +348,6 @@ static int get_metrics_table(struct amd_
 	memcpy_fromio(table, pdev->smu_virt_addr, sizeof(struct smu_metrics));
 	return 0;
 }
-#endif /* CONFIG_SUSPEND || CONFIG_DEBUG_FS */
 
 #ifdef CONFIG_SUSPEND
 static void amd_pmc_validate_deepest(struct amd_pmc_dev *pdev)


