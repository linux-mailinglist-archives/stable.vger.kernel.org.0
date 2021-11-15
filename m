Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88544451EA9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355211AbhKPAg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345020AbhKOT0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3DC611BF;
        Mon, 15 Nov 2021 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003331;
        bh=2Y/3c1mKFvc/CDhSWBJlEVjLiKAs0ao0JGyOFhRv0jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3pQBujKDagAgn4tiFtyYjaLjxoaDeeYIgtF5XYMuIaQLYhaYdQoFIVA8qwwmw3z6
         ILMcg5MxEmylBBLvEOvl3W8U1Aevn/3ePoc9wcaPkXGq4sRBRdjeENu0mf5yEBRvgr
         2iVmg/1WYytkZ2uafQxAH6VMOSi8Kb/ws/QquGEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 896/917] mtd: rawnand: fsmc: Fix use of SM ORDER
Date:   Mon, 15 Nov 2021 18:06:31 +0100
Message-Id: <20211115165459.433129043@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


