Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CDC41C10
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 08:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbfFLGPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 02:15:38 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43790 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfFLGPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 02:15:38 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 27A76263ACA;
        Wed, 12 Jun 2019 07:15:36 +0100 (BST)
Date:   Wed, 12 Jun 2019 08:15:33 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Vitor Soares <Vitor.Soares@synopsys.com>
Cc:     linux-i3c@lists.infradead.org, Joao.Pinto@synopsys.com,
        Boris Brezillon <bbrezillon@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] i3c: fix i2c and i3c scl rate by bus mode
Message-ID: <20190612081533.2cf9e12a@collabora.com>
In-Reply-To: <b39923bda3625a5c6874755ae81cdfe85fb5abef.1560261604.git.vitor.soares@synopsys.com>
References: <cover.1560261604.git.vitor.soares@synopsys.com>
        <b39923bda3625a5c6874755ae81cdfe85fb5abef.1560261604.git.vitor.soares@synopsys.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Jun 2019 16:06:43 +0200
Vitor Soares <Vitor.Soares@synopsys.com> wrote:

> Currently the I3C framework limits SCL frequency to FM speed when
> dealing with a mixed slow bus, even if all I2C devices are FM+ capable.
> 
> The core was also not accounting for I3C speed limitations when
> operating in mixed slow mode and was erroneously using FM+ speed as the
> max I2C speed when operating in mixed fast mode.
> 
> Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> Cc: Boris Brezillon <bbrezillon@kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> ---
> Changes in v3:
>   Change dev_warn() to dev_dbg()
> 
> Changes in v2:
>   Enhance commit message
>   Add dev_warn() in case user-defined i2c rate doesn't match LVR constraint
>   Add dev_warn() in case user-defined i3c rate lower than i2c rate
> 
>  drivers/i3c/master.c | 61 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 48 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
> index 5f4bd52..f8e580e 100644
> --- a/drivers/i3c/master.c
> +++ b/drivers/i3c/master.c
> @@ -91,6 +91,12 @@ void i3c_bus_normaluse_unlock(struct i3c_bus *bus)
>  	up_read(&bus->lock);
>  }
>  
> +static struct i3c_master_controller *
> +i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
> +{
> +	return container_of(i3cbus, struct i3c_master_controller, bus);
> +}
> +
>  static struct i3c_master_controller *dev_to_i3cmaster(struct device *dev)
>  {
>  	return container_of(dev, struct i3c_master_controller, dev);
> @@ -565,20 +571,48 @@ static const struct device_type i3c_masterdev_type = {
>  	.groups	= i3c_masterdev_groups,
>  };
>  
> -int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode)
> +int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode,
> +		     unsigned long max_i2c_scl_rate)
>  {
> -	i3cbus->mode = mode;
>  
> -	if (!i3cbus->scl_rate.i3c)
> -		i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
> +	struct i3c_master_controller *master = i3c_bus_to_i3c_master(i3cbus);
>  
> -	if (!i3cbus->scl_rate.i2c) {
> -		if (i3cbus->mode == I3C_BUS_MODE_MIXED_SLOW)
> -			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
> -		else
> -			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
> +	i3cbus->mode = mode;
> +
> +	switch (i3cbus->mode) {
> +	case I3C_BUS_MODE_PURE:
> +		if (!i3cbus->scl_rate.i3c)
> +			i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
> +		break;
> +	case I3C_BUS_MODE_MIXED_FAST:
> +		if (!i3cbus->scl_rate.i3c)
> +			i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
> +		if (!i3cbus->scl_rate.i2c)
> +			i3cbus->scl_rate.i2c = max_i2c_scl_rate;
> +		break;
> +	case I3C_BUS_MODE_MIXED_SLOW:
> +		if (!i3cbus->scl_rate.i2c)
> +			i3cbus->scl_rate.i2c = max_i2c_scl_rate;
> +		if (!i3cbus->scl_rate.i3c ||
> +		    i3cbus->scl_rate.i3c > i3cbus->scl_rate.i2c)
> +			i3cbus->scl_rate.i3c = i3cbus->scl_rate.i2c;
> +		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
> +	if (i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c)
> +		dev_dbg(&master->dev,
> +			"i3c-scl-hz=%ld lower than i2c-scl-hz=%ld\n",
> +			i3cbus->scl_rate.i3c, i3cbus->scl_rate.i2c);
> +
> +	if (i3cbus->scl_rate.i2c != I3C_BUS_I2C_FM_SCL_RATE &&
> +	    i3cbus->scl_rate.i2c != I3C_BUS_I2C_FM_PLUS_SCL_RATE &&
> +	    i3cbus->mode != I3C_BUS_MODE_PURE)
> +		dev_dbg(&master->dev,
> +			"i2c-scl-hz=%ld not defined according MIPI I3C spec\n",
> +			i3cbus->scl_rate.i2c);
> +

Again, that's not what I suggested, so I'll write it down:

	dev_dbg(&master->dev, "i2c-scl = %ld Hz i3c-scl = %ld Hz\n",
		i3cbus->scl_rate.i2c, i3cbus->scl_rate.i3c);

dev_dbg() is not printed by default, so it's just fine to have a trace
that prints the I3C and I2C rate unconditionally.

>  	/*
>  	 * I3C/I2C frequency may have been overridden, check that user-provided
>  	 * values are not exceeding max possible frequency.
> @@ -1966,9 +2000,6 @@ of_i3c_master_add_i2c_boardinfo(struct i3c_master_controller *master,
>  	/* LVR is encoded in reg[2]. */
>  	boardinfo->lvr = reg[2];
>  
> -	if (boardinfo->lvr & I3C_LVR_I2C_FM_MODE)
> -		master->bus.scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
> -
>  	list_add_tail(&boardinfo->node, &master->boardinfo.i2c);
>  	of_node_get(node);
>  
> @@ -2417,6 +2448,7 @@ int i3c_master_register(struct i3c_master_controller *master,
>  			const struct i3c_master_controller_ops *ops,
>  			bool secondary)
>  {
> +	unsigned long i2c_scl_rate = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
>  	struct i3c_bus *i3cbus = i3c_master_get_bus(master);
>  	enum i3c_bus_mode mode = I3C_BUS_MODE_PURE;
>  	struct i2c_dev_boardinfo *i2cbi;
> @@ -2466,9 +2498,12 @@ int i3c_master_register(struct i3c_master_controller *master,
>  			ret = -EINVAL;
>  			goto err_put_dev;
>  		}
> +
> +		if (i2cbi->lvr & I3C_LVR_I2C_FM_MODE)
> +			i2c_scl_rate = I3C_BUS_I2C_FM_SCL_RATE;
>  	}
>  
> -	ret = i3c_bus_set_mode(i3cbus, mode);
> +	ret = i3c_bus_set_mode(i3cbus, mode, i2c_scl_rate);
>  	if (ret)
>  		goto err_put_dev;
>  

