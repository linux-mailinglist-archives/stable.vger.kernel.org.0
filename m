Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154F853815B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbiE3OT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbiE3ORO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C66E110ACE;
        Mon, 30 May 2022 06:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15E68B80D6B;
        Mon, 30 May 2022 13:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EC1C3411E;
        Mon, 30 May 2022 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918270;
        bh=Maymb1M0ojyJFMRqarHeva5kqwx2BGWP3YxckPlwec4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dg1DB0qc2/378gdwRyd4+HmebJF1xwlBrzWZlZYUJ+xlWcrk0q4W8nzyJj/nGbz8L
         qsZrX7R6Of7QWVS52kTdEcZXQsEUl8ijuDbkRCRbhiZEkDdNa39krrH/wwRmMOZt8B
         SXKW52DH7aPNIYH0snsPA1DC3pyt6q7gO7S7K5npPrCo2jQNXXdHmb+7MXLoDzAgrF
         lg7HXP7jW/O2+X2juj6DqK49PbU1LqZxs/193tRGsEn4bFc/Nkv0g1sgf/FEXaCP/8
         3XbcPU1X3Q8aS/P3q7mV2/HM8JGCRYs2V6F6E1E4TVvtpL8LXG+hrT6uykRzIakIgO
         PCqRQG19XIo1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Travis <mike.travis@hpe.com>, Steve Wahl <steve.wahl@hpe.com>,
        Borislav Petkov <bp@suse.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Subject: [PATCH AUTOSEL 5.10 10/76] x86/platform/uv: Update TSC sync state for UV5
Date:   Mon, 30 May 2022 09:43:00 -0400
Message-Id: <20220530134406.1934928-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index 40f466de8924..9c283562dfd4 100644
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

