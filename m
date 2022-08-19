Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE98D59A088
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350938AbiHSP76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350936AbiHSP7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:59:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A128B108F97;
        Fri, 19 Aug 2022 08:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21C31B82813;
        Fri, 19 Aug 2022 15:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76624C433C1;
        Fri, 19 Aug 2022 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924318;
        bh=hHjXvohnaNdS+Nlt1BdI92wZ/8EHawjr4j2i+Mkh8F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iMAkaV00u+7wI/0EVmN/snbQsRqxGS5Xk1rz9MKvTKHEI6IetqptCXqHGheFdxgm
         gxinrDzzxcYxtbGpTGAfT/esUomQIV5TcBzh9LKJLwXDIckjP1oTW/ZIGFcVxu3c5u
         gtzb/nfPHNzLa8baObIwxkz1UJr56Aa+YqGvdTxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Omar Avelar <omar.avelar@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/545] ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP
Date:   Fri, 19 Aug 2022 17:38:21 +0200
Message-Id: <20220819153835.193817455@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 133156759551..c281d5b339d3 100644
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



