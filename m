Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F26F5798D6
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbiGSLzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiGSLzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DFBDEFF;
        Tue, 19 Jul 2022 04:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 886FB615C9;
        Tue, 19 Jul 2022 11:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEA5C341C6;
        Tue, 19 Jul 2022 11:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231736;
        bh=GQa+Ku1CeHENhMHosCghZ0yfKqd5BdcVUhg/DT+AMH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fK3g4+xvn4DMXF4gUj96cka4X2Gnrx+SILld+2yB2cKjkO1AXfULTgdG87GRpxz3y
         S8lkFQ8amobGV9NbjpaUIslbv/1SnCA6WHdy+TWrg228IcrSawCgaDsMbN319Oxlzu
         dqbVVJWEZpx0puxMxjCJNyEiIf+GRDDYTbGCc7Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Gupta <sumitg@nvidia.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 01/28] arm64: entry: Restore tramp_map_kernel ISB
Date:   Tue, 19 Jul 2022 13:53:39 +0200
Message-Id: <20220719114456.729095916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

Summit reports that the BHB backports for v4.9 prevent vulnerable
platforms from booting when CONFIG_RANDOMIZE_BASE is enabled.

This is because the trampoline code takes a translation fault when
accessing the data page, because the TTBR write hasn't been completed
by an ISB before the access is made.

Upstream has a complex erratum workaround for QCOM_FALKOR_E1003 in
this area, which removes the ISB when the workaround has been applied.
v4.9 lacks this workaround, but should still have the ISB.

Restore the barrier.

Fixes: aee10c2dd013 ("arm64: entry: Add macro for reading symbol addresses from the trampoline")
Reported-by: Sumit Gupta <sumitg@nvidia.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -964,6 +964,7 @@ __ni_sys_trace:
 	b	.
 2:
 	tramp_map_kernel	x30
+	isb
 	tramp_data_read_var	x30, vectors
 	prfm	plil1strm, [x30, #(1b - \vector_start)]
 	msr	vbar_el1, x30


