Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1629D353
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgJ1VlQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 28 Oct 2020 17:41:16 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:46390 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbgJ1VlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:41:03 -0400
Received: from relay8-d.mail.gandi.net (unknown [217.70.183.201])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 9964B3A5CD2;
        Wed, 28 Oct 2020 14:23:27 +0000 (UTC)
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id C3CD91BF20B;
        Wed, 28 Oct 2020 14:23:04 +0000 (UTC)
Date:   Wed, 28 Oct 2020 15:23:02 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Praveenkumar I <ipkumar@codeaurora.org>
Cc:     richard@nod.at, vigneshr@ti.com, sivaprak@codeaurora.org,
        peter.ujfalusi@ti.com, boris.brezillon@collabora.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kathirav@codeaurora.org
Subject: Re: [PATCH] mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS
 register read
Message-ID: <20201028152302.2f830077@xps13>
In-Reply-To: <24a781a3-488c-b638-1b92-0f279807446f@codeaurora.org>
References: <1602230872-25616-1-git-send-email-ipkumar@codeaurora.org>
        <20201028110835.2f319c0a@xps13>
        <24a781a3-488c-b638-1b92-0f279807446f@codeaurora.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Praveenkumar I <ipkumar@codeaurora.org> wrote on Wed, 28 Oct 2020
19:48:34 +0530:

> Hi Miquel,
> 
> Please find the inline reply.
> 
> Thanks,
> Praveenkumar I
> 
> 
> On 10/28/2020 3:38 PM, Miquel Raynal wrote:
> > Hello,
> >
> > Praveenkumar I <ipkumar@codeaurora.org> wrote on Fri,  9 Oct 2020
> > 13:37:52 +0530:
> >  
> >> After each codeword NAND_FLASH_STATUS is read for possible operational
> >> failures. But there is no DMA sync for CPU operation before reading it
> >> and this leads to incorrect or older copy of DMA buffer in reg_read_buf.
> >>
> >> This patch adds the DMA sync on reg_read_buf for CPU before reading it.
> >>
> >> Fixes: 5bc36b2bf6e2 ("mtd: rawnand: qcom: check for operation errors in case of raw read")  
> > I guess this deserves a proper Cc: stable tag?  
> >    >> Yes. I will send a V2 Patch with stable tag in Cc  

That's fine for this one, I'll add it myself.

> >> Signed-off-by: Praveenkumar I <ipkumar@codeaurora.org>  
> > I think your full name is required in the SoB line (should match the
> > authorship).  
> >     >> "Praveenkumar I" is my full name and it is same as the authorship.  

Ok, sorry for the confusion.

> > Otherwise looks good to me.
> >  
> >> ---
> >>   drivers/mtd/nand/raw/qcom_nandc.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
> >> index bd7a7251429b..5bb85f1ba84c 100644
> >> --- a/drivers/mtd/nand/raw/qcom_nandc.c
> >> +++ b/drivers/mtd/nand/raw/qcom_nandc.c
> >> @@ -1570,6 +1570,8 @@ static int check_flash_errors(struct qcom_nand_host *host, int cw_cnt)
> >>   	struct qcom_nand_controller *nandc = get_qcom_nand_controller(chip);
> >>   	int i;  
> >>   >> +	nandc_read_buffer_sync(nandc, true);  
> >> +
> >>   	for (i = 0; i < cw_cnt; i++) {
> >>   		u32 flash = le32_to_cpu(nandc->reg_read_buf[i]);  
> >>   > Thanks,  
> > Miquèl  
> 

Cheers,
Miquèl
