Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA0F4FA5C6
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 10:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiDIIPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 04:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiDIIPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 04:15:25 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B7B102D;
        Sat,  9 Apr 2022 01:13:17 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE3B81C0B8F; Sat,  9 Apr 2022 10:13:15 +0200 (CEST)
Date:   Sat, 9 Apr 2022 10:13:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 5.10 126/599] PCI: pciehp: Clear cmd_busy bit in polling
 mode
Message-ID: <20220409081314.GA19452@amd>
References: <20220405070258.802373272@linuxfoundation.org>
 <20220405070302.589741179@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20220405070302.589741179@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Liguang Zhang <zhangliguang@linux.alibaba.com>
>=20
> commit 92912b175178c7e895f5e5e9f1e30ac30319162b upstream.
>=20
> Writes to a Downstream Port's Slot Control register are PCIe hotplug
> "commands."  If the Port supports Command Completed events, software must
> wait for a command to complete before writing to Slot Control again.
>=20
> pcie_do_write_cmd() sets ctrl->cmd_busy when it writes to Slot Control.  =
If
> software notification is enabled, i.e., PCI_EXP_SLTCTL_HPIE and
> PCI_EXP_SLTCTL_CCIE are set, ctrl->cmd_busy is cleared by pciehp_isr().
>=20
> But when software notification is disabled, as it is when pcie_init()
> powers off an empty slot, pcie_wait_cmd() uses pcie_poll_cmd() to poll for
> command completion, and it neglects to clear ctrl->cmd_busy, which leads =
to
> spurious timeouts:

I'm pretty sure this fixes the problem, but... it is still not fully
correct.

> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -98,6 +98,8 @@ static int pcie_poll_cmd(struct controll
>  		if (slot_status & PCI_EXP_SLTSTA_CC) {
>  			pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
>  						   PCI_EXP_SLTSTA_CC);
> +			ctrl->cmd_busy =3D 0;
> +			smp_mb();
>  			return 1;
>  		}

Is the memory barrier neccessary? I don't see corresponding memory
barrier for reading.

If it is neccessary, should we have WRITE_ONCE at the very least, or
probably normal atomic operations?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmJRQBoACgkQMOfwapXb+vJmSACgki8gGnt/pbitsMqI7fSOXeB6
KMcAn3tpJEX3NYiHw6SwAKOoI6HrVXiR
=5uvu
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
