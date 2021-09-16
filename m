Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D9A40E4EE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244976AbhIPRGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348881AbhIPRDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C360617E2;
        Thu, 16 Sep 2021 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810065;
        bh=BBeyKNK44+fXwO9rcbxjtQzZo+draOt3fVXpXTPATWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkgfa4tjD1tuP+6QymaCinnj3zrZyss+SpnnfKAviQsTImzvp989fd6QBY7fGP1ho
         DbDpvkKm2eAUARjOEPp4Dyiz8vpeWH07m1t4DIoEZCAP6fLKpggAQHn88s5aTXnHLE
         yG2e65eJ1CFn5FKWfAni14PLIFxpYuQ7xGxoLYdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH 5.13 355/380] s390/pv: fix the forcing of the swiotlb
Date:   Thu, 16 Sep 2021 18:01:52 +0200
Message-Id: <20210916155816.134595528@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
@@ -186,9 +186,9 @@ static void pv_init(void)
 		return;
 
 	/* make sure bounce buffers are shared */
+	swiotlb_force = SWIOTLB_FORCE;
 	swiotlb_init(1);
 	swiotlb_update_mem_attributes();
-	swiotlb_force = SWIOTLB_FORCE;
 }
 
 void __init mem_init(void)


