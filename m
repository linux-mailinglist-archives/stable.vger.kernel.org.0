Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A972F4A99
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbhAMLsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:48:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51526 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbhAMLsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 06:48:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 93AD41C0B8B; Wed, 13 Jan 2021 12:47:50 +0100 (CET)
Date:   Wed, 13 Jan 2021 12:47:45 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 06/77] scsi: scsi_transport_spi: Set RQF_PM for
 domain validation commands
Message-ID: <20210113114745.GA2843@duo.ucw.cz>
References: <20210111130036.414620026@linuxfoundation.org>
 <20210111130036.711898511@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20210111130036.711898511@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bart Van Assche <bvanassche@acm.org>
>=20
> [ Upstream commit cfefd9f8240a7b9fdd96fcd54cb029870b6d8d88 ]
>=20
> Disable runtime power management during domain validation. Since a later
> patch removes RQF_PREEMPT, set RQF_PM for domain validation commands such
> that these are executed in the quiesced SCSI device state.

This and "05/77] scsi: ide: Do not set the RQF_PREEMPT flag for" do
not fix anything AFAICT. They are in series with other patches in
5.10, so they may make sense there, but I don't think we need them in
4.19.

Best regards,
								Pavel


> index 69213842e63e0..efb9c3d902133 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -130,12 +130,16 @@ static int spi_execute(struct scsi_device *sdev, co=
nst void *cmd,
>  		sshdr =3D &sshdr_tmp;
> =20
>  	for(i =3D 0; i < DV_RETRIES; i++) {
> +		/*
> +		 * The purpose of the RQF_PM flag below is to bypass the
> +		 * SDEV_QUIESCE state.
> +		 */
>  		result =3D scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
>  				      sshdr, DV_TIMEOUT, /* retries */ 1,
>  				      REQ_FAILFAST_DEV |
>  				      REQ_FAILFAST_TRANSPORT |
>  				      REQ_FAILFAST_DRIVER,
> -				      0, NULL);
> +				      RQF_PM, NULL);
>  		if (driver_byte(result) !=3D DRIVER_SENSE ||
>  		    sshdr->sense_key !=3D UNIT_ATTENTION)
>  			break;
> @@ -1018,23 +1022,26 @@ spi_dv_device(struct scsi_device *sdev)
>  	 */
>  	lock_system_sleep();
> =20
> +	if (scsi_autopm_get_device(sdev))
> +		goto unlock_system_sleep;
> +
>  	if (unlikely(spi_dv_in_progress(starget)))
> -		goto unlock;
> +		goto put_autopm;
> =20
>  	if (unlikely(scsi_device_get(sdev)))
> -		goto unlock;
> +		goto put_autopm;
> =20
>  	spi_dv_in_progress(starget) =3D 1;
> =20
>  	buffer =3D kzalloc(len, GFP_KERNEL);
> =20
>  	if (unlikely(!buffer))
> -		goto out_put;
> +		goto put_sdev;
> =20
>  	/* We need to verify that the actual device will quiesce; the
>  	 * later target quiesce is just a nice to have */
>  	if (unlikely(scsi_device_quiesce(sdev)))
> -		goto out_free;
> +		goto free_buffer;
> =20
>  	scsi_target_quiesce(starget);
> =20
> @@ -1054,12 +1061,16 @@ spi_dv_device(struct scsi_device *sdev)
> =20
>  	spi_initial_dv(starget) =3D 1;
> =20
> - out_free:
> +free_buffer:
>  	kfree(buffer);
> - out_put:
> +
> +put_sdev:
>  	spi_dv_in_progress(starget) =3D 0;
>  	scsi_device_put(sdev);
> -unlock:
> +put_autopm:
> +	scsi_autopm_put_device(sdev);
> +
> +unlock_system_sleep:
>  	unlock_system_sleep();
>  }
>  EXPORT_SYMBOL(spi_dv_device);
> --=20
> 2.27.0
>=20
>=20

--=20
http://www.livejournal.com/~pavelmachek

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX/7d4QAKCRAw5/Bqldv6
8sbLAKCT+9OMfcjuCmT+WjeO700Mh3PvygCeILWHPaLMt1vLKMnI9wi0fzIc3mk=
=c57Q
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
