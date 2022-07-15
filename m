Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A6D57690F
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 23:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiGOVkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 17:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiGOVkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 17:40:09 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 14:40:06 PDT
Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F1587C1C
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 14:40:06 -0700 (PDT)
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr4.vodafonemail.de (Postfix) with ESMTPS id 4Ll3gR4Wv7z1y3d;
        Fri, 15 Jul 2022 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-mb-mr2-21dec; t=1657918883;
        bh=g0bZNQ/qAGzQLRkN3t2THCJbsEj5rzgZ60pOMTH7Mao=;
        h=Date:From:To:Subject:Message-ID:References:Content-Type:
         In-Reply-To:From;
        b=RhBsweNS+Px1w+brCGcYvdNy6c+SqURr/fXm/i3BR68wsmOck6Gf+6VMpK92azfa9
         v+N0hBwQgTqULfBxo46CvwWsfg+SRP8g+sFfXzuVLPJKwqg3kByK1nNiMZLw1PoScu
         zv2ltNpU6PnZjxKqUI1OXWr+Pva46z28G888dTQU=
Received: from arcor.de (p3ee2ce05.dip0.t-ipconnect.de [62.226.206.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4Ll3g24xSkzHnHl;
        Fri, 15 Jul 2022 21:00:59 +0000 (UTC)
Date:   Fri, 15 Jul 2022 23:00:45 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     Frans Klaver <fransklaver@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frans Klaver <frans.klaver@vislink.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: serial: qcserial: add EM9191 support
Message-ID: <YtHVfc40VGbB2Tkz@arcor.de>
References: <20220715095623.28002-1-frans.klaver@vislink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715095623.28002-1-frans.klaver@vislink.com>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 2507
X-purgate-ID: 155817::1657918881-11F7A23F-EC5999A9/0/0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 11:56:23AM +0200, Frans Klaver wrote:
> From: Frans Klaver <frans.klaver@vislink.com>
> 
> Support for QDL mode is already present for EM9191 modules, but the
> non-QDL mode appears to be missing. Add it now.
> 
> T:  Bus=03 Lev=03 Prnt=04 Port=01 Cnt=02 Dev#= 17 Spd=480 MxCh= 0
> D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1199 ProdID=90d3 Rev=00.06
> S:  Manufacturer=Sierra Wireless, Incorporated
> S:  Product=Sierra Wireless EM9191
> S:  SerialNumber=8W0463003002A114
> C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
> I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=qcserial
> I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=qcserial
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Frans Klaver <frans.klaver@vislink.com>
> ---
> I noticed an e-mail address discrepancy that git-send-email didn't
> magically fix for me. No change otherwise.
> 
>  drivers/usb/serial/qcserial.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
> index 586ef5551e76e..73f6d3a37c0c4 100644
> --- a/drivers/usb/serial/qcserial.c
> +++ b/drivers/usb/serial/qcserial.c
> @@ -166,6 +166,7 @@ static const struct usb_device_id id_table[] = {
>  	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
>  	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
>  	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
> +	{DEVICE_SWI(0x1199, 0x90d3)},	/* Sierra Wireless EM9191 */
>  	{DEVICE_SWI(0x1199, 0xc080)},	/* Sierra Wireless EM7590 QDL */
>  	{DEVICE_SWI(0x1199, 0xc081)},	/* Sierra Wireless EM7590 */
>  	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */

Hi Frans,

the qcserial driver used in the usb-devices output above does not seem
to be built from the mainline qcserial.c with your patch applied as USB
interface 4 is ignored by the QCSERIAL_SWI layout.

To avoid potential side effects in case Sierra Wireless adds a vendor class
USB interface 2 not intended to be used with qcserial.c it might be best
to use a new QCSERIAL_SWI2 layout similar to what has been done in
their MBPL drivers mentioned here
https://forum.sierrawireless.com/t/rc7620-and-linux-driver/24308/ .

Regards,
Reinhard
