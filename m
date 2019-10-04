Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC98CC007
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390091AbfJDQEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 12:04:49 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:40133 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390043AbfJDQEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 12:04:49 -0400
X-Originating-IP: 93.23.105.117
Received: from xps13.stephanxp.local (117.105.23.93.rev.sfr.net [93.23.105.117])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 164A524000A;
        Fri,  4 Oct 2019 16:04:44 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Piotr Sroka <piotrs@cadence.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-mtd@lists.infradead.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [v2] mtd: rawnand: Change calculating of position page containing BBM
Date:   Fri,  4 Oct 2019 18:04:43 +0200
Message-Id: <20191004160443.6258-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924055439.4212-1-piotrs@cadence.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: a3c4c2339f8948b0f578e938970303a7372e60c0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-09-24 at 05:54:31 UTC, Piotr Sroka wrote:
> Change calculating of position page containing BBM
> 
> If none of BBM flags are set then function nand_bbm_get_next_page 
> reports EINVAL. It causes that BBM is not read at all during scanning
> factory bad blocks. The result is that the BBT table is build without 
> checking factory BBM at all. For Micron flash memories none of these 
> flags are set if page size is different than 2048 bytes.
> 
> Address this regression by:
> - adding NAND_BBM_FIRSTPAGE chip flag without any condition. It solves
>   issue only for Micron devices.
> - changing the nand_bbm_get_next_page_function. It will return 0 
>   if no of BBM flag is set and page parameter is 0. After that modification
>   way of discovering factory bad blocks will work similar as in kernel 
>   version 5.1.
> 
> Cc: stable@vger.kernel.org
> Fixes: f90da7818b14 (mtd: rawnand: Support bad block markers in first, second or last page)
> Signed-off-by: Piotr Sroka <piotrs@cadence.com>
> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
