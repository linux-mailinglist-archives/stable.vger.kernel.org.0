Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4EB56C994
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 15:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGINj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 09:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGINj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 09:39:56 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6F3193C7
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 06:39:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j22so1953109ejs.2
        for <stable@vger.kernel.org>; Sat, 09 Jul 2022 06:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=OIKOjffMzDdFr1Pkj2IgKiq+3ZPzAiIvojaYyolCQmc=;
        b=oPAEpYqVgQh6T6SSNOe0P19lbUejVn+nodoxFeeyNwBMBYd+hIGFW+W9WlFBnB/UqQ
         7aC3KK1eDlwHFcBTW84/UM4FcQafxve/x6tGtMoeTbkeNk9NJBQeBMUqJtNKdUeGzHts
         cTUX6C3x8Kwzo6puG/bK26Qi3SeXjvkG2GZ+oYVbN/Mt6xnH+CU1+N+KkXVDMH10kU/1
         D7j0rzNK4AxGwIPI7H8C8NAz65JvW125Rs7o+LwGG4BXEt1ERUqAFShrppysrKblhe7I
         Z4cOhahAa3WNA8RqRAh0P6KxYAAQsLU+8llcN15r3dyAs+jPNIIL0qSwk3HhROv6hWpw
         CWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=OIKOjffMzDdFr1Pkj2IgKiq+3ZPzAiIvojaYyolCQmc=;
        b=G2UOA0FD3YtMa7AhmYQrUdkk7FTHDa9/Qusqo/LqGXaNFtbbD+hII5GUBJtFeA5JGj
         uqoAugawh1DxmdGp8XdGS7tlggkCqCp0qzdmgijyKM3vJXpg4mCLdd/2kepYGOvCn+JR
         5B3nouoYzkid3h9NhiLOKgC467Mg82ulPiXh3RCN2p8ivyFbDi9MgXoiNp23lQHfQXX5
         f9t8FlF4kEQROFQuIJGW0XweScgIl4GG8P3I418/AheAWHU/9wiua13FxxWxauNkQhd9
         G7KTcriAi9qyQZOrY/FWKsUfmmGOgdCPn7Bo2ECdcwr5GwxUzR3FQZ+sFszfXO1ohG+p
         RlRw==
X-Gm-Message-State: AJIora9GUu0HPZHyiU3tIqGbZm1p/JV1duG4gndkkomjN90RW94Gj+KA
        nOmkyBvEsQRPgxh6SOHOQ/+jxnMZc/w=
X-Google-Smtp-Source: AGRyM1tHwBnX8eJNu2/DBByhTQLnPLtqc4YZkZ7l822GC1U3/EaOFUi9O++Dr8L1ZwDTryrn9hp04g==
X-Received: by 2002:a17:907:6e26:b0:726:97af:9846 with SMTP id sd38-20020a1709076e2600b0072697af9846mr9018341ejc.300.1657373993286;
        Sat, 09 Jul 2022 06:39:53 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id g12-20020aa7d1cc000000b00435726bd375sm980394edp.57.2022.07.09.06.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 06:39:52 -0700 (PDT)
Message-ID: <62c98528.1c69fb81.27e32.168c@mx.google.com>
X-Google-Original-Message-ID: <YsmFJ4QxVb673UZ1@Ansuel-xps.>
Date:   Sat, 9 Jul 2022 15:39:51 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org
Subject: Re: [PATCH] net: dsa: qca8k: reset cpu port on MTU change
References: <20220628143010.17526-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628143010.17526-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 04:30:10PM +0200, Christian Marangi wrote:
> commit 386228c694bf1e7a7688e44412cb33500b0ac585 upstream.
> 
> It was discovered that the Documentation lacks of a fundamental detail
> on how to correctly change the MAX_FRAME_SIZE of the switch.
> 
> In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
> switch panics and cease to send any packet. This cause the mgmt ethernet
> system to not receive any packet (the slow fallback still works) and
> makes the device not reachable. To recover from this a switch reset is
> required.
> 
> To correctly handle this, turn off the cpu ports before changing the
> MAX_FRAME_SIZE and turn on again after the value is applied.
> 
> Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Link: https://lore.kernel.org/r/20220621151122.10220-1-ansuelsmth@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ backport: fix conflict using the old port_sts struct instead of bitmap ]

Cc Greg wonder if this has some problems or I pushed it badly? (first
time I try to push a fixed backport)

> ---
>  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a984f06f6f04..67869c8cbeaa 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1599,7 +1599,7 @@ static int
>  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> -	int i, mtu = 0;
> +	int ret, i, mtu = 0;
>  
>  	priv->port_mtu[port] = new_mtu;
>  
> @@ -1607,8 +1607,27 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  		if (priv->port_mtu[i] > mtu)
>  			mtu = priv->port_mtu[i];
>  
> +	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
> +	 * the switch panics.
> +	 * Turn off both cpu ports before applying the new value to prevent
> +	 * this.
> +	 */
> +	if (priv->port_sts[0].enabled)
> +		qca8k_port_set_status(priv, 0, 0);
> +
> +	if (priv->port_sts[6].enabled)
> +		qca8k_port_set_status(priv, 6, 0);
> +
>  	/* Include L2 header / FCS length */
> -	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> +	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> +
> +	if (priv->port_sts[0].enabled)
> +		qca8k_port_set_status(priv, 0, 1);
> +
> +	if (priv->port_sts[6].enabled)
> +		qca8k_port_set_status(priv, 6, 1);
> +
> +	return ret;
>  }
>  
>  static int
> -- 
> 2.36.1
> 

-- 
	Ansuel
