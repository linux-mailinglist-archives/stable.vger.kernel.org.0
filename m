Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50885558258
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiFWRNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbiFWRMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9F4FD0F;
        Thu, 23 Jun 2022 09:58:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A136B8248C;
        Thu, 23 Jun 2022 16:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C090C341C4;
        Thu, 23 Jun 2022 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003494;
        bh=16b6PY1TeUWnE/IpvugwSpZqVE6hi1bxiN09PYoNemo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq6KZZGW+cJ9z5U8ff7k7pFIACxDKlTFU7NMwM0YJfLDPP3xuVsZ2qDouReogHZqR
         wZM6SgbcKR9zHYgMplN1IPrmaqvUsk3OFkFBkahtAYwqrfqy6estv8RiWjy6BEEjtr
         Pa5wWKxQnO5R0kxOJ5jwnXIOgpLpiP/Pc36qbyFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 255/264] Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Thu, 23 Jun 2022 18:44:08 +0200
Message-Id: <20220623164351.280903965@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.

Halil Pasic points out [1] that the full revert of that commit (revert
in bddac7c1e02b), and that a partial revert that only reverts the
problematic case, but still keeps some of the cleanups is probably
better.  ￼

And that partial revert [2] had already been verified by Oleksandr
Natalenko to also fix the issue, I had just missed that in the long
discussion.

So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
revert the part that caused problems.

Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[OP: backport to 4.14: apply swiotlb_tbl_map_single() changes in lib/swiotlb.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/DMA-attributes.txt |   10 ----------
 include/linux/dma-mapping.h      |    7 -------
 lib/swiotlb.c                    |   12 ++++++++----
 3 files changed, 8 insertions(+), 21 deletions(-)

--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -143,13 +143,3 @@ So, this provides a way for drivers to a
 where allocation failures are not a problem, and shouldn't bother the logs.
 
 NOTE: At the moment DMA_ATTR_NO_WARN is only implemented on PowerPC.
-
-DMA_ATTR_PRIVILEGED
--------------------
-
-Some advanced peripherals such as remote processors and GPUs perform
-accesses to DMA buffers in both privileged "supervisor" and unprivileged
-"user" modes.  This attribute is used to indicate to the DMA-mapping
-subsystem that the buffer is fully accessible at the elevated privilege
-level (and ideally inaccessible or at least read-only at the
-lesser-privileged levels).
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -61,13 +61,6 @@
  * allocation failure reports (similarly to __GFP_NOWARN).
  */
 #define DMA_ATTR_NO_WARN	(1UL << 8)
-/*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
 
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -532,10 +532,14 @@ found:
 	 */
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
-	if (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL)
-		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
-
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);


