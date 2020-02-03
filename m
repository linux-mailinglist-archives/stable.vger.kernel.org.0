Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49D4150BB3
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgBCQ3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbgBCQ3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:29:45 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE9E20838;
        Mon,  3 Feb 2020 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747384;
        bh=c+d813cZMCYf0vAj2pTZXXiLVWj7SVH0DsY+S6RlMds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3z1dP6A9kCFsm/oeTRsd1ASuhOeJ2eMUTFKmld2stU3bS0tOr2JcKBN+fUYgtLFd
         FnEZlj9uQD8AAlYvsLrrvLBAB8JnPk731bWBKSvb5bCQIFn3o9pgE38VdRR88KhjYf
         7QwYzB/NEFiqGzvM1F4OjZ4+ruT/LcYsvoFwIPPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/89] drivers/net/b44: Change to non-atomic bit operations on pwol_mask
Date:   Mon,  3 Feb 2020 16:19:09 +0000
Message-Id: <20200203161920.127855118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit f11421ba4af706cb4f5703de34fa77fba8472776 ]

Atomic operations that span cache lines are super-expensive on x86
(not just to the current processor, but also to other processes as all
memory operations are blocked until the operation completes). Upcoming
x86 processors have a switch to cause such operations to generate a #AC
trap. It is expected that some real time systems will enable this mode
in BIOS.

In preparation for this, it is necessary to fix code that may execute
atomic instructions with operands that cross cachelines because the #AC
trap will crash the kernel.

Since "pwol_mask" is local and never exposed to concurrency, there is
no need to set bits in pwol_mask using atomic operations.

Directly operate on the byte which contains the bit instead of using
__set_bit() to avoid any big endian concern due to type cast to
unsigned long in __set_bit().

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/b44.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index a1125d10c8255..8b9a0ce1d29f5 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1521,8 +1521,10 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
 	int ethaddr_bytes = ETH_ALEN;
 
 	memset(ppattern + offset, 0xff, magicsync);
-	for (j = 0; j < magicsync; j++)
-		set_bit(len++, (unsigned long *) pmask);
+	for (j = 0; j < magicsync; j++) {
+		pmask[len >> 3] |= BIT(len & 7);
+		len++;
+	}
 
 	for (j = 0; j < B44_MAX_PATTERNS; j++) {
 		if ((B44_PATTERN_SIZE - len) >= ETH_ALEN)
@@ -1534,7 +1536,8 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
 		for (k = 0; k< ethaddr_bytes; k++) {
 			ppattern[offset + magicsync +
 				(j * ETH_ALEN) + k] = macaddr[k];
-			set_bit(len++, (unsigned long *) pmask);
+			pmask[len >> 3] |= BIT(len & 7);
+			len++;
 		}
 	}
 	return len - 1;
-- 
2.20.1



