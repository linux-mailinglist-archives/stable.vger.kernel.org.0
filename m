Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455F52A5425
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbgKCVIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388437AbgKCVI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:08:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCF74205ED;
        Tue,  3 Nov 2020 21:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437708;
        bh=IWEh56u87Cs6dYeC6BIPkFHiQMdL4trEXbO7sVHIeds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AL4Qnnq6P9UZswIJSMiS5xvzpkhof0n/V70uumbYSIuWjK+hXblSamdfe0HY/r5iE
         F9Sxp4O/z26hs58nfC5WuSKOwnjuh8AiNCifZB7a47/2imcvgLfM3zjexXjzbf3lLH
         4rF2numZzbqr9iFW3Zw+ZV2VGqL7TB6tmTEXnRD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH 4.19 191/191] staging: octeon: Drop on uncorrectable alignment or FCS error
Date:   Tue,  3 Nov 2020 21:38:03 +0100
Message-Id: <20201103203250.761067158@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 49d28ebdf1e30d806410eefc7de0a7a1ca5d747c upstream.

Currently in case of alignment or FCS error if the packet cannot be
corrected it's still not dropped. Report the error properly and drop the
packet while making the code around a little bit more readable.

Fixes: 80ff0fd3ab64 ("Staging: Add octeon-ethernet driver files.")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201016145630.41852-1-alexander.sverdlin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/octeon/ethernet-rx.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -80,15 +80,17 @@ static inline int cvm_oct_check_rcv_erro
 	else
 		port = work->word1.cn38xx.ipprt;
 
-	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
+	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))
 		/*
 		 * Ignore length errors on min size packets. Some
 		 * equipment incorrectly pads packets to 64+4FCS
 		 * instead of 60+4FCS.  Note these packets still get
 		 * counted as frame errors.
 		 */
-	} else if (work->word2.snoip.err_code == 5 ||
-		   work->word2.snoip.err_code == 7) {
+		return 0;
+
+	if (work->word2.snoip.err_code == 5 ||
+	    work->word2.snoip.err_code == 7) {
 		/*
 		 * We received a packet with either an alignment error
 		 * or a FCS error. This may be signalling that we are
@@ -119,7 +121,10 @@ static inline int cvm_oct_check_rcv_erro
 				/* Port received 0xd5 preamble */
 				work->packet_ptr.s.addr += i + 1;
 				work->word1.len -= i + 5;
-			} else if ((*ptr & 0xf) == 0xd) {
+				return 0;
+			}
+
+			if ((*ptr & 0xf) == 0xd) {
 				/* Port received 0xd preamble */
 				work->packet_ptr.s.addr += i;
 				work->word1.len -= i + 4;
@@ -129,21 +134,20 @@ static inline int cvm_oct_check_rcv_erro
 					    ((*(ptr + 1) & 0xf) << 4);
 					ptr++;
 				}
-			} else {
-				printk_ratelimited("Port %d unknown preamble, packet dropped\n",
-						   port);
-				cvm_oct_free_work(work);
-				return 1;
+				return 0;
 			}
+
+			printk_ratelimited("Port %d unknown preamble, packet dropped\n",
+					   port);
+			cvm_oct_free_work(work);
+			return 1;
 		}
-	} else {
-		printk_ratelimited("Port %d receive error code %d, packet dropped\n",
-				   port, work->word2.snoip.err_code);
-		cvm_oct_free_work(work);
-		return 1;
 	}
 
-	return 0;
+	printk_ratelimited("Port %d receive error code %d, packet dropped\n",
+			   port, work->word2.snoip.err_code);
+	cvm_oct_free_work(work);
+	return 1;
 }
 
 static void copy_segments_to_skb(cvmx_wqe_t *work, struct sk_buff *skb)


