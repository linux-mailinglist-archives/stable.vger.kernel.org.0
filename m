Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CC732A61
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfFCIE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:04:58 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:34615 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfFCIE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 04:04:58 -0400
X-Originating-IP: 90.88.144.139
Received: from localhost.localdomain (aaubervilliers-681-1-24-139.w90-88.abo.wanadoo.fr [90.88.144.139])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 37BFCFF80F;
        Mon,  3 Jun 2019 08:04:55 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Xiaolei Li <xiaolei.li@mediatek.com>, miquel.raynal@bootlin.com,
        richard@nod.at
Cc:     linux-mediatek@lists.infradead.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org, srv_heupstream@mediatek.com
Subject: Re: [PATCH v3 1/4] mtd: rawnand: mtk: Correct low level time calculation of r/w cycle
Date:   Mon,  3 Jun 2019 10:04:51 +0200
Message-Id: <20190603080451.28923-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190507102541.34341-2-xiaolei.li@mediatek.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: ba044bc8e03ec5e0dcf0b54c4c0da0b3f085850e
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-05-07 at 10:25:38 UTC, Xiaolei Li wrote:
> At present, the flow of calculating AC timing of read/write cycle in SDR
> mode is that:
> At first, calculate high hold time which is valid for both read and write
> cycle using the max value between tREH_min and tWH_min.
> Secondly, calculate WE# pulse width using tWP_min.
> Thridly, calculate RE# pulse width using the bigger one between tREA_max
> and tRP_min.
> 
> But NAND SPEC shows that Controller should also meet write/read cycle time.
> That is write cycle time should be more than tWC_min and read cycle should
> be more than tRC_min. Obviously, we do not achieve that now.
> 
> This patch corrects the low level time calculation to meet minimum
> read/write cycle time required. After getting the high hold time, WE# low
> level time will be promised to meet tWP_min and tWC_min requirement,
> and RE# low level time will be promised to meet tREA_max, tRP_min and
> tRC_min requirement.
> 
> Fixes: edfee3619c49 ("mtd: nand: mtk: add ->setup_data_interface() hook")
> Cc: stable@vger.kernel.org # v4.17+
> Signed-off-by: Xiaolei Li <xiaolei.li@mediatek.com>
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
