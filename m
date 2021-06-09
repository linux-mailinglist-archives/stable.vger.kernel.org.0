Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946983A1B89
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 19:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhFIRLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 13:11:04 -0400
Received: from mail.palosanto.com ([181.39.87.190]:41070 "EHLO palosanto.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230186AbhFIRLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 13:11:03 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2021 13:11:03 EDT
Received: from localhost (mail.palosanto.com [127.0.0.1])
        by palosanto.com (Postfix) with ESMTP id 2F0B813C23D4;
        Wed,  9 Jun 2021 12:00:42 -0500 (-05)
X-Virus-Scanned: Debian amavisd-new at mail.palosanto.com
Received: from palosanto.com ([127.0.0.1])
        by localhost (mail.palosanto.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P82wuc-d5J79; Wed,  9 Jun 2021 12:00:40 -0500 (-05)
Received: from [192.168.0.2] (unknown [191.99.2.15])
        by palosanto.com (Postfix) with ESMTPSA id 6D7C313C23BB;
        Wed,  9 Jun 2021 12:00:34 -0500 (-05)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=palosanto.com;
        s=mail; t=1623258040;
        bh=lNsMeD1jjNi33H+9FiXJkLfMts7k5a9AlZ2Ik0Era4s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FzVDIRVICklLNEs+7PPZXERSKgQvhmdJDLph9h+p1E1j1V16cQkE9yYB17QWGfB3s
         jlMQ0wDtIeO7MWmla44Go0/eMXg0dAdFIjFWT/AESb700iYVKa8G3p4KfxXxJq8uk+
         2eO0PJg8G5my0TDwr6ZF46ltp7ukhgyG6R7RiDCk=
Subject: Re: [PATCH] USB: serial: cp210x: fix CP2102N-A01 modem control
To:     Johan Hovold <johan@kernel.org>, David Frey <dpfrey@gmail.com>
Cc:     linux-usb@vger.kernel.org, Pho Tran <pho.tran@silabs.com>,
        Tung Pham <tung.pham@silabs.com>, Hung.Nguyen@silabs.com,
        stable@vger.kernel.org
References: <YL87Na0MycRA6/fW@hovoldconsulting.com>
 <20210609161509.9459-1-johan@kernel.org>
From:   =?UTF-8?Q?Alex_Villac=c3=ads_Lasso?= <a_villacis@palosanto.com>
Message-ID: <22113673-a359-f783-166f-acbe5dbc9298@palosanto.com>
Date:   Wed, 9 Jun 2021 12:00:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609161509.9459-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

El 9/6/21 a las 11:15, Johan Hovold escribió:
> CP2102N revision A01 (firmware version <= 1.0.4) has a buggy
> flow-control implementation that uses the ulXonLimit instead of
> ulFlowReplace field of the flow-control settings structure (erratum
> CP2102N_E104).
>
> A recent change that set the input software flow-control limits
> incidentally broke RTS control for these devices when CRTSCTS is not set
> as the new limits would always enable hardware flow control.
>
> Fix this by explicitly disabling flow control for the buggy firmware
> versions and only updating the input software flow-control limits when
> IXOFF is requested. This makes sure that the terminal settings matches
> the default zero ulXonLimit (ulFlowReplace) for these devices.
>
> Reported-by: David Frey <dpfrey@gmail.com>
> Reported-by: Alex Villacís Lasso <a_villacis@palosanto.com>
> Fixes: f61309d9c96a ("USB: serial: cp210x: set IXOFF thresholds")
> Cc: stable@vger.kernel.org      # 5.12
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/usb/serial/cp210x.c | 64 ++++++++++++++++++++++++++++++++++---
>   1 file changed, 59 insertions(+), 5 deletions(-)
>
> David and Alex,
>
> Would you mind testing this one with your CP2108N-A01? I've verified it
> against a CP2108N-A02 (fw 1.0.8) here.
>
> Johan
>
>
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index ee595d1bea0a..910bc965e6cd 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -252,9 +252,11 @@ struct cp210x_serial_private {
>   	u8			gpio_input;
>   #endif
>   	u8			partnum;
> +	u32			fw_version;
>   	speed_t			min_speed;
>   	speed_t			max_speed;
>   	bool			use_actual_rate;
> +	bool			no_flow_control;
>   };
>   
>   enum cp210x_event_state {
> @@ -398,6 +400,7 @@ struct cp210x_special_chars {
>   
>   /* CP210X_VENDOR_SPECIFIC values */
>   #define CP210X_READ_2NCONFIG	0x000E
> +#define CP210X_GET_FW_VER_2N	0x0010
>   #define CP210X_READ_LATCH	0x00C2
>   #define CP210X_GET_PARTNUM	0x370B
>   #define CP210X_GET_PORTCONFIG	0x370C
> @@ -1122,6 +1125,7 @@ static bool cp210x_termios_change(const struct ktermios *a, const struct ktermio
>   static void cp210x_set_flow_control(struct tty_struct *tty,
>   		struct usb_serial_port *port, struct ktermios *old_termios)
>   {
> +	struct cp210x_serial_private *priv = usb_get_serial_data(port->serial);
>   	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
>   	struct cp210x_special_chars chars;
>   	struct cp210x_flow_ctl flow_ctl;
> @@ -1129,6 +1133,15 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
>   	u32 ctl_hs;
>   	int ret;
>   
> +	/*
> +	 * Some CP2102N interpret ulXonLimit as ulFlowReplace (erratum
> +	 * CP2102N_E104). Report back that flow control is not supported.
> +	 */
> +	if (priv->no_flow_control) {
> +		tty->termios.c_cflag &= ~CRTSCTS;
> +		tty->termios.c_iflag &= ~(IXON | IXOFF);
> +	}
> +
>   	if (old_termios &&
>   			C_CRTSCTS(tty) == (old_termios->c_cflag & CRTSCTS) &&
>   			I_IXON(tty) == (old_termios->c_iflag & IXON) &&
> @@ -1185,19 +1198,20 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
>   		port_priv->crtscts = false;
>   	}
>   
> -	if (I_IXOFF(tty))
> +	if (I_IXOFF(tty)) {
>   		flow_repl |= CP210X_SERIAL_AUTO_RECEIVE;
> -	else
> +
> +		flow_ctl.ulXonLimit = cpu_to_le32(128);
> +		flow_ctl.ulXoffLimit = cpu_to_le32(128);
> +	} else {
>   		flow_repl &= ~CP210X_SERIAL_AUTO_RECEIVE;
> +	}
>   
>   	if (I_IXON(tty))
>   		flow_repl |= CP210X_SERIAL_AUTO_TRANSMIT;
>   	else
>   		flow_repl &= ~CP210X_SERIAL_AUTO_TRANSMIT;
>   
> -	flow_ctl.ulXonLimit = cpu_to_le32(128);
> -	flow_ctl.ulXoffLimit = cpu_to_le32(128);
> -
>   	dev_dbg(&port->dev, "%s - ctrl = 0x%02x, flow = 0x%02x\n", __func__,
>   			ctl_hs, flow_repl);
>   
> @@ -1908,6 +1922,45 @@ static void cp210x_init_max_speed(struct usb_serial *serial)
>   	priv->use_actual_rate = use_actual_rate;
>   }
>   
> +static int cp210x_get_fw_version(struct usb_serial *serial, u16 value)
> +{
> +	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
> +	u8 ver[3];
> +	int ret;
> +
> +	ret = cp210x_read_vendor_block(serial, REQTYPE_DEVICE_TO_HOST, value,
> +			ver, sizeof(ver));
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(&serial->interface->dev, "%s - %d.%d.%d\n", __func__,
> +			ver[0], ver[1], ver[2]);
> +
> +	priv->fw_version = ver[0] << 16 | ver[1] << 8 | ver[2];
> +
> +	return 0;
> +}
> +
> +static void cp210x_determine_quirks(struct usb_serial *serial)
> +{
> +	struct cp210x_serial_private *priv = usb_get_serial_data(serial);
> +	int ret;
> +
> +	switch (priv->partnum) {
> +	case CP210X_PARTNUM_CP2102N_QFN28:
> +	case CP210X_PARTNUM_CP2102N_QFN24:
> +	case CP210X_PARTNUM_CP2102N_QFN20:
> +		ret = cp210x_get_fw_version(serial, CP210X_GET_FW_VER_2N);
> +		if (ret)
> +			break;
> +		if (priv->fw_version <= 0x10004)
> +			priv->no_flow_control = true;
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>   static int cp210x_attach(struct usb_serial *serial)
>   {
>   	int result;
> @@ -1928,6 +1981,7 @@ static int cp210x_attach(struct usb_serial *serial)
>   
>   	usb_set_serial_data(serial, priv);
>   
> +	cp210x_determine_quirks(serial);
>   	cp210x_init_max_speed(serial);
>   
>   	result = cp210x_gpio_init(serial);

Applied patch and tested with ESP32 board under kernel 5.12.9:


# echo module cp210x +p > /sys/kernel/debug/dynamic_debug/control ; 
insmod ./cp210x.ko dyndbg==p

jun 09 11:51:52 karlalex-asus kernel: usbcore: registered new interface 
driver cp210x
jun 09 11:51:52 karlalex-asus kernel: usbserial: USB Serial support 
registered for cp210x


<device plugged in>

jun 09 11:56:00 karlalex-asus kernel: usb 1-9: new full-speed USB device 
number 6 using xhci_hcd
jun 09 11:56:00 karlalex-asus kernel: usb 1-9: New USB device found, 
idVendor=10c4, idProduct=ea60, bcdDevice= 1.00
jun 09 11:56:00 karlalex-asus kernel: usb 1-9: New USB device strings: 
Mfr=1, Product=2, SerialNumber=3
jun 09 11:56:00 karlalex-asus kernel: usb 1-9: Product: CP2102N USB to 
UART Bridge Controller
jun 09 11:56:00 karlalex-asus kernel: usb 1-9: Manufacturer: Silicon Labs
jun 09 11:56:00 karlalex-asus kernel: usb 1-9: SerialNumber: 
283405bafee6e81182024fe64b629a73
jun 09 11:56:00 karlalex-asus kernel: cp210x 1-9:1.0: cp210x converter 
detected
jun 09 11:56:00 karlalex-asus kernel: cp210x 1-9:1.0: 
cp210x_get_fw_version - 1.0.4
jun 09 11:56:00 karlalex-asus kernel: usb 1-9: cp210x converter now 
attached to ttyUSB0
jun 09 11:56:00 karlalex-asus mtp-probe[15041]: checking bus 1, device 
6: "/sys/devices/pci0000:00/0000:00:14.0/usb1/1-9"
jun 09 11:56:00 karlalex-asus mtp-probe[15041]: bus: 1, device: 6 was 
not an MTP device
jun 09 11:56:00 karlalex-asus mtp-probe[15060]: checking bus 1, device 
6: "/sys/devices/pci0000:00/0000:00:14.0/usb1/1-9"
jun 09 11:56:00 karlalex-asus mtp-probe[15060]: bus: 1, device: 6 was 
not an MTP device
jun 09 11:56:02 karlalex-asus ModemManager[726]: <info> [base-manager] 
couldn't check support for device 
'/sys/devices/pci0000:00/0000:00:14.0/usb1/1-9': not supported by any 
plugin


$ miniterm.py /dev/ttyUSB0 115200
<successful connect>

jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
cp210x_change_speed - setting baud rate to 9600
jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
cp210x_set_flow_control - ctrl = 0x00, flow = 0x00
jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
cp210x_tiocmset_port - control = 0x0303
jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
cp210x_change_speed - setting baud rate to 115384
jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
cp210x_tiocmset_port - control = 0x0101
jun 09 11:56:50 karlalex-asus kernel: cp210x ttyUSB0: 
cp210x_tiocmset_port - control = 0x0202


At least in my case, this patch fixes the regression for my workflow.

