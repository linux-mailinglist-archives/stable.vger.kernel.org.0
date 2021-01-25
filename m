Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EEB30336B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbhAZEx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:53:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbhAYSrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E08A22DFB;
        Mon, 25 Jan 2021 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600450;
        bh=cxVGER9+vW4C6pKh88X2v5HD8gCEyH7ObcDSPrEXJx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuIkkvVmFeREJAt+Y5fmODkeZGQLEhkJ69nqs1NPvV29rtaQNkR7W9Zlyr/MoPhd9
         fbYZXx8EwX+9/XSYJw52uSvCKJr+3LLKx+7sgCAg2CkPTIkckvJFEUSaL3A3Yr5mpW
         fwoqf9FHpmvte0i+o84wfO3cIBfiK0MRW6uTcTDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 002/199] mtd: rawnand: gpmi: fix dst bit offset when extracting raw payload
Date:   Mon, 25 Jan 2021 19:37:04 +0100
Message-Id: <20210125183216.354355440@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit 4883a60c17eda6bf52d1c817ee7ead65b4a02da2 upstream.

Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
when extracting the data payload in gpmi_ecc_read_page_raw().

Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
Cc: stable@vger.kernel.org
Reported-by: Martin Hundebøll <martin@geanix.com>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201221100013.2715675-1-sean@geanix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -1613,7 +1613,7 @@ static int gpmi_ecc_read_page_raw(struct
 	/* Extract interleaved payload data and ECC bits */
 	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
 		if (buf)
-			nand_extract_bits(buf, step * eccsize, tmp_buf,
+			nand_extract_bits(buf, step * eccsize * 8, tmp_buf,
 					  src_bit_off, eccsize * 8);
 		src_bit_off += eccsize * 8;
 


