Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E54654111F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351848AbiFGTdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351979AbiFGTcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:32:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF9C5E6A;
        Tue,  7 Jun 2022 11:12:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43E7AB81F38;
        Tue,  7 Jun 2022 18:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A718BC385A2;
        Tue,  7 Jun 2022 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625566;
        bh=FQ0KiZojiiCMdSntTJQX+VlNmgl4iS0gWsxYxk6CTm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ekpx1raWIwZRC8jH4/w9N1Nd1XcG58MU8tCKdyG8r6BdtXXDZY9v4HNywrT828LP9
         er6mCRRukXeKnTiOLjzENd29vENTqTLf13B6vD+vxDjhefJxMe2+PWf1A8tVdSoYwm
         Dar9DNrLkXDRB6kLgkVQNHfNZ4zsd5mxUFdQ/NAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Travis <mike.travis@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, Borislav Petkov <bp@suse.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 063/772] x86/platform/uv: Update TSC sync state for UV5
Date:   Tue,  7 Jun 2022 18:54:15 +0200
Message-Id: <20220607164950.896055261@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



