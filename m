Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E786C0480
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 20:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCSTnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 15:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCSTni (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 15:43:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E7F7680;
        Sun, 19 Mar 2023 12:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CDFAB80C76;
        Sun, 19 Mar 2023 19:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E8C433D2;
        Sun, 19 Mar 2023 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679255015;
        bh=1tNsPUKjV4L9V7XPW9kH4A1wKAAnBx/Wn48UIxSXwlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KCtAzZHPxBbF0vlCaKx83qR46i94OYpK6AkiDVN6C4isM9A9qhcYgd4uAaOXnoxJB
         b4AqrD0xpEcmyMSZ94ukO1A9qruGv2YEb8zNwsS9EQ+L8i0zzlOh05IJ9Bhfq+3AcR
         0go63T9J+gdXUu/XBFKWui554OjVBsOvC8YRLwppDnN9dbfYiPzHPGKQF8EUnZebYE
         K4+d2w0nI11/nAFf22tuW9TPstlA38dUkBkEa0+sHEUb8+/syLSDHt7/Z+qaMj6Z/R
         kM2GtlcVztAWAaKbNWVMM0hA2kNKb0QU2psfI8r7qVMf0gWcx9iDgAfOcY48xabA6p
         s8ZPPpY/i569g==
Received: by pali.im (Postfix)
        id 2A751622; Sun, 19 Mar 2023 20:43:32 +0100 (CET)
Date:   Sun, 19 Mar 2023 20:43:32 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     msizanoen <msizanoen@qtmlabs.xyz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: alps: fix compatibility with -funsigned-char
Message-ID: <20230319194332.r63zn7cm3bteajmk@pali>
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
 <ZBdKJJ+HJaB0mdNR@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBdKJJ+HJaB0mdNR@zx2c4.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 19 March 2023 18:45:08 Jason A. Donenfeld wrote:
> Might be wise to clean up a few other ones in that file? Or not. Up to
> you:
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 989228b5a0a4..afbf67c2488a 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -852,8 +852,8 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
>  			x = y = z = 0;
> 
>  		/* Divide 4 since trackpoint's speed is too fast */
> -		input_report_rel(dev2, REL_X, (char)x / 4);
> -		input_report_rel(dev2, REL_Y, -((char)y / 4));
> +		input_report_rel(dev2, REL_X, (signed char)x / 4);
> +		input_report_rel(dev2, REL_Y, -((signed char)y / 4));

Anyway, is casting here needed at all? Is not just plain -(y / 4) enough?

> 
>  		psmouse_report_standard_buttons(dev2, packet[3]);
> 
> @@ -1104,8 +1104,8 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
>  	    ((packet[3] & 0x20) << 1);
>  	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);
> 
> -	input_report_rel(dev2, REL_X, (char)x);
> -	input_report_rel(dev2, REL_Y, -((char)y));
> +	input_report_rel(dev2, REL_X, (signed char)x);
> +	input_report_rel(dev2, REL_Y, -((signed char)y));
>  	input_report_abs(dev2, ABS_PRESSURE, z);
> 
>  	psmouse_report_standard_buttons(dev2, packet[1]);
> diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
> index 5f0d75a45c80..43a1116c5852 100644
> --- a/drivers/input/mouse/elan_i2c_core.c
> +++ b/drivers/input/mouse/elan_i2c_core.c
> @@ -382,7 +382,7 @@ static unsigned int elan_convert_resolution(u8 val, u8 pattern)
>  	 *	((value from firmware) + 3) * 100 = dpi
>  	 */
>  	int res = pattern <= 0x01 ?
> -		(int)(char)val * 10 + 790 : ((int)(char)val + 3) * 100;
> +		(int)(signed char)val * 10 + 790 : ((int)(signed char)val + 3) * 100;
>  	/*
>  	 * We also have to convert dpi to dots/mm (*10/254 to avoid floating
>  	 * point).

Please move elantech change into separate commit/patch. As it has
nothing with alps driver. It is completely different hardware.
