Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46B12ABC75
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgKINhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730574AbgKINEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:04:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5834C206C0;
        Mon,  9 Nov 2020 13:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927040;
        bh=MtlvGRWe2qwEI7VVlrOQM0QQgFMweTtcax3lMK04H5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEC+L7FqEDkFYzNP0K2n61QHw1H6iLmQARk4OCPT3tpYIRkT0SCVclJrdd246nYNd
         FqeCkfsDvuwlQXaoKmJTrkKi1wmSroCK7dmIwtIUB/aQU0Pm/rRFXd/rf1ev6GoO6x
         aOS0AMmbOdmWn2wpJbI053LH03a7Z7rBlu/Utby0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH 4.9 091/117] staging: octeon: Drop on uncorrectable alignment or FCS error
Date:   Mon,  9 Nov 2020 13:55:17 +0100
Message-Id: <20201109125030.013078386@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
@@ -83,15 +83,17 @@ static inline int cvm_oct_check_rcv_erro
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
@@ -122,7 +124,10 @@ static inline int cvm_oct_check_rcv_erro
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
@@ -132,21 +137,20 @@ static inline int cvm_oct_check_rcv_erro
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
 
 static int cvm_oct_poll(struct oct_rx_group *rx_group, int budget)


