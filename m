Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D102D0ECC
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 12:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgLGLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 06:16:51 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33599 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgLGLQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 06:16:49 -0500
X-Originating-IP: 109.220.208.103
Received: from localhost.localdomain (lfbn-tou-1-1617-103.w109-220.abo.wanadoo.fr [109.220.208.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 2E65C240009;
        Mon,  7 Dec 2020 11:16:06 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sven Eckelmann <sven@narfation.org>, linux-mtd@lists.infradead.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, vigneshr@ti.com,
        richard@nod.at, rminnich@google.com, stable@vger.kernel.org,
        boris.brezillon@collabora.com
Subject: Re: [PATCH v2] mtd: parser: cmdline: Fix parsing of part-names with colons
Date:   Mon,  7 Dec 2020 12:16:06 +0100
Message-Id: <20201207111606.9077-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201124062506.185392-1-sven@narfation.org>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 639a82434f16a6df0ce0e7c8595976f1293940fd
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-11-24 at 06:25:06 UTC, Sven Eckelmann wrote:
> Some devices (especially QCA ones) are already using hardcoded partition
> names with colons in it. The OpenMesh A62 for example provides following
> mtd relevant information via cmdline:
> 
>   root=31:11 mtdparts=spi0.0:256k(0:SBL1),128k(0:MIBIB),384k(0:QSEE),64k(0:CDT),64k(0:DDRPARAMS),64k(0:APPSBLENV),512k(0:APPSBL),64k(0:ART),64k(custom),64k(0:KEYS),0x002b0000(kernel),0x00c80000(rootfs),15552k(inactive) rootfsname=rootfs rootwait
> 
> The change to split only on the last colon between mtd-id and partitions
> will cause newpart to see following string for the first partition:
> 
>   KEYS),0x002b0000(kernel),0x00c80000(rootfs),15552k(inactive)
> 
> Such a partition list cannot be parsed and thus the device fails to boot.
> 
> Avoid this behavior by making sure that the start of the first part-name
> ("(") will also be the last byte the mtd-id split algorithm is using for
> its colon search.
> 
> Fixes: eb13fa022741 ("mtd: parser: cmdline: Support MTD names containing one or more colons")
> Cc: stable@vger.kernel.org
> Cc: Ron Minnich <rminnich@google.com>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
