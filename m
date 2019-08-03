Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8FE80365
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 02:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfHCAOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 20:14:33 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:48003 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfHCAOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 20:14:33 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 1F1021BF204;
        Sat,  3 Aug 2019 00:14:30 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marco Felsch <m.felsch@pengutronix.de>,
        richard.weinberger@gmail.com, boris.brezillon@collabora.com,
        miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mtd: rawnand: micron: handle on-die "ECC-off" devices correctly
Date:   Sat,  3 Aug 2019 02:14:24 +0200
Message-Id: <20190803001424.5733-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190730134407.30212-1-m.felsch@pengutronix.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 8493b2a06fc5b77ef5c579dc32b12761f7b7a84c
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-07-30 at 13:44:07 UTC, Marco Felsch wrote:
> Some devices are not supposed to support on-die ECC but experience
> shows that internal ECC machinery can actually be enabled through the
> "SET FEATURE (EFh)" command, even if a read of the "READ ID Parameter
> Tables" returns that it is not.
> 
> Currently, the driver checks the "READ ID Parameter" field directly
> after having enabled the feature. If the check fails it returns
> immediately but leaves the ECC on. When using buggy chips like
> MT29F2G08ABAGA and MT29F2G08ABBGA, all future read/program cycles will
> go through the on-die ECC, confusing the host controller which is
> supposed to be the one handling correction.
> 
> To address this in a common way we need to turn off the on-die ECC
> directly after reading the "READ ID Parameter" and before checking the
> "ECC status".
> 
> Cc: stable@vger.kernel.org
> Fixes: dbc44edbf833 ("mtd: rawnand: micron: Fix on-die ECC detection logic")
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
