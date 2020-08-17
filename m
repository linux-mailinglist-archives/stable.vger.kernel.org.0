Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8DE2470E4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390717AbgHQSRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388378AbgHQQFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF1CA207FB;
        Mon, 17 Aug 2020 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680346;
        bh=x/U1bl+LeQHB8ISocmOrRYbQGZsUSt9XyVWUZ+kUUaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yq00zIznshsJwEtZrkCzMa1UqKUD205VXTs/z3y6ZvRRA+9NpwriS1V8W3zMOxmZd
         LHo9J7lZe9ZyhODGaeJwUkupUzffzcMuet2HAWtEhzjEveCayNOtjoVCGXTOre34Q4
         5ToCYveeoQyat6+MzN57JS4Su6loEyGJ8hHUAASs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/270] powerpc/book3s64/pkeys: Use PVR check instead of cpu feature
Date:   Mon, 17 Aug 2020 17:15:51 +0200
Message-Id: <20200817143803.288732568@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit d79e7a5f26f1d179cbb915a8bf2469b6d7431c29 ]

We are wrongly using CPU_FTRS_POWER8 to check for P8 support. Instead, we should
use PVR value. Now considering we are using CPU_FTRS_POWER8, that
implies we returned true for P9 with older firmware. Keep the same behavior
by checking for P9 PVR value.

Fixes: cf43d3b26452 ("powerpc: Enable pkey subsystem")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200709032946.881753-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/pkeys.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index 66f307e873dca..432fd9fa8c3f0 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -83,13 +83,17 @@ static int pkey_initialize(void)
 	scan_pkey_feature();
 
 	/*
-	 * Let's assume 32 pkeys on P8 bare metal, if its not defined by device
-	 * tree. We make this exception since skiboot forgot to expose this
-	 * property on power8.
+	 * Let's assume 32 pkeys on P8/P9 bare metal, if its not defined by device
+	 * tree. We make this exception since some version of skiboot forgot to
+	 * expose this property on power8/9.
 	 */
-	if (!pkeys_devtree_defined && !firmware_has_feature(FW_FEATURE_LPAR) &&
-			cpu_has_feature(CPU_FTRS_POWER8))
-		pkeys_total = 32;
+	if (!pkeys_devtree_defined && !firmware_has_feature(FW_FEATURE_LPAR)) {
+		unsigned long pvr = mfspr(SPRN_PVR);
+
+		if (PVR_VER(pvr) == PVR_POWER8 || PVR_VER(pvr) == PVR_POWER8E ||
+		    PVR_VER(pvr) == PVR_POWER8NVL || PVR_VER(pvr) == PVR_POWER9)
+			pkeys_total = 32;
+	}
 
 	/*
 	 * Adjust the upper limit, based on the number of bits supported by
-- 
2.25.1



