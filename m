Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A928337C735
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhELP7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237705AbhELP4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED3616192C;
        Wed, 12 May 2021 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833294;
        bh=Mai0NKU/QFgHa9FfOPCE2dzE4MNZpc977LkLyuBDmls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OhcS4zUsmGly/YoOOvgisfw5a1rNTHMaMi1dvTHk6dnOx/kjMye9fLfOavsi8nOE
         ob3clMNfFb0b9QkTV/Vjf5dUaVhiEdS5CccoZSSQIBLhETmweYMUfPwOsnZ/ZTbmWZ
         l7ScubPySWeaF43vO+pvsKRHL5LxXeu9YAx7/BKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.11 092/601] s390: fix detection of vector enhancements facility 1 vs. vector packed decimal facility
Date:   Wed, 12 May 2021 16:42:49 +0200
Message-Id: <20210512144830.862575067@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit b208108638c4bd3215792415944467c36f5dfd97 upstream.

The PoP documents:
	134: The vector packed decimal facility is installed in the
	     z/Architecture architectural mode. When bit 134 is
	     one, bit 129 is also one.
	135: The vector enhancements facility 1 is installed in
	     the z/Architecture architectural mode. When bit 135
	     is one, bit 129 is also one.

Looks like we confuse the vector enhancements facility 1 ("EXT") with the
Vector packed decimal facility ("BCD"). Let's fix the facility checks.

Detected while working on QEMU/tcg z14 support and only unlocking
the vector enhancements facility 1, but not the vector packed decimal
facility.

Fixes: 2583b848cad0 ("s390: report new vector facilities")
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20210503121244.25232-1-david@redhat.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -924,9 +924,9 @@ static int __init setup_hwcaps(void)
 	if (MACHINE_HAS_VX) {
 		elf_hwcap |= HWCAP_S390_VXRS;
 		if (test_facility(134))
-			elf_hwcap |= HWCAP_S390_VXRS_EXT;
-		if (test_facility(135))
 			elf_hwcap |= HWCAP_S390_VXRS_BCD;
+		if (test_facility(135))
+			elf_hwcap |= HWCAP_S390_VXRS_EXT;
 		if (test_facility(148))
 			elf_hwcap |= HWCAP_S390_VXRS_EXT2;
 		if (test_facility(152))


