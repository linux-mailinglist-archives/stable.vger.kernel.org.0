Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BCE643367
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiLETgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiLETf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:35:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F3826563
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72D87CE13A9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D08FC433C1;
        Mon,  5 Dec 2022 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268740;
        bh=2ZBM5bbmiVnc/4uUacqA1Sp4IFcHk4hcdP9ds5k5tEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4u8x8vzjdiWAn0wPRofEqJ7gqs9VeND3rRbPGt+y0EDn2JBdMNGMfjFny1OpNh9t
         QPJOfqDY0JMFE2LzZRgdsbvUEhaletVOI+u94tbVXkvfHE5YiMgVrzb4VY8t5pBdnn
         RiCW1OfpN6AQYsGGZF3n0HB2eSmFt4FpXcKAphLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Liu Shixin <liushixin2@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 87/92] ACPI: HMAT: remove unnecessary variable initialization
Date:   Mon,  5 Dec 2022 20:10:40 +0100
Message-Id: <20221205190806.344792874@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

[ Upstream commit 14f16d47561ba9249efc6c2db9d47ed56841f070 ]

In hmat_register_target_initiators(), the variable 'best' gets
initialized in the outer per-locality-type for loop. The initialization
just before setting up 'Access 1' targets was unnecessary. Remove it.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/20221116-acpi_hmat_fix-v2-1-3712569be691@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 48d4180939e1 ("ACPI: HMAT: Fix initiator registration for single-initiator systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 137a5dd880c2..fd202689dcda 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -645,7 +645,6 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
 	list_sort(p_nodes, &initiators, initiator_cmp);
-	best = 0;
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
-- 
2.35.1



