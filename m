Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDE593686
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbiHOShE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244054AbiHOSgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:36:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FC02D1D4;
        Mon, 15 Aug 2022 11:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE1DAB81062;
        Mon, 15 Aug 2022 18:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF3BC433D6;
        Mon, 15 Aug 2022 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587789;
        bh=xF4ZESeti/WorROBW8Be43lu84T42KyEAFY2zI+iyTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vM2jt4fNenvvSdtgRJcGhk9LLpCD1b6c8jjEjgumrptnyXiqaXezU/0PHgY4O4ARO
         WCxNRa9l6YKu9+86dgK573EXoSO4V7zKp/BEAw4wO52tdnfQFewEhV2VaLpwY7eHLy
         y4X/d6cYWOOauz0OH/vTCQ/aYwP48ZA454zXFMiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Omar Avelar <omar.avelar@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/779] ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP
Date:   Mon, 15 Aug 2022 19:57:12 +0200
Message-Id: <20220815180345.290854764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit b13a3e5fd40b7d1b394c5ecbb5eb301a4c38e7b2 ]

When a platform marks a memory range as "special purpose" it is not
onlined as System RAM by default. However, it is still suitable for
error injection. Add IORES_DESC_SOFT_RESERVED to einj_error_inject() as
a permissible memory type in the sanity checking of the arguments to
_EINJ.

Fixes: 262b45ae3ab4 ("x86/efi: EFI soft reservation to E820 enumeration")
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reported-by: Omar Avelar <omar.avelar@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/einj.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 2882450c443e..2e0ab898cce3 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -544,6 +544,8 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
 	    ((region_intersects(base_addr, size, IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE)
 				!= REGION_INTERSECTS) &&
 	     (region_intersects(base_addr, size, IORESOURCE_MEM, IORES_DESC_PERSISTENT_MEMORY)
+				!= REGION_INTERSECTS) &&
+	     (region_intersects(base_addr, size, IORESOURCE_MEM, IORES_DESC_SOFT_RESERVED)
 				!= REGION_INTERSECTS)))
 		return -EINVAL;
 
-- 
2.35.1



