Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80441E68FB
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfJ0VMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbfJ0VMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:07 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A3520873;
        Sun, 27 Oct 2019 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210726;
        bh=CgIvwC7qTH85RQI6kmwZ38ooNUQA/hoQ21zTCtaVeX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsDZHRFHUm73x1S691R497Ah0r97gqiZ/B/ZxR/1dTptbhuAtOpS8ok1Tsgz4pPP8
         /guJmSJA3kF32ocr8JGo7LudpSeGAxmoyDxemFokeDj03083w1ifvknaFcr5iX8rnh
         ezB3HKMWBj7gGndrsVqm5txwIR1SEkSDb417Ub7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 098/119] drivers/base/memory.c: dont access uninitialized memmaps in soft_offline_page_store()
Date:   Sun, 27 Oct 2019 22:01:15 +0100
Message-Id: <20191027203348.834120266@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 641fe2e9387a36f9ee01d7c69382d1fe147a5e98 upstream.

Uninitialized memmaps contain garbage and in the worst case trigger kernel
BUGs, especially with CONFIG_PAGE_POISONING.  They should not get touched.

Right now, when trying to soft-offline a PFN that resides on a memory
block that was never onlined, one gets a misleading error with
CONFIG_PAGE_POISONING:

  :/# echo 5637144576 > /sys/devices/system/memory/soft_offline_page
  [   23.097167] soft offline: 0x150000 page already poisoned

But the actual result depends on the garbage in the memmap.

soft_offline_page() can only work with online pages, it returns -EIO in
case of ZONE_DEVICE.  Make sure to only forward pages that are online
(iow, managed by the buddy) and, therefore, have an initialized memmap.

Add a check against pfn_to_online_page() and similarly return -EIO.

Link: http://lkml.kernel.org/r/20191010141200.8985-1-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -552,6 +552,9 @@ store_soft_offline_page(struct device *d
 	pfn >>= PAGE_SHIFT;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
+	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
+	if (!pfn_to_online_page(pfn))
+		return -EIO;
 	ret = soft_offline_page(pfn_to_page(pfn), 0);
 	return ret == 0 ? count : ret;
 }


