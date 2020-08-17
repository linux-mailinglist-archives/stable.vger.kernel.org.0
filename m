Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6324761C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731994AbgHQTd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730238AbgHQPaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C1723107;
        Mon, 17 Aug 2020 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678251;
        bh=92vrbsga9B/BbPLc5QxUi8xf1J0xoZclIrgE6YvAtlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWD+069oZQbLDk2ltSEp1fBDbmaLLbSUFW4DjN95vAFe4CLd7yOcpq6hqj5K8d1tW
         55XQy3b6/UV/RRDIBVtRrMpNfKtD2AOzGvCT69+EsIPSd0V57YWadnudjKdo5Vszca
         MzSefe2sA9BkqhzapvAnYMiDNCtK5hFrbUXl9ctE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 252/464] powerpc/book3s64/pkeys: Use PVR check instead of cpu feature
Date:   Mon, 17 Aug 2020 17:13:25 +0200
Message-Id: <20200817143845.866219754@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index d174106bab676..82ace6acb0aa9 100644
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



