Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB65EA554
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiIZMAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiIZL6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE67A774;
        Mon, 26 Sep 2022 03:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33F1A60BAF;
        Mon, 26 Sep 2022 10:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41375C433D6;
        Mon, 26 Sep 2022 10:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189491;
        bh=sgHXT3LlirVMkqBoHOPqiiag2KMBYEjerSrFk8IJX/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+DztX8PyDc8T/y7mOazTgZhgvu0NvGeRESaIxxg2EK9+fM86FTP5LogUL6mXKIUI
         gmp+ya4EbLo13dKv/xDt9ZLbmm3mnyBkt5k5mVQizFi8ouio0YFAvsorYPlDtJV3nM
         OZ7qHC3NRh9opFKaMIAf1mCNIKKh2vgGXKEK9lMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Omar Avelar <omar.avelar@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <markgross@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.19 199/207] devdax: Fix soft-reservation memory description
Date:   Mon, 26 Sep 2022 12:13:08 +0200
Message-Id: <20220926100815.500660745@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 67feaba413ec68daf4124e9870878899b4ed9a0e upstream.

The "hmem" platform-devices that are created to represent the
platform-advertised "Soft Reserved" memory ranges end up inserting a
resource that causes the iomem_resource tree to look like this:

340000000-43fffffff : hmem.0
  340000000-43fffffff : Soft Reserved
    340000000-43fffffff : dax0.0

This is because insert_resource() reparents ranges when they completely
intersect an existing range.

This matters because code that uses region_intersects() to scan for a
given IORES_DESC will only check that top-level 'hmem.0' resource and
not the 'Soft Reserved' descendant.

So, to support EINJ (via einj_error_inject()) to inject errors into
memory hosted by a dax-device, be sure to describe the memory as
IORES_DESC_SOFT_RESERVED. This is a follow-on to:

commit b13a3e5fd40b ("ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP")

...that fixed EINJ support for "Soft Reserved" ranges in the first
instance.

Fixes: 262b45ae3ab4 ("x86/efi: EFI soft reservation to E820 enumeration")
Reported-by: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>
Tested-by: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Omar Avelar <omar.avelar@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mark Gross <markgross@kernel.org>
Link: https://lore.kernel.org/r/166397075670.389916.7435722208896316387.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dax/hmem/device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -15,6 +15,7 @@ void hmem_register_device(int target_nid
 		.start = r->start,
 		.end = r->end,
 		.flags = IORESOURCE_MEM,
+		.desc = IORES_DESC_SOFT_RESERVED,
 	};
 	struct platform_device *pdev;
 	struct memregion_info info;


