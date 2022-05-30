Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E716053806D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbiE3N7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237021AbiE3N5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:57:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F54980B9;
        Mon, 30 May 2022 06:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B202B80DAD;
        Mon, 30 May 2022 13:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D730C341C6;
        Mon, 30 May 2022 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917937;
        bh=FQ0KiZojiiCMdSntTJQX+VlNmgl4iS0gWsxYxk6CTm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=om8tbB8c4t7wSO2J3riJsJbsxsNgxHpggO2vGgCWMVl7gU3HIWaYu8zOfn7jvansQ
         mImdcOeNiBSHQ8Q7Fy2fsmdmO3dU1lpc8zIhYlZyrAlKdqf9sLbkAWFaZ77wTrdQRV
         Px7L6nqfam4ZgF/3GKUBXkzSHKe2rqNu1CQmtgvGy4Eps0y53s3abagggq5pu7MenI
         YLwlbPoEmtEweG+RDroYf8gG/B2ffDY5aihDC28+S41hT2hBmt7iGX60Kt6xlQYDGc
         g3Kndiy1V8GCOj5es24gSIzqWbgfpSKWvHhxrDvj+1hUFWBxVk8PmZHGKJYvW8leX0
         0/Uah0Qf0M8VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Travis <mike.travis@hpe.com>, Steve Wahl <steve.wahl@hpe.com>,
        Borislav Petkov <bp@suse.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Subject: [PATCH AUTOSEL 5.15 012/109] x86/platform/uv: Update TSC sync state for UV5
Date:   Mon, 30 May 2022 09:36:48 -0400
Message-Id: <20220530133825.1933431-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Travis <mike.travis@hpe.com>

[ Upstream commit bb3ab81bdbd53f88f26ffabc9fb15bd8466486ec ]

The UV5 platform synchronizes the TSCs among all chassis, and will not
proceed to OS boot without achieving synchronization.  Previous UV
platforms provided a register indicating successful synchronization.
This is no longer available on UV5.  On this platform TSC_ADJUST
should not be reset by the kernel.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220406195149.228164-3-steve.wahl@hpe.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5a48e66e4f5..a6e9c2794ef5 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -199,7 +199,13 @@ static void __init uv_tsc_check_sync(void)
 	int mmr_shift;
 	char *state;
 
-	/* Different returns from different UV BIOS versions */
+	/* UV5 guarantees synced TSCs; do not zero TSC_ADJUST */
+	if (!is_uv(UV2|UV3|UV4)) {
+		mark_tsc_async_resets("UV5+");
+		return;
+	}
+
+	/* UV2,3,4, UV BIOS TSC sync state available */
 	mmr = uv_early_read_mmr(UVH_TSC_SYNC_MMR);
 	mmr_shift =
 		is_uv2_hub() ? UVH_TSC_SYNC_SHIFT_UV2K : UVH_TSC_SYNC_SHIFT;
-- 
2.35.1

