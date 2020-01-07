Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B713307C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgAGUQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:16:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36166 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728379AbgAGUQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 15:16:38 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iovHI-0003SE-C0; Tue, 07 Jan 2020 20:16:36 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iovHH-0071t8-RM; Tue, 07 Jan 2020 20:16:35 +0000
Message-ID: <f3b20f7723e06ea23da1edd439dfdc96d8a85373.camel@decadent.org.uk>
Subject: Re: [PATCH backport 4.9 4.4] xhci: fix USB3 device initiated resume
 race with roothub autosuspend
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Cc:     Lee Hou-hsun <hou-hsun.lee@intel.com>,
        Lee Chiasheng <chiasheng.lee@intel.com>
Date:   Tue, 07 Jan 2020 20:16:26 +0000
In-Reply-To: <20191219120632.4037-1-mathias.nyman@linux.intel.com>
References: <20191219120632.4037-1-mathias.nyman@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-cYcriI9ISgGF/jmQ0n5e"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-cYcriI9ISgGF/jmQ0n5e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-12-19 at 14:06 +0200, Mathias Nyman wrote:
> commit 057d476fff778f1d3b9f861fdb5437ea1a3cfc99 upstream
>=20
> Backport for 4.9 and 4.4 stable kernels

This seems to be needed for 3.16 as well, so I've added this to the
queue with a minor adjustment.

Ben.

> A race in xhci USB3 remote wake handling may force device back to suspend
> after it initiated resume siganaling, causing a missed resume event or wa=
rm
> reset of device.
>=20
> When a USB3 link completes resume signaling and goes to enabled (UO)
> state a interrupt is issued and the interrupt handler will clear the
> bus_state->port_remote_wakeup resume flag, allowing bus suspend.
>=20
> If the USB3 roothub thread just finished reading port status before
> the interrupt, finding ports still in suspended (U3) state, but hasn't
> yet started suspending the hub, then the xhci interrupt handler will clea=
r
> the flag that prevented roothub suspend and allow bus to suspend, forcing
> all port links back to suspended (U3) state.
>=20
> Example case:
> usb_runtime_suspend() # because all ports still show suspended U3
>   usb_suspend_both()
>     hub_suspend();   # successful as hub->wakeup_bits not set yet
> =3D=3D> INTERRUPT
> xhci_irq()
>   handle_port_status()
>     clear bus_state->port_remote_wakeup
>     usb_wakeup_notification()
>       sets hub->wakeup_bits;
>         kick_hub_wq()
> <=3D=3D END INTERRUPT
>       hcd_bus_suspend()
>         xhci_bus_suspend() # success as port_remote_wakeup bits cleared
>=20
> Fix this by increasing roothub usage count during port resume to prevent
> roothub autosuspend, and by making sure bus_state->port_remote_wakeup
> flag is only cleared after resume completion is visible, i.e.
> after xhci roothub returned U0 or other non-U3 link state link on a
> get port status request.
>=20
> Issue rootcaused by Chiasheng Lee
>=20
> Cc: Lee Hou-hsun <hou-hsun.lee@intel.com>
> Cc: Lee Chiasheng <chiasheng.lee@intel.com>
> Reported-by: Lee Chiasheng <chiasheng.lee@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-hub.c  | 8 ++++++++
>  drivers/usb/host/xhci-ring.c | 6 +-----
>  drivers/usb/host/xhci.h      | 1 +
>  3 files changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 39e2d3271035..1d9cb29400f3 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -760,6 +760,14 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
>  			status |=3D USB_PORT_STAT_C_BH_RESET << 16;
>  		if ((raw_port_status & PORT_CEC))
>  			status |=3D USB_PORT_STAT_C_CONFIG_ERROR << 16;
> +
> +		/* USB3 remote wake resume signaling completed */
> +		if (bus_state->port_remote_wakeup & (1 << wIndex) &&
> +		    (raw_port_status & PORT_PLS_MASK) !=3D XDEV_RESUME &&
> +		    (raw_port_status & PORT_PLS_MASK) !=3D XDEV_RECOVERY) {
> +			bus_state->port_remote_wakeup &=3D ~(1 << wIndex);
> +			usb_hcd_end_port_resume(&hcd->self, wIndex);
> +		}
>  	}
> =20
>  	if (hcd->speed < HCD_USB3) {
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 69ad9817076a..b426c83ecb9b 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1609,9 +1609,6 @@ static void handle_port_status(struct xhci_hcd *xhc=
i,
>  		usb_hcd_resume_root_hub(hcd);
>  	}
> =20
> -	if (hcd->speed >=3D HCD_USB3 && (temp & PORT_PLS_MASK) =3D=3D XDEV_INAC=
TIVE)
> -		bus_state->port_remote_wakeup &=3D ~(1 << faked_port_index);
> -
>  	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) =3D=3D XDEV_RESUME) {
>  		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
> =20
> @@ -1630,6 +1627,7 @@ static void handle_port_status(struct xhci_hcd *xhc=
i,
>  			bus_state->port_remote_wakeup |=3D 1 << faked_port_index;
>  			xhci_test_and_clear_bit(xhci, port_array,
>  					faked_port_index, PORT_PLC);
> +			usb_hcd_start_port_resume(&hcd->self, faked_port_index);
>  			xhci_set_link_state(xhci, port_array, faked_port_index,
>  						XDEV_U0);
>  			/* Need to wait until the next link state change
> @@ -1667,8 +1665,6 @@ static void handle_port_status(struct xhci_hcd *xhc=
i,
>  		if (slot_id && xhci->devs[slot_id])
>  			xhci_ring_device(xhci, slot_id);
>  		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
> -			bus_state->port_remote_wakeup &=3D
> -				~(1 << faked_port_index);
>  			xhci_test_and_clear_bit(xhci, port_array,
>  					faked_port_index, PORT_PLC);
>  			usb_wakeup_notification(hcd->self.root_hub,
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index de4771ce0df6..424c07d1ac0e 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -316,6 +316,7 @@ struct xhci_op_regs {
>  #define XDEV_U3		(0x3 << 5)
>  #define XDEV_INACTIVE	(0x6 << 5)
>  #define XDEV_POLLING	(0x7 << 5)
> +#define XDEV_RECOVERY	(0x8 << 5)
>  #define XDEV_COMP_MODE  (0xa << 5)
>  #define XDEV_RESUME	(0xf << 5)
>  /* true: port has power (see HCC_PPC) */
--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.



--=-cYcriI9ISgGF/jmQ0n5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4U5xsACgkQ57/I7JWG
EQnZgQ/9GxLiHJnCuRwpQZDvxqGb/U/N4q6t7cUufuCdbTpEj7Xvo+SQ1jEfZ2U1
VpnZ3R/xqeGMNsEZwxmQTO+znqXTxKo8JRwuf6fjwaosRN084vXffRDGrYXAaNOx
8f2S3crSWPdZt+J73BQjMDFSOYOkTf45SaOkCh3WsyQeKSkWEvzvJAVWcfloX6xz
sJzWa3j23X7Jo6kq/PZjveNR62/VkIwKHIny0RdNDbF0KwFAVClrdVWwVYl+KVy+
EozCtW2QZqyaw2vvR/fdlquNn64NCHg5G4iabP71MvhifCeuluGxe4m8yZGMDSHC
qllVLq4HtC77SdFanH9pFfr3DXCHgwLy3zBFLOgsOuvE+fZLqLwBs23/7XPkrhB3
cm0fddXjAK0/2xjEuFu03UcN+ncHqz5vVXspZB/CHx+7HoTx9Hd2YHIJr9+J5Fp2
qkveJ6l4t3Qa4zhr74qo5VhZcFEsigkqSb6kjWHEqCK8QomO003ERWEKtBSFPEAM
M7IwmN1wYggBZ5TNupnxcZsMyFnIqymGK4+X7h+mPiKaObnc16mxTIClV7upMpDE
Ajx+aIT3VCKQt7X5HvNVpFHS/MBh8Bw40JIBTfJC2Gvy0f366xY/G7ocRr5UonUb
nMfLsoS4hDpOLUTiEflBRC1Q1T0Z0Fb5dA38dP9eCYCl+ymjbn0=
=0JMh
-----END PGP SIGNATURE-----

--=-cYcriI9ISgGF/jmQ0n5e--
