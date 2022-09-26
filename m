Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456815EA255
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiIZLGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiIZLEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0214F39C;
        Mon, 26 Sep 2022 03:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 500E860CEF;
        Mon, 26 Sep 2022 10:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4277EC433D7;
        Mon, 26 Sep 2022 10:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188406;
        bh=HwZx95QBBLtExNnRGltg/Imjeh2uE5xtRtIqxW2Z1ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUc7+78gLJOCKUhDYGnfQ7TFdVnp/jBW5U7Ym1phvIewXCJqYf/8UaBk6huk/L8fw
         +R28yezTMvXdxciwI0Th4pRGimj5uslmpLGYI8fals+mcFr9Kd/i3ZDZB/1/cDrQG7
         rwIQhDDUPxB62iO4lo00dQI7Z9aXgiL0bG+uGnS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 122/141] vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external()
Date:   Mon, 26 Sep 2022 12:12:28 +0200
Message-Id: <20220926100758.876908959@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 4ab4fcfce5b540227d80eb32f1db45ab615f7c92 upstream.

vaddr_get_pfns() now returns the positive number of pfns successfully
gotten instead of zero.  vfio_pin_page_external() might return 1 to
vfio_iommu_type1_pin_pages(), which will treat it as an error, if
vaddr_get_pfns() is successful but vfio_pin_page_external() doesn't
reach vfio_lock_acct().

Fix it up in vfio_pin_page_external().  Found by inspection.

Fixes: be16c1fd99f4 ("vfio/type1: Change success value of vaddr_get_pfn()")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Message-Id: <20210308172452.38864-1-daniel.m.jordan@oracle.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -671,7 +671,12 @@ static int vfio_pin_page_external(struct
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
-	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
+	if (ret != 1)
+		goto out;
+
+	ret = 0;
+
+	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
@@ -683,6 +688,7 @@ static int vfio_pin_page_external(struct
 		}
 	}
 
+out:
 	mmput(mm);
 	return ret;
 }


