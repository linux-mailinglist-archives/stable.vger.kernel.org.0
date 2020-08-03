Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2D723A4D6
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgHCMap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbgHCMap (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA81204EC;
        Mon,  3 Aug 2020 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457843;
        bh=+Quz9bAzkFoSwJFGisJLYqxgJJWP1s/CImbQT6cc/yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpZS7/4pruCnJAOEJ6gIauXSB0W6b8axrS3wayPtTwhvYNfncnDoN74Cv5+4Kpj90
         GtUBiWjcQwJK4BBPxRn5SA5ipufY1Glues5dtt/vznpCip0OJMiU+L7nZo+5bq8iZE
         rsCRYZ35Tta8LhSsYoi52IF+xZh/73HnPG+vVnbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, guodeqing <geffrey.guo@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/90] arm64: csum: Fix handling of bad packets
Date:   Mon,  3 Aug 2020 14:19:25 +0200
Message-Id: <20200803121900.666152142@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 05fb3dbda187bbd9cc1cd0e97e5d6595af570ac6 ]

Although iph is expected to point to at least 20 bytes of valid memory,
ihl may be bogus, for example on reception of a corrupt packet. If it
happens to be less than 5, we really don't want to run away and
dereference 16GB worth of memory until it wraps back to exactly zero...

Fixes: 0e455d8e80aa ("arm64: Implement optimised IP checksum helpers")
Reported-by: guodeqing <geffrey.guo@huawei.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/checksum.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/checksum.h b/arch/arm64/include/asm/checksum.h
index d064a50deb5fb..5665a3fc14be0 100644
--- a/arch/arm64/include/asm/checksum.h
+++ b/arch/arm64/include/asm/checksum.h
@@ -19,16 +19,17 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 {
 	__uint128_t tmp;
 	u64 sum;
+	int n = ihl; /* we want it signed */
 
 	tmp = *(const __uint128_t *)iph;
 	iph += 16;
-	ihl -= 4;
+	n -= 4;
 	tmp += ((tmp >> 64) | (tmp << 64));
 	sum = tmp >> 64;
 	do {
 		sum += *(const u32 *)iph;
 		iph += 4;
-	} while (--ihl);
+	} while (--n > 0);
 
 	sum += ((sum >> 32) | (sum << 32));
 	return csum_fold((__force u32)(sum >> 32));
-- 
2.25.1



