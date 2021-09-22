Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4742E41516A
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 22:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbhIVUcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 16:32:35 -0400
Received: from mail.third-level.de ([85.115.14.135]:45791 "EHLO
        mail.third-level.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbhIVUcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 16:32:35 -0400
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 16:32:34 EDT
Received: from p508e5677.dip0.t-ipconnect.de ([80.142.86.119] helo=[10.242.10.3])
        by mail.third-level.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <malte@neo-soft.org>)
        id 1mT8bq-0005TJ-K5; Wed, 22 Sep 2021 22:12:50 +0200
Subject: Re: [PATCH 1/2] USB: serial: cp210x: fix dropped characters with
 CP2102
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <YUsTYFOdMH/kQEyE@hovoldconsulting.com>
 <20210922113100.20888-1-johan@kernel.org>
From:   Malte Di Donato <malte@neo-soft.org>
Message-ID: <d291a449-cf66-9c02-5ba2-3aee6f73af21@neo-soft.org>
Date:   Wed, 22 Sep 2021 22:12:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210922113100.20888-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Message-Linecount: 159
X-Body-Linecount: 141
X-Message-Size: 6040
X-Body-Size: 5323
X-SA-Exim-Connect-IP: 80.142.86.119
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org
X-SA-Exim-Mail-From: malte@neo-soft.org
X-SA-Exim-Scanned: No (on mail.third-level.de); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-by: Malte Di Donato <malte@neo-soft.org>

# dmesg (cp2102 connect)

[57018.586990] usb 3-1.2: new full-speed USB device number 17 using ehci-pci
[57018.727102] usb 3-1.2: New USB device found, idVendor=10c4, 
idProduct=ea60, bcdDevice= 1.00
[57018.727109] usb 3-1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[57018.727112] usb 3-1.2: Product: CP2102 USB to UART Bridge Controller
[57018.727115] usb 3-1.2: Manufacturer: Silicon Labs
[57018.727117] usb 3-1.2: SerialNumber: 0001
[57018.735520] cp210x 3-1.2:1.0: cp210x converter detected
[57018.736071] cp210x 3-1.2:1.0: partnum = 0x02
[57018.736529] cp210x 3-1.2:1.0: device does not support event-insertion 
mode
[57018.738780] usb 3-1.2: cp210x converter now attached to ttyUSB0

# sucessfully did a complete mem dump of a device which sends several 
valid 0xEC 0x00
# libdivecomputer/examples/dctool -d "Mares Puck Pro" dump -o 
/tmp/test.bin /dev/ttyUSB0

Opening the I/O stream (serial, /dev/ttyUSB0).
Opening the device (Mares Puck Pro).
Registering the event handler.
Registering the cancellation handler.
Downloading the memory dump.
Event: 
vendor=000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005075636B2050726F000000000000000030342E30302E30300400000031342D30342D31352B8B4443303234000000000000000000000000000000000000000000000000000000
Event: progress 0.00% (0/262144)
Event: progress 0.10% (256/262144)
...
Event: progress 100.00% (262144/262144)



On 22.09.21 13:30, Johan Hovold wrote:
> Some CP2102 do not support event-insertion mode but return no error when
> attempting to enable it.
> 
> This means that any event escape characters in the input stream will not
> be escaped by the device and consequently regular data may be
> interpreted as escape sequences and be removed from the stream by the
> driver.
> 
> The reporter's device has batch number DCL00X etched into it and as
> discovered by the SHA2017 Badge team, counterfeit devices with that
> marking can be detected by sending malformed vendor requests. [1][2]
> 
> Tests confirm that the possibly counterfeit CP2102 returns a single byte
> in response to a malformed two-byte part-number request, while an
> original CP2102 returns two bytes. Assume that every CP2102 that behaves
> this way also does not support event-insertion mode (e.g. cannot report
> parity errors).
> 
> [1] https://mobile.twitter.com/sha2017badge/status/1167902087289532418
> [2] https://hackaday.com/2017/08/14/hands-on-with-the-shacamp-2017-badge/#comment-3903376
> 
> Reported-by: Malte Di Donato <malte@neo-soft.org>
> Fixes: a7207e9835a4 ("USB: serial: cp210x: add support for line-status events")
> Cc: stable@vger.kernel.org	# 5.9
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/usb/serial/cp210x.c | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 66a6ac50a4cd..b98454fe08ea 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -258,6 +258,7 @@ struct cp210x_serial_private {
>   	speed_t			max_speed;
>   	bool			use_actual_rate;
>   	bool			no_flow_control;
> +	bool			no_event_mode;
>   };
>   
>   enum cp210x_event_state {
> @@ -1113,12 +1114,16 @@ static void cp210x_change_speed(struct tty_struct *tty,
>   
>   static void cp210x_enable_event_mode(struct usb_serial_port *port)
>   {
> +	struct cp210x_serial_private *priv = usb_get_serial_data(port->serial);
>   	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
>   	int ret;
>   
>   	if (port_priv->event_mode)
>   		return;
>   
> +	if (priv->no_event_mode)
> +		return;
> +
>   	port_priv->event_state = ES_DATA;
>   	port_priv->event_mode = true;
>   
> @@ -2074,6 +2079,33 @@ static void cp210x_init_max_speed(struct usb_serial *serial)
>   	priv->use_actual_rate = use_actual_rate;
>   }
>   
> +static void cp2102_determine_quirks(struct usb_serial *serial)
> +{
> +	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
> +	u8 *buf;
> +	int ret;
> +
> +	buf = kmalloc(2, GFP_KERNEL);
> +	if (!buf)
> +		return;
> +	/*
> +	 * Some (possibly counterfeit) CP2102 do not support event-insertion
> +	 * mode and respond differently to malformed vendor requests.
> +	 * Specifically, they return one instead of two bytes when sent a
> +	 * two-byte part-number request.
> +	 */
> +	ret = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
> +			CP210X_VENDOR_SPECIFIC, REQTYPE_DEVICE_TO_HOST,
> +			CP210X_GET_PARTNUM, 0, buf, 2, USB_CTRL_GET_TIMEOUT);
> +	if (ret == 1) {
> +		dev_dbg(&serial->interface->dev,
> +				"device does not support event-insertion mode\n");
> +		priv->no_event_mode = true;
> +	}
> +
> +	kfree(buf);
> +}
> +
>   static int cp210x_get_fw_version(struct usb_serial *serial, u16 value)
>   {
>   	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
> @@ -2109,6 +2141,9 @@ static void cp210x_determine_type(struct usb_serial *serial)
>   	}
>   
>   	switch (priv->partnum) {
> +	case CP210X_PARTNUM_CP2102:
> +		cp2102_determine_quirks(serial);
> +		break;
>   	case CP210X_PARTNUM_CP2105:
>   	case CP210X_PARTNUM_CP2108:
>   		cp210x_get_fw_version(serial, CP210X_GET_FW_VER);
> 
