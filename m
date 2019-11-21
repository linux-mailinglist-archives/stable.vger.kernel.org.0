Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849B1104AD7
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 07:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUGxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 01:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUGxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 01:53:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E5E22088F;
        Thu, 21 Nov 2019 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574319231;
        bh=elzipZssOMXAhsOcxFrMqMwESJbT+KvlyapJgNDL5Q4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vf76KJmxlnnQgqA9oUXltMiHeAVmQC9NITMwu2YpLieErxb7gFEJZHTOcyZGHCHWe
         jI+MUIaOh7E1IXQZwe7XLezaBz9INELBkXual6pY5kIl/uytotCYcfDo1FkVraQ6ci
         J53NpdqBTnIsK1sbrtClfkwOS42C5b4OV9XfgdzE=
Date:   Thu, 21 Nov 2019 07:53:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jun Gao <jun.gao@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 127/422] i2c: mediatek: Use DMA safe buffers for i2c
 transactions
Message-ID: <20191121065348.GC340798@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051407.175902069@linuxfoundation.org>
 <20191120014406.nfmrfe5ic5vm6b2l@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120014406.nfmrfe5ic5vm6b2l@toshiba.co.jp>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 10:44:06AM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Tue, Nov 19, 2019 at 06:15:24AM +0100, Greg Kroah-Hartman wrote:
> > From: Jun Gao <jun.gao@mediatek.com>
> > 
> > [ Upstream commit fc66b39fe36acfd06f716e338de7cd8f9550fad2 ]
> > 
> > DMA mode will always be used in i2c transactions, try to allocate
> > a DMA safe buffer if the buf of struct i2c_msg used is not DMA safe.
> > 
> > Signed-off-by: Jun Gao <jun.gao@mediatek.com>
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This patch requires the following additional commit:
> 
> commit bc1a7f75c85e226e82f183d30d75c357f92b6029
> Author: Hsin-Yi Wang <hsinyi@chromium.org>
> Date:   Fri Feb 15 17:02:02 2019 +0800
> 
>     i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()
> 
>     DMA with zero-length transfers doesn't make sense and this HW doesn't
>     support them at all, so increase the threshold.
> 
>     Fixes: fc66b39fe36a ("i2c: mediatek: Use DMA safe buffers for i2c transactions")
>     Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
>     [wsa: reworded commit message]
>     Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> Please apply this commit.
> 
> Best regards,
>   Nobuhiro
> 
> > ---
> >  drivers/i2c/busses/i2c-mt65xx.c | 62 +++++++++++++++++++++++++++++----
> >  1 file changed, 55 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
> > index 1e57f58fcb001..a74ef76705e0c 100644
> > --- a/drivers/i2c/busses/i2c-mt65xx.c
> > +++ b/drivers/i2c/busses/i2c-mt65xx.c
> > @@ -441,6 +441,8 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
> >  	u16 control_reg;
> >  	u16 restart_flag = 0;
> >  	u32 reg_4g_mode;
> > +	u8 *dma_rd_buf = NULL;
> > +	u8 *dma_wr_buf = NULL;
> >  	dma_addr_t rpaddr = 0;
> >  	dma_addr_t wpaddr = 0;
> >  	int ret;
> > @@ -500,10 +502,18 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
> >  	if (i2c->op == I2C_MASTER_RD) {
> >  		writel(I2C_DMA_INT_FLAG_NONE, i2c->pdmabase + OFFSET_INT_FLAG);
> >  		writel(I2C_DMA_CON_RX, i2c->pdmabase + OFFSET_CON);
> > -		rpaddr = dma_map_single(i2c->dev, msgs->buf,
> > +
> > +		dma_rd_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
> > +		if (!dma_rd_buf)
> > +			return -ENOMEM;
> > +
> > +		rpaddr = dma_map_single(i2c->dev, dma_rd_buf,
> >  					msgs->len, DMA_FROM_DEVICE);
> > -		if (dma_mapping_error(i2c->dev, rpaddr))
> > +		if (dma_mapping_error(i2c->dev, rpaddr)) {
> > +			i2c_put_dma_safe_msg_buf(dma_rd_buf, msgs, false);
> > +
> >  			return -ENOMEM;
> > +		}
> >  
> >  		if (i2c->dev_comp->support_33bits) {
> >  			reg_4g_mode = mtk_i2c_set_4g_mode(rpaddr);
> > @@ -515,10 +525,18 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
> >  	} else if (i2c->op == I2C_MASTER_WR) {
> >  		writel(I2C_DMA_INT_FLAG_NONE, i2c->pdmabase + OFFSET_INT_FLAG);
> >  		writel(I2C_DMA_CON_TX, i2c->pdmabase + OFFSET_CON);
> > -		wpaddr = dma_map_single(i2c->dev, msgs->buf,
> > +
> > +		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
> > +		if (!dma_wr_buf)
> > +			return -ENOMEM;
> > +
> > +		wpaddr = dma_map_single(i2c->dev, dma_wr_buf,
> >  					msgs->len, DMA_TO_DEVICE);
> > -		if (dma_mapping_error(i2c->dev, wpaddr))
> > +		if (dma_mapping_error(i2c->dev, wpaddr)) {
> > +			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
> > +
> >  			return -ENOMEM;
> > +		}
> >  
> >  		if (i2c->dev_comp->support_33bits) {
> >  			reg_4g_mode = mtk_i2c_set_4g_mode(wpaddr);
> > @@ -530,16 +548,39 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
> >  	} else {
> >  		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_INT_FLAG);
> >  		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_CON);
> > -		wpaddr = dma_map_single(i2c->dev, msgs->buf,
> > +
> > +		dma_wr_buf = i2c_get_dma_safe_msg_buf(msgs, 0);
> > +		if (!dma_wr_buf)
> > +			return -ENOMEM;
> > +
> > +		wpaddr = dma_map_single(i2c->dev, dma_wr_buf,
> >  					msgs->len, DMA_TO_DEVICE);
> > -		if (dma_mapping_error(i2c->dev, wpaddr))
> > +		if (dma_mapping_error(i2c->dev, wpaddr)) {
> > +			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
> > +
> >  			return -ENOMEM;
> > -		rpaddr = dma_map_single(i2c->dev, (msgs + 1)->buf,
> > +		}
> > +
> > +		dma_rd_buf = i2c_get_dma_safe_msg_buf((msgs + 1), 0);
> > +		if (!dma_rd_buf) {
> > +			dma_unmap_single(i2c->dev, wpaddr,
> > +					 msgs->len, DMA_TO_DEVICE);
> > +
> > +			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
> > +
> > +			return -ENOMEM;
> > +		}
> > +
> > +		rpaddr = dma_map_single(i2c->dev, dma_rd_buf,
> >  					(msgs + 1)->len,
> >  					DMA_FROM_DEVICE);
> >  		if (dma_mapping_error(i2c->dev, rpaddr)) {
> >  			dma_unmap_single(i2c->dev, wpaddr,
> >  					 msgs->len, DMA_TO_DEVICE);
> > +
> > +			i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, false);
> > +			i2c_put_dma_safe_msg_buf(dma_rd_buf, (msgs + 1), false);
> > +
> >  			return -ENOMEM;
> >  		}
> >  
> > @@ -578,14 +619,21 @@ static int mtk_i2c_do_transfer(struct mtk_i2c *i2c, struct i2c_msg *msgs,
> >  	if (i2c->op == I2C_MASTER_WR) {
> >  		dma_unmap_single(i2c->dev, wpaddr,
> >  				 msgs->len, DMA_TO_DEVICE);
> > +
> > +		i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, true);
> >  	} else if (i2c->op == I2C_MASTER_RD) {
> >  		dma_unmap_single(i2c->dev, rpaddr,
> >  				 msgs->len, DMA_FROM_DEVICE);
> > +
> > +		i2c_put_dma_safe_msg_buf(dma_rd_buf, msgs, true);
> >  	} else {
> >  		dma_unmap_single(i2c->dev, wpaddr, msgs->len,
> >  				 DMA_TO_DEVICE);
> >  		dma_unmap_single(i2c->dev, rpaddr, (msgs + 1)->len,
> >  				 DMA_FROM_DEVICE);
> > +
> > +		i2c_put_dma_safe_msg_buf(dma_wr_buf, msgs, true);
> > +		i2c_put_dma_safe_msg_buf(dma_rd_buf, (msgs + 1), true);
> >  	}
> >  
> >  	if (ret == 0) {
> > -- 
> > 2.20.1

Now queued up, thanks.

greg k-h
