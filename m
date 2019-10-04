Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38777CB7FB
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 12:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfJDKMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 06:12:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55089 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfJDKMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 06:12:22 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id CE39A80313; Fri,  4 Oct 2019 12:12:01 +0200 (CEST)
Date:   Fri, 4 Oct 2019 12:12:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        A Sun <as1033x@comcast.net>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 090/211] media: mceusb: fix (eliminate) TX IR signal
 length limit
Message-ID: <20191004101215.GB24970@amd>
References: <20191003154447.010950442@linuxfoundation.org>
 <20191003154507.534538747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20191003154507.534538747@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-10-03 17:52:36, Greg Kroah-Hartman wrote:
> From: A Sun <as1033x@comcast.net>

> Other changes:
>=20
> The driver's write to USB device architecture change (async to sync I/O)
> is significant so we bump DRIVER_VERSION to "1.95" (from "1.94").

> ---
>  drivers/media/rc/mceusb.c | 334 ++++++++++++++++++++++----------------
>  1 file changed, 196 insertions(+), 138 deletions(-)

This is not a bugfix, this is rewrite that happens to remove a
limitation, and it is way over the 100 line limit. What is going on
here? Why is it even considered for stable?

								Pavel

> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 4c0c8008872ae..f1dfb84094328 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -42,21 +42,22 @@
>  #include <linux/pm_wakeup.h>
>  #include <media/rc-core.h>
> =20
> -#define DRIVER_VERSION	"1.94"
> +#define DRIVER_VERSION	"1.95"
>  #define DRIVER_AUTHOR	"Jarod Wilson <jarod@redhat.com>"
>  #define DRIVER_DESC	"Windows Media Center Ed. eHome Infrared Transceiver=
 " \
>  			"device driver"
>  #define DRIVER_NAME	"mceusb"
> =20
> +#define USB_TX_TIMEOUT		1000 /* in milliseconds */
>  #define USB_CTRL_MSG_SZ		2  /* Size of usb ctrl msg on gen1 hw */
>  #define MCE_G1_INIT_MSGS	40 /* Init messages on gen1 hw to throw out */
> =20
>  /* MCE constants */
> -#define MCE_CMDBUF_SIZE		384  /* MCE Command buffer length */
> +#define MCE_IRBUF_SIZE		128  /* TX IR buffer length */
>  #define MCE_TIME_UNIT		50   /* Approx 50us resolution */
> -#define MCE_CODE_LENGTH		5    /* Normal length of packet (with header) */
> -#define MCE_PACKET_SIZE		4    /* Normal length of packet (without header=
) */
> -#define MCE_IRDATA_HEADER	0x84 /* Actual header format is 0x80 + num_byt=
es */
> +#define MCE_PACKET_SIZE		31   /* Max length of packet (with header) */
> +#define MCE_IRDATA_HEADER	(0x80 + MCE_PACKET_SIZE - 1)
> +				     /* Actual format is 0x80 + num_bytes */
>  #define MCE_IRDATA_TRAILER	0x80 /* End of IR data */
>  #define MCE_MAX_CHANNELS	2    /* Two transmitters, hardware dependent? */
>  #define MCE_DEFAULT_TX_MASK	0x03 /* Vals: TX1=3D0x01, TX2=3D0x02, ALL=3D=
0x03 */
> @@ -609,9 +610,9 @@ static void mceusb_dev_printdata(struct mceusb_dev *i=
r, u8 *buf, int buf_len,
>  	if (len <=3D skip)
>  		return;
> =20
> -	dev_dbg(dev, "%cx data: %*ph (length=3D%d)",
> -		(out ? 't' : 'r'),
> -		min(len, buf_len - offset), buf + offset, len);
> +	dev_dbg(dev, "%cx data[%d]: %*ph (len=3D%d sz=3D%d)",
> +		(out ? 't' : 'r'), offset,
> +		min(len, buf_len - offset), buf + offset, len, buf_len);
> =20
>  	inout =3D out ? "Request" : "Got";
> =20
> @@ -733,6 +734,9 @@ static void mceusb_dev_printdata(struct mceusb_dev *i=
r, u8 *buf, int buf_len,
>  		case MCE_RSP_CMD_ILLEGAL:
>  			dev_dbg(dev, "Illegal PORT_IR command");
>  			break;
> +		case MCE_RSP_TX_TIMEOUT:
> +			dev_dbg(dev, "IR TX timeout (TX buffer underrun)");
> +			break;
>  		default:
>  			dev_dbg(dev, "Unknown command 0x%02x 0x%02x",
>  				 cmd, subcmd);
> @@ -747,13 +751,14 @@ static void mceusb_dev_printdata(struct mceusb_dev =
*ir, u8 *buf, int buf_len,
>  		dev_dbg(dev, "End of raw IR data");
>  	else if ((cmd !=3D MCE_CMD_PORT_IR) &&
>  		 ((cmd & MCE_PORT_MASK) =3D=3D MCE_COMMAND_IRDATA))
> -		dev_dbg(dev, "Raw IR data, %d pulse/space samples", ir->rem);
> +		dev_dbg(dev, "Raw IR data, %d pulse/space samples",
> +			cmd & MCE_PACKET_LENGTH_MASK);
>  #endif
>  }
> =20
>  /*
>   * Schedule work that can't be done in interrupt handlers
> - * (mceusb_dev_recv() and mce_async_callback()) nor tasklets.
> + * (mceusb_dev_recv() and mce_write_callback()) nor tasklets.
>   * Invokes mceusb_deferred_kevent() for recovering from
>   * error events specified by the kevent bit field.
>   */
> @@ -766,23 +771,80 @@ static void mceusb_defer_kevent(struct mceusb_dev *=
ir, int kevent)
>  		dev_dbg(ir->dev, "kevent %d scheduled", kevent);
>  }
> =20
> -static void mce_async_callback(struct urb *urb)
> +static void mce_write_callback(struct urb *urb)
>  {
> -	struct mceusb_dev *ir;
> -	int len;
> -
>  	if (!urb)
>  		return;
> =20
> -	ir =3D urb->context;
> +	complete(urb->context);
> +}
> +
> +/*
> + * Write (TX/send) data to MCE device USB endpoint out.
> + * Used for IR blaster TX and MCE device commands.
> + *
> + * Return: The number of bytes written (> 0) or errno (< 0).
> + */
> +static int mce_write(struct mceusb_dev *ir, u8 *data, int size)
> +{
> +	int ret;
> +	struct urb *urb;
> +	struct device *dev =3D ir->dev;
> +	unsigned char *buf_out;
> +	struct completion tx_done;
> +	unsigned long expire;
> +	unsigned long ret_wait;
> +
> +	mceusb_dev_printdata(ir, data, size, 0, size, true);
> +
> +	urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +	if (unlikely(!urb)) {
> +		dev_err(dev, "Error: mce write couldn't allocate urb");
> +		return -ENOMEM;
> +	}
> +
> +	buf_out =3D kmalloc(size, GFP_KERNEL);
> +	if (!buf_out) {
> +		usb_free_urb(urb);
> +		return -ENOMEM;
> +	}
> +
> +	init_completion(&tx_done);
> +
> +	/* outbound data */
> +	if (usb_endpoint_xfer_int(ir->usb_ep_out))
> +		usb_fill_int_urb(urb, ir->usbdev, ir->pipe_out,
> +				 buf_out, size, mce_write_callback, &tx_done,
> +				 ir->usb_ep_out->bInterval);
> +	else
> +		usb_fill_bulk_urb(urb, ir->usbdev, ir->pipe_out,
> +				  buf_out, size, mce_write_callback, &tx_done);
> +	memcpy(buf_out, data, size);
> +
> +	ret =3D usb_submit_urb(urb, GFP_KERNEL);
> +	if (ret) {
> +		dev_err(dev, "Error: mce write submit urb error =3D %d", ret);
> +		kfree(buf_out);
> +		usb_free_urb(urb);
> +		return ret;
> +	}
> +
> +	expire =3D msecs_to_jiffies(USB_TX_TIMEOUT);
> +	ret_wait =3D wait_for_completion_timeout(&tx_done, expire);
> +	if (!ret_wait) {
> +		dev_err(dev, "Error: mce write timed out (expire =3D %lu (%dms))",
> +			expire, USB_TX_TIMEOUT);
> +		usb_kill_urb(urb);
> +		ret =3D (urb->status =3D=3D -ENOENT ? -ETIMEDOUT : urb->status);
> +	} else {
> +		ret =3D urb->status;
> +	}
> +	if (ret >=3D 0)
> +		ret =3D urb->actual_length;	/* bytes written */
> =20
>  	switch (urb->status) {
>  	/* success */
>  	case 0:
> -		len =3D urb->actual_length;
> -
> -		mceusb_dev_printdata(ir, urb->transfer_buffer, len,
> -				     0, len, true);
>  		break;
> =20
>  	case -ECONNRESET:
> @@ -792,140 +854,135 @@ static void mce_async_callback(struct urb *urb)
>  		break;
> =20
>  	case -EPIPE:
> -		dev_err(ir->dev, "Error: request urb status =3D %d (TX HALT)",
> +		dev_err(ir->dev, "Error: mce write urb status =3D %d (TX HALT)",
>  			urb->status);
>  		mceusb_defer_kevent(ir, EVENT_TX_HALT);
>  		break;
> =20
>  	default:
> -		dev_err(ir->dev, "Error: request urb status =3D %d", urb->status);
> +		dev_err(ir->dev, "Error: mce write urb status =3D %d",
> +			urb->status);
>  		break;
>  	}
> =20
> -	/* the transfer buffer and urb were allocated in mce_request_packet */
> -	kfree(urb->transfer_buffer);
> -	usb_free_urb(urb);
> -}
> -
> -/* request outgoing (send) usb packet - used to initialize remote */
> -static void mce_request_packet(struct mceusb_dev *ir, unsigned char *dat=
a,
> -								int size)
> -{
> -	int res;
> -	struct urb *async_urb;
> -	struct device *dev =3D ir->dev;
> -	unsigned char *async_buf;
> +	dev_dbg(dev, "tx done status =3D %d (wait =3D %lu, expire =3D %lu (%dms=
), urb->actual_length =3D %d, urb->status =3D %d)",
> +		ret, ret_wait, expire, USB_TX_TIMEOUT,
> +		urb->actual_length, urb->status);
> =20
> -	async_urb =3D usb_alloc_urb(0, GFP_KERNEL);
> -	if (unlikely(!async_urb)) {
> -		dev_err(dev, "Error, couldn't allocate urb!");
> -		return;
> -	}
> -
> -	async_buf =3D kmalloc(size, GFP_KERNEL);
> -	if (!async_buf) {
> -		usb_free_urb(async_urb);
> -		return;
> -	}
> -
> -	/* outbound data */
> -	if (usb_endpoint_xfer_int(ir->usb_ep_out))
> -		usb_fill_int_urb(async_urb, ir->usbdev, ir->pipe_out,
> -				 async_buf, size, mce_async_callback, ir,
> -				 ir->usb_ep_out->bInterval);
> -	else
> -		usb_fill_bulk_urb(async_urb, ir->usbdev, ir->pipe_out,
> -				  async_buf, size, mce_async_callback, ir);
> -
> -	memcpy(async_buf, data, size);
> -
> -	dev_dbg(dev, "send request called (size=3D%#x)", size);
> +	kfree(buf_out);
> +	usb_free_urb(urb);
> =20
> -	res =3D usb_submit_urb(async_urb, GFP_ATOMIC);
> -	if (res) {
> -		dev_err(dev, "send request FAILED! (res=3D%d)", res);
> -		kfree(async_buf);
> -		usb_free_urb(async_urb);
> -		return;
> -	}
> -	dev_dbg(dev, "send request complete (res=3D%d)", res);
> +	return ret;
>  }
> =20
> -static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, in=
t size)
> +static void mce_command_out(struct mceusb_dev *ir, u8 *data, int size)
>  {
>  	int rsize =3D sizeof(DEVICE_RESUME);
> =20
>  	if (ir->need_reset) {
>  		ir->need_reset =3D false;
> -		mce_request_packet(ir, DEVICE_RESUME, rsize);
> +		mce_write(ir, DEVICE_RESUME, rsize);
>  		msleep(10);
>  	}
> =20
> -	mce_request_packet(ir, data, size);
> +	mce_write(ir, data, size);
>  	msleep(10);
>  }
> =20
> -/* Send data out the IR blaster port(s) */
> +/*
> + * Transmit IR out the MCE device IR blaster port(s).
> + *
> + * Convert IR pulse/space sequence from LIRC to MCE format.
> + * Break up a long IR sequence into multiple parts (MCE IR data packets).
> + *
> + * u32 txbuf[] consists of IR pulse, space, ..., and pulse times in usec.
> + * Pulses and spaces are implicit by their position.
> + * The first IR sample, txbuf[0], is always a pulse.
> + *
> + * u8 irbuf[] consists of multiple IR data packets for the MCE device.
> + * A packet is 1 u8 MCE_IRDATA_HEADER and up to 30 u8 IR samples.
> + * An IR sample is 1-bit pulse/space flag with 7-bit time
> + * in MCE time units (50usec).
> + *
> + * Return: The number of IR samples sent (> 0) or errno (< 0).
> + */
>  static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned co=
unt)
>  {
>  	struct mceusb_dev *ir =3D dev->priv;
> -	int i, length, ret =3D 0;
> -	int cmdcount =3D 0;
> -	unsigned char cmdbuf[MCE_CMDBUF_SIZE];
> -
> -	/* MCE tx init header */
> -	cmdbuf[cmdcount++] =3D MCE_CMD_PORT_IR;
> -	cmdbuf[cmdcount++] =3D MCE_CMD_SETIRTXPORTS;
> -	cmdbuf[cmdcount++] =3D ir->tx_mask;
> +	u8 cmdbuf[3] =3D { MCE_CMD_PORT_IR, MCE_CMD_SETIRTXPORTS, 0x00 };
> +	u8 irbuf[MCE_IRBUF_SIZE];
> +	int ircount =3D 0;
> +	unsigned int irsample;
> +	int i, length, ret;
> =20
>  	/* Send the set TX ports command */
> -	mce_async_out(ir, cmdbuf, cmdcount);
> -	cmdcount =3D 0;
> -
> -	/* Generate mce packet data */
> -	for (i =3D 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
> -		txbuf[i] =3D txbuf[i] / MCE_TIME_UNIT;
> -
> -		do { /* loop to support long pulses/spaces > 127*50us=3D6.35ms */
> -
> -			/* Insert mce packet header every 4th entry */
> -			if ((cmdcount < MCE_CMDBUF_SIZE) &&
> -			    (cmdcount % MCE_CODE_LENGTH) =3D=3D 0)
> -				cmdbuf[cmdcount++] =3D MCE_IRDATA_HEADER;
> -
> -			/* Insert mce packet data */
> -			if (cmdcount < MCE_CMDBUF_SIZE)
> -				cmdbuf[cmdcount++] =3D
> -					(txbuf[i] < MCE_PULSE_BIT ?
> -					 txbuf[i] : MCE_MAX_PULSE_LENGTH) |
> -					 (i & 1 ? 0x00 : MCE_PULSE_BIT);
> -			else {
> -				ret =3D -EINVAL;
> -				goto out;
> +	cmdbuf[2] =3D ir->tx_mask;
> +	mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
> +
> +	/* Generate mce IR data packet */
> +	for (i =3D 0; i < count; i++) {
> +		irsample =3D txbuf[i] / MCE_TIME_UNIT;
> +
> +		/* loop to support long pulses/spaces > 6350us (127*50us) */
> +		while (irsample > 0) {
> +			/* Insert IR header every 30th entry */
> +			if (ircount % MCE_PACKET_SIZE =3D=3D 0) {
> +				/* Room for IR header and one IR sample? */
> +				if (ircount >=3D MCE_IRBUF_SIZE - 1) {
> +					/* Send near full buffer */
> +					ret =3D mce_write(ir, irbuf, ircount);
> +					if (ret < 0)
> +						return ret;
> +					ircount =3D 0;
> +				}
> +				irbuf[ircount++] =3D MCE_IRDATA_HEADER;
>  			}
> =20
> -		} while ((txbuf[i] > MCE_MAX_PULSE_LENGTH) &&
> -			 (txbuf[i] -=3D MCE_MAX_PULSE_LENGTH));
> -	}
> -
> -	/* Check if we have room for the empty packet at the end */
> -	if (cmdcount >=3D MCE_CMDBUF_SIZE) {
> -		ret =3D -EINVAL;
> -		goto out;
> -	}
> +			/* Insert IR sample */
> +			if (irsample <=3D MCE_MAX_PULSE_LENGTH) {
> +				irbuf[ircount] =3D irsample;
> +				irsample =3D 0;
> +			} else {
> +				irbuf[ircount] =3D MCE_MAX_PULSE_LENGTH;
> +				irsample -=3D MCE_MAX_PULSE_LENGTH;
> +			}
> +			/*
> +			 * Even i =3D IR pulse
> +			 * Odd  i =3D IR space
> +			 */
> +			irbuf[ircount] |=3D (i & 1 ? 0 : MCE_PULSE_BIT);
> +			ircount++;
> +
> +			/* IR buffer full? */
> +			if (ircount >=3D MCE_IRBUF_SIZE) {
> +				/* Fix packet length in last header */
> +				length =3D ircount % MCE_PACKET_SIZE;
> +				if (length > 0)
> +					irbuf[ircount - length] -=3D
> +						MCE_PACKET_SIZE - length;
> +				/* Send full buffer */
> +				ret =3D mce_write(ir, irbuf, ircount);
> +				if (ret < 0)
> +					return ret;
> +				ircount =3D 0;
> +			}
> +		}
> +	} /* after for loop, 0 <=3D ircount < MCE_IRBUF_SIZE */
> =20
>  	/* Fix packet length in last header */
> -	length =3D cmdcount % MCE_CODE_LENGTH;
> -	cmdbuf[cmdcount - length] -=3D MCE_CODE_LENGTH - length;
> +	length =3D ircount % MCE_PACKET_SIZE;
> +	if (length > 0)
> +		irbuf[ircount - length] -=3D MCE_PACKET_SIZE - length;
> =20
> -	/* All mce commands end with an empty packet (0x80) */
> -	cmdbuf[cmdcount++] =3D MCE_IRDATA_TRAILER;
> +	/* Append IR trailer (0x80) to final partial (or empty) IR buffer */
> +	irbuf[ircount++] =3D MCE_IRDATA_TRAILER;
> =20
> -	/* Transmit the command to the mce device */
> -	mce_async_out(ir, cmdbuf, cmdcount);
> +	/* Send final buffer */
> +	ret =3D mce_write(ir, irbuf, ircount);
> +	if (ret < 0)
> +		return ret;
> =20
> -out:
> -	return ret ? ret : count;
> +	return count;
>  }
> =20
>  /* Sets active IR outputs -- mce devices typically have two */
> @@ -965,7 +1022,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev,=
 u32 carrier)
>  			cmdbuf[2] =3D MCE_CMD_SIG_END;
>  			cmdbuf[3] =3D MCE_IRDATA_TRAILER;
>  			dev_dbg(ir->dev, "disabling carrier modulation");
> -			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +			mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
>  			return 0;
>  		}
> =20
> @@ -979,7 +1036,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev,=
 u32 carrier)
>  								carrier);
> =20
>  				/* Transmit new carrier to mce device */
> -				mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +				mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
>  				return 0;
>  			}
>  		}
> @@ -1002,10 +1059,10 @@ static int mceusb_set_timeout(struct rc_dev *dev,=
 unsigned int timeout)
>  	cmdbuf[2] =3D units >> 8;
>  	cmdbuf[3] =3D units;
> =20
> -	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +	mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
> =20
>  	/* get receiver timeout value */
> -	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
> +	mce_command_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
> =20
>  	return 0;
>  }
> @@ -1030,7 +1087,7 @@ static int mceusb_set_rx_wideband(struct rc_dev *de=
v, int enable)
>  		ir->wideband_rx_enabled =3D false;
>  		cmdbuf[2] =3D 1;	/* port 1 is long range receiver */
>  	}
> -	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +	mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
>  	/* response from device sets ir->learning_active */
> =20
>  	return 0;
> @@ -1053,7 +1110,7 @@ static int mceusb_set_rx_carrier_report(struct rc_d=
ev *dev, int enable)
>  		ir->carrier_report_enabled =3D true;
>  		if (!ir->learning_active) {
>  			cmdbuf[2] =3D 2;	/* port 2 is short range receiver */
> -			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +			mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
>  		}
>  	} else {
>  		ir->carrier_report_enabled =3D false;
> @@ -1064,7 +1121,7 @@ static int mceusb_set_rx_carrier_report(struct rc_d=
ev *dev, int enable)
>  		 */
>  		if (ir->learning_active && !ir->wideband_rx_enabled) {
>  			cmdbuf[2] =3D 1;	/* port 1 is long range receiver */
> -			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +			mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
>  		}
>  	}
> =20
> @@ -1143,6 +1200,7 @@ static void mceusb_handle_command(struct mceusb_dev=
 *ir, int index)
>  		}
>  		break;
>  	case MCE_RSP_CMD_ILLEGAL:
> +	case MCE_RSP_TX_TIMEOUT:
>  		ir->need_reset =3D true;
>  		break;
>  	default:
> @@ -1280,7 +1338,7 @@ static void mceusb_get_emulator_version(struct mceu=
sb_dev *ir)
>  {
>  	/* If we get no reply or an illegal command reply, its ver 1, says MS */
>  	ir->emver =3D 1;
> -	mce_async_out(ir, GET_EMVER, sizeof(GET_EMVER));
> +	mce_command_out(ir, GET_EMVER, sizeof(GET_EMVER));
>  }
> =20
>  static void mceusb_gen1_init(struct mceusb_dev *ir)
> @@ -1326,10 +1384,10 @@ static void mceusb_gen1_init(struct mceusb_dev *i=
r)
>  	dev_dbg(dev, "set handshake  - retC =3D %d", ret);
> =20
>  	/* device resume */
> -	mce_async_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
> +	mce_command_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
> =20
>  	/* get hw/sw revision? */
> -	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
> +	mce_command_out(ir, GET_REVISION, sizeof(GET_REVISION));
> =20
>  	kfree(data);
>  }
> @@ -1337,13 +1395,13 @@ static void mceusb_gen1_init(struct mceusb_dev *i=
r)
>  static void mceusb_gen2_init(struct mceusb_dev *ir)
>  {
>  	/* device resume */
> -	mce_async_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
> +	mce_command_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
> =20
>  	/* get wake version (protocol, key, address) */
> -	mce_async_out(ir, GET_WAKEVERSION, sizeof(GET_WAKEVERSION));
> +	mce_command_out(ir, GET_WAKEVERSION, sizeof(GET_WAKEVERSION));
> =20
>  	/* unknown what this one actually returns... */
> -	mce_async_out(ir, GET_UNKNOWN2, sizeof(GET_UNKNOWN2));
> +	mce_command_out(ir, GET_UNKNOWN2, sizeof(GET_UNKNOWN2));
>  }
> =20
>  static void mceusb_get_parameters(struct mceusb_dev *ir)
> @@ -1357,24 +1415,24 @@ static void mceusb_get_parameters(struct mceusb_d=
ev *ir)
>  	ir->num_rxports =3D 2;
> =20
>  	/* get number of tx and rx ports */
> -	mce_async_out(ir, GET_NUM_PORTS, sizeof(GET_NUM_PORTS));
> +	mce_command_out(ir, GET_NUM_PORTS, sizeof(GET_NUM_PORTS));
> =20
>  	/* get the carrier and frequency */
> -	mce_async_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
> +	mce_command_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
> =20
>  	if (ir->num_txports && !ir->flags.no_tx)
>  		/* get the transmitter bitmask */
> -		mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
> +		mce_command_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
> =20
>  	/* get receiver timeout value */
> -	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
> +	mce_command_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
> =20
>  	/* get receiver sensor setting */
> -	mce_async_out(ir, GET_RX_SENSOR, sizeof(GET_RX_SENSOR));
> +	mce_command_out(ir, GET_RX_SENSOR, sizeof(GET_RX_SENSOR));
> =20
>  	for (i =3D 0; i < ir->num_txports; i++) {
>  		cmdbuf[2] =3D i;
> -		mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +		mce_command_out(ir, cmdbuf, sizeof(cmdbuf));
>  	}
>  }
> =20
> @@ -1383,7 +1441,7 @@ static void mceusb_flash_led(struct mceusb_dev *ir)
>  	if (ir->emver < 2)
>  		return;
> =20
> -	mce_async_out(ir, FLASH_LED, sizeof(FLASH_LED));
> +	mce_command_out(ir, FLASH_LED, sizeof(FLASH_LED));
>  }
> =20
>  /*

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2XGv8ACgkQMOfwapXb+vJPtACgsEgMh/XIZJ6mkCIf3PJWUDaD
8QkAniTejcjY4fDVW2b5b13xv5AEVccp
=blWA
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
