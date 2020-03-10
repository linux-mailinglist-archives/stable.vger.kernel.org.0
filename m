Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7BF18066D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgCJSbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:31:53 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51699 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgCJSbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:31:53 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 74E9820004;
        Tue, 10 Mar 2020 18:31:50 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] mtd: spinand: Stop using spinand->oobbuf for buffering bad block markers
Date:   Tue, 10 Mar 2020 19:31:49 +0100
Message-Id: <20200310183149.18839-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218100432.32433-2-frieder.schrempf@kontron.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 683ca5c1668a74c87902e5715b6f15bb5c9f523c
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-02-18 at 10:05:14 UTC, Schrempf Frieder wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> For reading and writing the bad block markers, spinand->oobbuf is
> currently used as a buffer for the marker bytes. During the
> underlying read and write operations to actually get/set the content
> of the OOB area, the content of spinand->oobbuf is reused and changed
> by accessing it through spinand->oobbuf and/or spinand->databuf.
> 
> This is a flaw in the original design of the SPI NAND core and at the
> latest from 13c15e07eedf ("mtd: spinand: Handle the case where
> PROGRAM LOAD does not reset the cache") on, it results in not having
> the bad block marker written at all, as the spinand->oobbuf is
> cleared to 0xff after setting the marker bytes to zero.
> 
> To fix it, we now just store the two bytes for the marker on the
> stack and let the read/write operations copy it from/to the page
> buffer later.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
