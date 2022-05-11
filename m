Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A21522C53
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 08:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbiEKGbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 02:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiEKGbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 02:31:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F4D3C729;
        Tue, 10 May 2022 23:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652250690; x=1683786690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CGqCtaqi57In086U06rBSjn2KI5H866E/cXUj0HmPpA=;
  b=O8DESnnIwq0ByWhIGL8fssZozxecC/C2cOe+4qzLAb8io96cw8FCZH1R
   L44WzqCZAwtZmhRBYmtNrknCw2BQYoQPGyGtufuj2ac/GtslMxj6mU9ES
   Pdoo8xuqT/rXw3reDK0Ts6+aMzAD0D3FE/m9y5OU9CMic/lmIIZs84NI1
   HWugAoxzW7F8odqnV2ojcXf6gP73ivJ9pEU1kRXQc/ce3aQ5fq2igCcyk
   Ok4KJGxaULgZAY9uCSZ1TnzxPocfuD9RU1kqAdqPKFrxsjKqE/di1qYFp
   p7pZr49xKAxHFft72hCeVvWbYGpmwZahmQaURZWigTMVDAv2tkym5MxWA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="269735718"
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="269735718"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 23:31:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="711356810"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 10 May 2022 23:31:26 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 11 May 2022 09:31:25 +0300
Date:   Wed, 11 May 2022 09:31:25 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     cy_huang <u0084500@gmail.com>
Cc:     linux@roeck-us.net, gregkh@linuxfoundation.org,
        matthias.bgg@gmail.com, cy_huang@richtek.com,
        bryan_huang@richtek.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: typec: tcpci_mt6360: Update for BMC PHY setting
Message-ID: <YntYPbHGkz08k47d@kuha.fi.intel.com>
References: <1652159580-30959-1-git-send-email-u0084500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652159580-30959-1-git-send-email-u0084500@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 01:13:00PM +0800, cy_huang wrote:
> From: ChiYuan Huang <cy_huang@richtek.com>
> 
> Update MT6360 BMC PHY Tx/Rx setting for the compatibility.
> 
> Macpaul reported this CtoDP cable attention message cannot be received from
> MT6360 TCPC. But actually, attention message really sent from UFP_D
> device.
> 
> After RD's comment, there may be BMC PHY Tx/Rx setting causes this issue.
> 
> Below's the detailed TCPM log and DP attention message didn't received from 6360
> TCPCI.
> [ 1206.367775] Identity: 0000:0000.0000
> [ 1206.416570] Alternate mode 0: SVID 0xff01, VDO 1: 0x00000405
> [ 1206.447378] AMS DFP_TO_UFP_ENTER_MODE start
> [ 1206.447383] PD TX, header: 0x1d6f
> [ 1206.449393] PD TX complete, status: 0
> [ 1206.454110] PD RX, header: 0x184f [1]
> [ 1206.456867] Rx VDM cmd 0xff018144 type 1 cmd 4 len 1
> [ 1206.456872] AMS DFP_TO_UFP_ENTER_MODE finished
> [ 1206.456873] cc:=4
> [ 1206.473100] AMS STRUCTURED_VDMS start
> [ 1206.473103] PD TX, header: 0x2f6f
> [ 1206.475397] PD TX complete, status: 0
> [ 1206.480442] PD RX, header: 0x2a4f [1]
> [ 1206.483145] Rx VDM cmd 0xff018150 type 1 cmd 16 len 2
> [ 1206.483150] AMS STRUCTURED_VDMS finished
> [ 1206.483151] cc:=4
> [ 1206.505643] AMS STRUCTURED_VDMS start
> [ 1206.505646] PD TX, header: 0x216f
> [ 1206.507933] PD TX complete, status: 0
> [ 1206.512664] PD RX, header: 0x1c4f [1]
> [ 1206.515456] Rx VDM cmd 0xff018151 type 1 cmd 17 len 1
> [ 1206.515460] AMS STRUCTURED_VDMS finished
> [ 1206.515461] cc:=4
> 
> Fixes: e1aefcdd394fd ("usb typec: mt6360: Add support for mt6360 Type-C driver")
> Reported-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> Cc: stable <stable@vger.kernel.org>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpci_mt6360.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci_mt6360.c b/drivers/usb/typec/tcpm/tcpci_mt6360.c
> index f1bd9e0..8a952ea 100644
> --- a/drivers/usb/typec/tcpm/tcpci_mt6360.c
> +++ b/drivers/usb/typec/tcpm/tcpci_mt6360.c
> @@ -15,6 +15,9 @@
>  
>  #include "tcpci.h"
>  
> +#define MT6360_REG_PHYCTRL1	0x80
> +#define MT6360_REG_PHYCTRL3	0x82
> +#define MT6360_REG_PHYCTRL7	0x86
>  #define MT6360_REG_VCONNCTRL1	0x8C
>  #define MT6360_REG_MODECTRL2	0x8F
>  #define MT6360_REG_SWRESET	0xA0
> @@ -22,6 +25,8 @@
>  #define MT6360_REG_DRPCTRL1	0xA2
>  #define MT6360_REG_DRPCTRL2	0xA3
>  #define MT6360_REG_I2CTORST	0xBF
> +#define MT6360_REG_PHYCTRL11	0xCA
> +#define MT6360_REG_RXCTRL1	0xCE
>  #define MT6360_REG_RXCTRL2	0xCF
>  #define MT6360_REG_CTDCTRL2	0xEC
>  
> @@ -106,6 +111,27 @@ static int mt6360_tcpc_init(struct tcpci *tcpci, struct tcpci_data *tdata)
>  	if (ret)
>  		return ret;
>  
> +	/* BMC PHY */
> +	ret = mt6360_tcpc_write16(regmap, MT6360_REG_PHYCTRL1, 0x3A70);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(regmap, MT6360_REG_PHYCTRL3,  0x82);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(regmap, MT6360_REG_PHYCTRL7, 0x36);
> +	if (ret)
> +		return ret;
> +
> +	ret = mt6360_tcpc_write16(regmap, MT6360_REG_PHYCTRL11, 0x3C60);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(regmap, MT6360_REG_RXCTRL1, 0xE8);
> +	if (ret)
> +		return ret;
> +
>  	/* Set shipping mode off, AUTOIDLE on */
>  	return regmap_write(regmap, MT6360_REG_MODECTRL2, 0x7A);
>  }
> -- 
> 2.7.4

-- 
heikki
