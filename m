Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E4B1D8781
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgERSsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:48:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50564 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728954AbgERSsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 14:48:36 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jakoR-0006ww-61; Mon, 18 May 2020 19:48:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jakoQ-003gD0-OG; Mon, 18 May 2020 19:48:30 +0100
Message-ID: <f794df630d41231c9f727d41da842bf76e6e6fa6.camel@decadent.org.uk>
Subject: Re: [RFC/PATCH for 3.16] spi: spi-dw: Add lock protect dw_spi rx/tx
 to prevent concurrent calls
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, "wuxu.wu" <wuxu.wu@huawei.com>,
        Mark Brown <broonie@kernel.org>
Date:   Mon, 18 May 2020 19:48:26 +0100
In-Reply-To: <20200515012829.1070159-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20200515012829.1070159-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-TC19sbEvoya/jICJ9PN5"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-TC19sbEvoya/jICJ9PN5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-05-15 at 10:28 +0900, Nobuhiro Iwamatsu wrote:
> From: "wuxu.wu" <wuxu.wu@huawei.com>
>=20
> commit 19b61392c5a852b4e8a0bf35aecb969983c5932d upstream.

Queued up for 3.16, thanks.

Ben.

> dw_spi_irq() and dw_spi_transfer_one concurrent calls.
>=20
> I find a panic in dw_writer(): txw =3D *(u8 *)(dws->tx), when dw->tx=3D=
=3Dnull,
> dw->len=3D=3D4, and dw->tx_end=3D=3D1.
>=20
> When tpm driver's message overtime dw_spi_irq() and dw_spi_transfer_one
> may concurrent visit dw_spi, so I think dw_spi structure lack of protecti=
on.
>=20
> Otherwise dw_spi_transfer_one set dw rx/tx buffer and then open irq,
> store dw rx/tx instructions and other cores handle irq load dw rx/tx
> instructions may out of order.
>=20
> 	[ 1025.321302] Call trace:
> 	...
> 	[ 1025.321319]  __crash_kexec+0x98/0x148
> 	[ 1025.321323]  panic+0x17c/0x314
> 	[ 1025.321329]  die+0x29c/0x2e8
> 	[ 1025.321334]  die_kernel_fault+0x68/0x78
> 	[ 1025.321337]  __do_kernel_fault+0x90/0xb0
> 	[ 1025.321346]  do_page_fault+0x88/0x500
> 	[ 1025.321347]  do_translation_fault+0xa8/0xb8
> 	[ 1025.321349]  do_mem_abort+0x68/0x118
> 	[ 1025.321351]  el1_da+0x20/0x8c
> 	[ 1025.321362]  dw_writer+0xc8/0xd0
> 	[ 1025.321364]  interrupt_transfer+0x60/0x110
> 	[ 1025.321365]  dw_spi_irq+0x48/0x70
> 	...
>=20
> Signed-off-by: wuxu.wu <wuxu.wu@huawei.com>
> Link: https://lore.kernel.org/r/1577849981-31489-1-git-send-email-wuxu.wu=
@huawei.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> [iwamatsu: Backported to 3.16: adjut context]
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/spi/spi-dw.c | 14 ++++++++++++--
>  drivers/spi/spi-dw.h |  1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index 66e9e5196c8c5..b3e697d5b5966 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -182,9 +182,11 @@ static inline u32 rx_max(struct dw_spi *dws)
> =20
>  static void dw_writer(struct dw_spi *dws)
>  {
> -	u32 max =3D tx_max(dws);
> +	u32 max;
>  	u16 txw =3D 0;
> =20
> +	spin_lock(&dws->buf_lock);
> +	max =3D tx_max(dws);
>  	while (max--) {
>  		/* Set the tx word if the transfer's original "tx" is not null */
>  		if (dws->tx_end - dws->len) {
> @@ -196,13 +198,16 @@ static void dw_writer(struct dw_spi *dws)
>  		dw_writew(dws, DW_SPI_DR, txw);
>  		dws->tx +=3D dws->n_bytes;
>  	}
> +	spin_unlock(&dws->buf_lock);
>  }
> =20
>  static void dw_reader(struct dw_spi *dws)
>  {
> -	u32 max =3D rx_max(dws);
> +	u32 max;
>  	u16 rxw;
> =20
> +	spin_lock(&dws->buf_lock);
> +	max =3D rx_max(dws);
>  	while (max--) {
>  		rxw =3D dw_readw(dws, DW_SPI_DR);
>  		/* Care rx only if the transfer's original "rx" is not null */
> @@ -214,6 +219,7 @@ static void dw_reader(struct dw_spi *dws)
>  		}
>  		dws->rx +=3D dws->n_bytes;
>  	}
> +	spin_unlock(&dws->buf_lock);
>  }
> =20
>  static void *next_transfer(struct dw_spi *dws)
> @@ -368,6 +374,7 @@ static void pump_transfers(unsigned long data)
>  	struct spi_transfer *previous =3D NULL;
>  	struct spi_device *spi =3D NULL;
>  	struct chip_data *chip =3D NULL;
> +	unsigned long flags;
>  	u8 bits =3D 0;
>  	u8 imask =3D 0;
>  	u8 cs_change =3D 0;
> @@ -406,6 +413,7 @@ static void pump_transfers(unsigned long data)
>  	dws->dma_width =3D chip->dma_width;
>  	dws->cs_control =3D chip->cs_control;
> =20
> +	spin_lock_irqsave(&dws->buf_lock, flags);
>  	dws->rx_dma =3D transfer->rx_dma;
>  	dws->tx_dma =3D transfer->tx_dma;
>  	dws->tx =3D (void *)transfer->tx_buf;
> @@ -415,6 +423,7 @@ static void pump_transfers(unsigned long data)
>  	dws->len =3D dws->cur_transfer->len;
>  	if (chip !=3D dws->prev_chip)
>  		cs_change =3D 1;
> +	spin_unlock_irqrestore(&dws->buf_lock, flags);
> =20
>  	cr0 =3D chip->cr0;
> =20
> @@ -651,6 +660,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi=
 *dws)
>  	dws->dma_addr =3D (dma_addr_t)(dws->paddr + 0x60);
>  	snprintf(dws->name, sizeof(dws->name), "dw_spi%d",
>  			dws->bus_num);
> +	spin_lock_init(&dws->buf_lock);
> =20
>  	ret =3D request_irq(dws->irq, dw_spi_irq, IRQF_SHARED, dws->name, dws);
>  	if (ret < 0) {
> diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
> index 6d2acad34f64f..be4119a2159bf 100644
> --- a/drivers/spi/spi-dw.h
> +++ b/drivers/spi/spi-dw.h
> @@ -116,6 +116,7 @@ struct dw_spi {
>  	size_t			len;
>  	void			*tx;
>  	void			*tx_end;
> +	spinlock_t		buf_lock;
>  	void			*rx;
>  	void			*rx_end;
>  	int			dma_mapped;
--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.



--=-TC19sbEvoya/jICJ9PN5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7C2HoACgkQ57/I7JWG
EQlYlw/9FxgsRPpIJkBLJXUjEi5SysPRJH6yRjzywyLPqj5QDYKv4klUUs05PREr
Ilh8baedO330XNEM0jeYGbvMhb+E1vy9pUAskckSK1vQIhPi0miTPQTiMVmGjQPS
15mq8coWd/P+WUhkfKwjVITtbq/Om+hTN57LxZv3e0XbzQGGRs+rLN5jgq/Kyyax
EP7eIyyDXTQpGOfd/tYTMynpcgkKOkhad2nyww+VoHdr0JzepMOULA+++RJLQOMH
sZI7wezGiDep8QHz+JtmdT2b+/QfQxQSiYFOAtwg9/oSYafOv9g0MPXol1BqNr6+
tcQjI/uFHUFFc4sWDphQZtdvx4s+JHkt3XErsS9FvjeeP9xgMiguERr2leNqsxeg
HU4blGYjJ+pFcly66GK234AeN5MFADu/L6fvKFHDaeSyOS4sP31+vAPuDXNqZIu5
nO3X+6fQDQL0goVIMlHCIQJTzWVPS7Ex2owd4I0WnaSgR03e9Fw3Hj0MDjCge8oS
XMZO/jNCrV9ERDI/hHm1uuv/lPzXluEXg4zW/R6xaXTAkUI1bBRAPqK4IeEvtyB1
n8G8jgKEVY3kjoIOKJ8VjkYn5NT4M4XY1p8mUAFGgGnY4bY2yokBck+Dr4HPkiId
xiEmCf/l9f1xWFrya+X+LVG/yInR5ORbroSIxtPCyiFlXZ/XomI=
=nwWg
-----END PGP SIGNATURE-----

--=-TC19sbEvoya/jICJ9PN5--
