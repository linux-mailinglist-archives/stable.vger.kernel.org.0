Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC05452233
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345855AbhKPBKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245068AbhKOTTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF45E63443;
        Mon, 15 Nov 2021 18:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000874;
        bh=2Y/3c1mKFvc/CDhSWBJlEVjLiKAs0ao0JGyOFhRv0jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2UMlnw4PiTx3AI8xJng/PjLJuqsp9mRlNaNHGooqe9waW8uEt6h9xWaZz3XAUrRp
         mf0GEL17wxUaquIXTQFeYiaBk0DsnmvmmylIgvN2Bwx1dOkiycX85l4CKAr9UyTFIw
         kQC8HN1bpz+wQN32TFPIIiI9w4efpupfVyF3+RJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.14 826/849] mtd: rawnand: fsmc: Fix use of SM ORDER
Date:   Mon, 15 Nov 2021 18:05:09 +0100
Message-Id: <20211115165448.174993606@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 9be1446ece291a1f08164bd056bed3d698681f8b upstream.

The introduction of the generic ECC engine API lead to a number of
changes in various drivers which broke some of them. Here is a typical
example: I expected the SM_ORDER option to be handled by the Hamming ECC
engine internals. Problem: the fsmc driver does not instantiate (yet) a
real ECC engine object so we had to use a 'bare' ECC helper instead of
the shiny rawnand functions. However, when not intializing this engine
properly and using the bare helpers, we do not get the SM ORDER feature
handled automatically. It looks like this was lost in the process so
let's ensure we use the right SM ORDER now.

Fixes: ad9ffdce4539 ("mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210928221507.199198-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -438,8 +438,10 @@ static int fsmc_correct_ecc1(struct nand
 			     unsigned char *read_ecc,
 			     unsigned char *calc_ecc)
 {
+	bool sm_order = chip->ecc.options & NAND_ECC_SOFT_HAMMING_SM_ORDER;
+
 	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
-				      chip->ecc.size, false);
+				      chip->ecc.size, sm_order);
 }
 
 /* Count the number of 0's in buff upto a max of max_bits */


