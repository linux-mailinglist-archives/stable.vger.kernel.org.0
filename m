Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACCE461DCC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350477AbhK2S33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48616 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378376AbhK2S11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D99E0CE13D4;
        Mon, 29 Nov 2021 18:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A4CC53FAD;
        Mon, 29 Nov 2021 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210246;
        bh=v5C89pRKB96DEL+ZFjqnRns9T5V9j4hKf46ZtC3Dm4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+6x0TUVd1tq2Z/Ns4TgxcEATfYE9x3MXicRpySppJ8Rd8dEKFldGoCyJt5+o9NRM
         jNGL3StYMnFFl1G+NhGuAXTvc2x0wm5Sd69cOFNDrwPgul53IE7207ctAfkNij4KTd
         CJ5o/gnLgsxkDQeSx+jPnCSrcuWP5RjtR5L/+rPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bough Chen <haibo.chen@nxp.com>
Subject: [PATCH 5.4 21/92] mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB
Date:   Mon, 29 Nov 2021 19:17:50 +0100
Message-Id: <20211129181708.122106213@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 3d7c194b7c9ad414264935ad4f943a6ce285ebb1 upstream.

The block layer forces a minimum segment size of PAGE_SIZE, so a segment
can be too big for the ADMA table, if PAGE_SIZE >= 64KiB. Fix by writing
multiple descriptors, noting that the ADMA table is sized for 4KiB chunks
anyway, so it will be big enough.

Reported-and-tested-by: Bough Chen <haibo.chen@nxp.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211115082345.802238-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   21 ++++++++++++++++++---
 drivers/mmc/host/sdhci.h |    4 +++-
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -749,7 +749,19 @@ static void sdhci_adma_table_pre(struct
 			len -= offset;
 		}
 
-		BUG_ON(len > 65536);
+		/*
+		 * The block layer forces a minimum segment size of PAGE_SIZE,
+		 * so 'len' can be too big here if PAGE_SIZE >= 64KiB. Write
+		 * multiple descriptors, noting that the ADMA table is sized
+		 * for 4KiB chunks anyway, so it will be big enough.
+		 */
+		while (len > host->max_adma) {
+			int n = 32 * 1024; /* 32KiB*/
+
+			__sdhci_adma_write_desc(host, &desc, addr, n, ADMA2_TRAN_VALID);
+			addr += n;
+			len -= n;
+		}
 
 		/* tran, valid */
 		if (len)
@@ -3568,6 +3580,7 @@ struct sdhci_host *sdhci_alloc_host(stru
 	 * descriptor for each segment, plus 1 for a nop end descriptor.
 	 */
 	host->adma_table_cnt = SDHCI_MAX_SEGS * 2 + 1;
+	host->max_adma = 65536;
 
 	return host;
 }
@@ -4221,10 +4234,12 @@ int sdhci_setup_host(struct sdhci_host *
 	 * be larger than 64 KiB though.
 	 */
 	if (host->flags & SDHCI_USE_ADMA) {
-		if (host->quirks & SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC)
+		if (host->quirks & SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC) {
+			host->max_adma = 65532; /* 32-bit alignment */
 			mmc->max_seg_size = 65535;
-		else
+		} else {
 			mmc->max_seg_size = 65536;
+		}
 	} else {
 		mmc->max_seg_size = mmc->max_req_size;
 	}
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -349,7 +349,8 @@ struct sdhci_adma2_64_desc {
 
 /*
  * Maximum segments assuming a 512KiB maximum requisition size and a minimum
- * 4KiB page size.
+ * 4KiB page size. Note this also allows enough for multiple descriptors in
+ * case of PAGE_SIZE >= 64KiB.
  */
 #define SDHCI_MAX_SEGS		128
 
@@ -547,6 +548,7 @@ struct sdhci_host {
 	unsigned int blocks;	/* remaining PIO blocks */
 
 	int sg_count;		/* Mapped sg entries */
+	int max_adma;		/* Max. length in ADMA descriptor */
 
 	void *adma_table;	/* ADMA descriptor table */
 	void *align_buffer;	/* Bounce buffer */


