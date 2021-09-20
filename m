Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25DB4122B0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbhITSQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376722AbhITSOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A76E61357;
        Mon, 20 Sep 2021 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158490;
        bh=qlg1y0Bd7rAZ6ydjMTUQqzyYTLtSOtt7u7SEugMD1KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msNog/SQc6EX3zABu9KJ9mHi3XzcDwjcWXEdC+Cz2CzHaV5QUOkwV5TzFIxVEVkVH
         DpiW1lbBARIP6nXp1M5f6bHW7ouYObtjVlKJkIixLSJE8m2mZfefIA2x4h5sz3n8f5
         f4zXZJcATNhA1agsBVBH51chyYwGUo14340nNKPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH 5.4 180/260] s390/pv: fix the forcing of the swiotlb
Date:   Mon, 20 Sep 2021 18:43:18 +0200
Message-Id: <20210920163937.211114213@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit 93ebb6828723b8aef114415c4dc3518342f7dcad upstream.

Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
swiotlb data bouncing") if code sets swiotlb_force it needs to do so
before the swiotlb is initialised. Otherwise
io_tlb_default_mem->force_bounce will not get set to true, and devices
that use (the default) swiotlb will not bounce despite switolb_force
having the value of SWIOTLB_FORCE.

Let us restore swiotlb functionality for PV by fulfilling this new
requirement.

This change addresses what turned out to be a fragility in
commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
virtualization"), which ain't exactly broken in its original context,
but could give us some more headache if people backport the broken
change and forget this fix.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
Cc: stable@vger.kernel.org #5.3+
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -168,9 +168,9 @@ static void pv_init(void)
 		return;
 
 	/* make sure bounce buffers are shared */
+	swiotlb_force = SWIOTLB_FORCE;
 	swiotlb_init(1);
 	swiotlb_update_mem_attributes();
-	swiotlb_force = SWIOTLB_FORCE;
 }
 
 void __init mem_init(void)


