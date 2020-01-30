Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D80714E174
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbgA3Soc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730840AbgA3Soc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 187DB21734;
        Thu, 30 Jan 2020 18:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409871;
        bh=8OuebgqwLV2pZs9r42PHayOw/w5zaMYEWWmMvxUg8HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+Plv1Ekx4CPQy3dWcwe7eJVnUx9/ywa0AB8e1uEAOpvoc2Ht1k9HB+Em3GtlmldE
         qI1sktvZLtxyQgW/NiwFMC73wR65UAu6Bao7KfYfYJ2Q2c4Mf/7b7zhIR8wJqH2E3A
         PnAnrqKzPRhHewiiRNct5TzeONgGq+8j7vCscMCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/110] drivers/net/b44: Change to non-atomic bit operations on pwol_mask
Date:   Thu, 30 Jan 2020 19:38:43 +0100
Message-Id: <20200130183622.595145543@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
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
index 97ab0dd255522..1a7710c399d74 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1519,8 +1519,10 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
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
@@ -1532,7 +1534,8 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
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



