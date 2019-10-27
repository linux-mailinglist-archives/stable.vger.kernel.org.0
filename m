Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47545E68CE
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbfJ0VcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730634AbfJ0VPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:15:21 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23253208C0;
        Sun, 27 Oct 2019 21:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210920;
        bh=mxlFduGrtNmhyGxvPtdAxMCFBlbbzn5BNzBEegfL3yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQQqlv8GUspFzhPMwgwaXG36XP72c+RHZ2nkYIilUhYXgUiIDGIz7M0shMePsSHTI
         cDkHWnYXN24mMQis7dXNt9+UZ49XXBxRAN7CNZOHL0IOiAfUgbe+HrBr7WhGAwhHjN
         +Vq1dpQXV0v2GBbDEa6n6RgPKmg7O1SXKXjmLNLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 62/93] drivers/base/memory.c: dont access uninitialized memmaps in soft_offline_page_store()
Date:   Sun, 27 Oct 2019 22:01:14 +0100
Message-Id: <20191027203305.837381571@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
@@ -554,6 +554,9 @@ store_soft_offline_page(struct device *d
 	pfn >>= PAGE_SHIFT;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
+	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
+	if (!pfn_to_online_page(pfn))
+		return -EIO;
 	ret = soft_offline_page(pfn_to_page(pfn), 0);
 	return ret == 0 ? count : ret;
 }


