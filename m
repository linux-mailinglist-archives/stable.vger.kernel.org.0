Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EF028BA33
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391105AbgJLOGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgJLNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B131121BE5;
        Mon, 12 Oct 2020 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509626;
        bh=H4+IAAdHH8z6G7ZjURbGAk2EVjqEvP1hJA0gKTsMC7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+04lByqPn8yuhJWwCobk+7Azrkw4eU0d0vJLcmj30vRSHJUe7dbkEmSynvbrkcX7
         c661CJKUv2+LOIDqwk6CL2JB4KACUm/Xf3Wi2lqPVbjK3qVacqwiA6UbUWslC3u+BA
         jCPrj7WYG+154fp3/BZuIpNIkcW91poUxWRLxyhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Brooke Basile <brookebasile@gmail.com>,
        stable <stable@kernel.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 4.9 03/54] USB: gadget: f_ncm: Fix NDP16 datagram validation
Date:   Mon, 12 Oct 2020 15:26:25 +0200
Message-Id: <20201012132629.763422990@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 2b405533c2560d7878199c57d95a39151351df72 upstream.

commit 2b74b0a04d3e ("USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()")
adds important bounds checking however it unfortunately also introduces  a
bug with respect to section 3.3.1 of the NCM specification.

wDatagramIndex[1] : "Byte index, in little endian, of the second datagram
described by this NDP16. If zero, then this marks the end of the sequence
of datagrams in this NDP16."

wDatagramLength[1]: "Byte length, in little endian, of the second datagram
described by this NDP16. If zero, then this marks the end of the sequence
of datagrams in this NDP16."

wDatagramIndex[1] and wDatagramLength[1] respectively then may be zero but
that does not mean we should throw away the data referenced by
wDatagramIndex[0] and wDatagramLength[0] as is currently the case.

Breaking the loop on (index2 == 0 || dg_len2 == 0) should come at the end
as was previously the case and checks for index2 and dg_len2 should be
removed since zero is valid.

I'm not sure how much testing the above patch received but for me right now
after enumeration ping doesn't work. Reverting the commit restores ping,
scp, etc.

The extra validation associated with wDatagramIndex[0] and
wDatagramLength[0] appears to be valid so, this change removes the incorrect
restriction on wDatagramIndex[1] and wDatagramLength[1] restoring data
processing between host and device.

Fixes: 2b74b0a04d3e ("USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()")
Cc: Ilja Van Sprundel <ivansprundel@ioactive.com>
Cc: Brooke Basile <brookebasile@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20200920170158.1217068-1-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_ncm.c |   30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1217,7 +1217,6 @@ static int ncm_unwrap_ntb(struct gether
 	const struct ndp_parser_opts *opts = ncm->parser_opts;
 	unsigned	crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
 	int		dgram_counter;
-	bool		ndp_after_header;
 
 	/* dwSignature */
 	if (get_unaligned_le32(tmp) != opts->nth_sign) {
@@ -1244,7 +1243,6 @@ static int ncm_unwrap_ntb(struct gether
 	}
 
 	ndp_index = get_ncm(&tmp, opts->ndp_index);
-	ndp_after_header = false;
 
 	/* Run through all the NDP's in the NTB */
 	do {
@@ -1260,8 +1258,6 @@ static int ncm_unwrap_ntb(struct gether
 			     ndp_index);
 			goto err;
 		}
-		if (ndp_index == opts->nth_size)
-			ndp_after_header = true;
 
 		/*
 		 * walk through NDP
@@ -1340,37 +1336,13 @@ static int ncm_unwrap_ntb(struct gether
 			index2 = get_ncm(&tmp, opts->dgram_item_len);
 			dg_len2 = get_ncm(&tmp, opts->dgram_item_len);
 
-			if (index2 == 0 || dg_len2 == 0)
-				break;
-
 			/* wDatagramIndex[1] */
-			if (ndp_after_header) {
-				if (index2 < opts->nth_size + opts->ndp_size) {
-					INFO(port->func.config->cdev,
-					     "Bad index: %#X\n", index2);
-					goto err;
-				}
-			} else {
-				if (index2 < opts->nth_size + opts->dpe_size) {
-					INFO(port->func.config->cdev,
-					     "Bad index: %#X\n", index2);
-					goto err;
-				}
-			}
 			if (index2 > block_len - opts->dpe_size) {
 				INFO(port->func.config->cdev,
 				     "Bad index: %#X\n", index2);
 				goto err;
 			}
 
-			/* wDatagramLength[1] */
-			if ((dg_len2 < 14 + crc_len) ||
-					(dg_len2 > frame_max)) {
-				INFO(port->func.config->cdev,
-				     "Bad dgram length: %#X\n", dg_len);
-				goto err;
-			}
-
 			/*
 			 * Copy the data into a new skb.
 			 * This ensures the truesize is correct
@@ -1387,6 +1359,8 @@ static int ncm_unwrap_ntb(struct gether
 			ndp_len -= 2 * (opts->dgram_item_len * 2);
 
 			dgram_counter++;
+			if (index2 == 0 || dg_len2 == 0)
+				break;
 		} while (ndp_len > 2 * (opts->dgram_item_len * 2));
 	} while (ndp_index);
 


