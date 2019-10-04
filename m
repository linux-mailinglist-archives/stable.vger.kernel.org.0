Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FCBCC2D5
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfJDSmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 14:42:13 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59774 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfJDSmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 14:42:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbrezillon)
        with ESMTPSA id 36FCA28A473
Date:   Fri, 4 Oct 2019 14:42:05 -0400
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Paul Burton <paul.burton@mips.com>
Cc:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: rawnand: au1550nd: Fix au_read_buf16() prototype
Message-ID: <20191004144205.24d38ab3@dhcp-172-31-174-146.wireless.concordia.ca>
In-Reply-To: <20191004183706.850363-1-paul.burton@mips.com>
References: <20191004183706.850363-1-paul.burton@mips.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Oct 2019 18:38:33 +0000
Paul Burton <paul.burton@mips.com> wrote:

> Commit 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to
> chip->read_xxx() hooks") modified the prototype of the struct nand_chip
> read_buf function pointer. In the au1550nd driver we have 2
> implementations of read_buf. The previously mentioned commit modified
> the au_read_buf() implementation to match the function pointer, but not
> au_read_buf16(). This results in a compiler warning for MIPS
> db1xxx_defconfig builds:
> 
>   drivers/mtd/nand/raw/au1550nd.c:443:57:
>     warning: pointer type mismatch in conditional expression
> 
> Fix this by updating the prototype of au_read_buf16() to take a struct
> nand_chip pointer as its first argument, as is expected after commit
> 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_xxx()
> hooks").
> 
> Note that this shouldn't have caused any functional issues at runtime,
> since the offset of the struct mtd_info within struct nand_chip is 0
> making mtd_to_nand() effectively a type-cast.
> 
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Fixes: 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_xxx() hooks")
> Cc: Boris Brezillon <bbrezillon@kernel.org>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Vignesh Raghavendra <vigneshr@ti.com>
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-mips@vger.kernel.org
> Cc: stable@vger.kernel.org # v4.20+
> 
> ---
> 
>  drivers/mtd/nand/raw/au1550nd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/au1550nd.c b/drivers/mtd/nand/raw/au1550nd.c
> index 97a97a9ccc36..2bc818dea2a8 100644
> --- a/drivers/mtd/nand/raw/au1550nd.c
> +++ b/drivers/mtd/nand/raw/au1550nd.c
> @@ -140,10 +140,9 @@ static void au_write_buf16(struct nand_chip *this, const u_char *buf, int len)
>   *
>   * read function for 16bit buswidth
>   */
> -static void au_read_buf16(struct mtd_info *mtd, u_char *buf, int len)
> +static void au_read_buf16(struct nand_chip *this, u_char *buf, int len)
>  {
>  	int i;
> -	struct nand_chip *this = mtd_to_nand(mtd);
>  	u16 *p = (u16 *) buf;
>  	len >>= 1;
>  

