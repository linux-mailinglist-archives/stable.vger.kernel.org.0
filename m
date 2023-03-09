Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6576B2DE9
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 20:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCITsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 14:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCITsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 14:48:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3B7EBFA7;
        Thu,  9 Mar 2023 11:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0962B82078;
        Thu,  9 Mar 2023 19:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F021C433EF;
        Thu,  9 Mar 2023 19:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678391305;
        bh=EkoETZpyF72TwLfxVrHUyAiLu2LMN0UlkQ4+4D2jVlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H9ZQ66zUNK8zTexQVJZW/sMiexOywmWMpOX1GrwOEUCKBZt/L1BY0Y1Fojr8sKiWr
         u3U723s/d36zQM4Rjx5b5wUz+0Br0HxPaa/cDJgsgWsL0RkufRihr5KuG5aaTw9wKn
         KuK7u4KbsHtKQAoQQWXvpsbQ4DrzimTEOczBMap/Qnnb/t1Ta/cC4HJ7T9Es5iGi+Y
         BXbKT2jS4RpqQHIUtJ7TakswZG7B5+UpX2yG7hjOHTZPo5d/4kCUnRZoecGVz/OigN
         PjX8B+MH//yXRyCTivJ7WIuiWEbQZGAK2eDQ7peSOxHFp2e1AXjpI/da7Fqr3sN9OH
         bXt+bmf+vDnPQ==
Date:   Thu, 9 Mar 2023 19:48:20 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Janne Grunau <j@jannau.net>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: apple: Set only available ports up
Message-ID: <08aa3766-d7a6-449d-a5cc-ddcf23601c43@spud>
References: <20230307-apple_pcie_disabled_ports-v2-1-c3bd1fd278a4@jannau.net>
 <20230309163935.GA1140101@bhelgaas>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y6suV7oa2FgnRcti"
Content-Disposition: inline
In-Reply-To: <20230309163935.GA1140101@bhelgaas>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Y6suV7oa2FgnRcti
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09, 2023 at 10:39:35AM -0600, Bjorn Helgaas wrote:
> [+cc Daire, Conor for apple/microchip use of ECAM .init() method]

It's probably really a Daire question, although he is off in the weeds
at the moment..
>=20
> On Thu, Mar 09, 2023 at 02:36:24PM +0100, Janne Grunau wrote:
> > Fixes following warning inside of_irq_parse_raw() called from the common
> > PCI device probe path.
> >=20
> >   /soc/pcie@690000000/pci@1,0 interrupt-map failed, using interrupt-con=
troller
> >   WARNING: CPU: 4 PID: 252 at drivers/of/irq.c:279 of_irq_parse_raw+0x5=
fc/0x724
>=20
> Based on this commit log, I assume this patch only fixes the warning,
> and the system *works* just fine either way.  If that's the case, it's
> debatable whether it meets the stable kernel criteria, although the
> documented criteria are much stricter than what happens in practice.
>=20
> >   ...
> >   Call trace:
> >    of_irq_parse_raw+0x5fc/0x724
> >    of_irq_parse_and_map_pci+0x128/0x1d8
> >    pci_assign_irq+0xc8/0x140
> >    pci_device_probe+0x70/0x188
> >    really_probe+0x178/0x418
> >    __driver_probe_device+0x120/0x188
> >    driver_probe_device+0x48/0x22c
> >    __device_attach_driver+0x134/0x1d8
> >    bus_for_each_drv+0x8c/0xd8
> >    __device_attach+0xdc/0x1d0
> >    device_attach+0x20/0x2c
> >    pci_bus_add_device+0x5c/0xc0
> >    pci_bus_add_devices+0x58/0x88
> >    pci_host_probe+0x124/0x178
> >    pci_host_common_probe+0x124/0x198 [pci_host_common]
> >    apple_pcie_probe+0x108/0x16c [pcie_apple]
> >    platform_probe+0xb4/0xdc
> >=20
> > This became apparent after disabling unused PCIe ports in the Apple
> > silicon device trees instead of deleting them.
> >=20
> > Use for_each_available_child_of_node instead of for_each_child_of_node
> > which takes the "status" property into account.
> >=20
> > Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unu=
sed-v1-0-5ea0d3ddcde3@jannau.net/
> > Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08c=
e@linaro.org/
> > Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Janne Grunau <j@jannau.net>
> > ---
> > Changes in v2:
> > - rewritten commit message with more details and corrections
> > - collected Marc's "Reviewed-by:"
> > - Link to v1: https://lore.kernel.org/r/20230307-apple_pcie_disabled_po=
rts-v1-1-b32ef91faf19@jannau.net
> > ---
> >  drivers/pci/controller/pcie-apple.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controll=
er/pcie-apple.c
> > index 66f37e403a09..f8670a032f7a 100644
> > --- a/drivers/pci/controller/pcie-apple.c
> > +++ b/drivers/pci/controller/pcie-apple.c
> > @@ -783,7 +783,7 @@ static int apple_pcie_init(struct pci_config_window=
 *cfg)
> >  	cfg->priv =3D pcie;
> >  	INIT_LIST_HEAD(&pcie->ports);
> > =20
> > -	for_each_child_of_node(dev->of_node, of_port) {
> > +	for_each_available_child_of_node(dev->of_node, of_port) {
> >  		ret =3D apple_pcie_setup_port(pcie, of_port);
> >  		if (ret) {
> >  			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);
>=20
> Is this change still needed after 6fffbc7ae137 ("PCI: Honor firmware's
> device disabled status")?  This is a generic problem, and it would be
> a lot nicer if we had a generic solution.  But I assume it *is* still
> needed because Rob gave his Reviewed-by.
>=20
> Not related to this patch, but this function looks funny to me.  Most
> pci_ecam_ops.init functions just set up ECAM-related things.
>=20
> In addition to ECAM stuff, apple_pcie_init() and mc_platform_init()
> also initialize IRQs, clocks, and resets.
>=20
> Maybe we shoehorn the IRQ, clock, reset setup into pci_ecam_ops.init
> because we lack a generic hook for doing those things, but it seems a
> little muddy conceptually.

"We", and that's very much the royal variety, were in the middle of
re-working some of this stuff actually.

At the moment we're using pci_host_common_probe() as
platform_driver.probe, but Daire has a patchset where he introduced an
mc_host_probe() instead, which sets up the clocks.
The interrupt setup is still done in the pci_ecam_ops.init function
though, although with a comment added noting that "Address translation
is up; safe to enable interrupts". The most relevant patch in that
series is:
https://lore.kernel.org/linux-pci/20230111125323.1911373-9-daire.mcnamara@m=
icrochip.com/

Robin/Lorenzo had some comments about the dt parsing that needed
investigation & Daire's off in the weeds, but hopefully we'll get another
version of that stuff out once he gets back.
That'll at least move the clock setup out of the ecam bits and provide a
reason for why we're doing the interrupt setup in pci_ecam_ops.init.

FWIW, doing it this way was review feedback at some stage during the
upstreaming process for the driver:
https://lore.kernel.org/linux-pci/20200709200055.GA763222@bogus/
Originally, Daire was doing this stuff in platform_device.probe but that
was 3 years ago, so maybe the winds have changed since then!

Hope that helps?
Conor.

--Y6suV7oa2FgnRcti
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAo4AwAKCRB4tDGHoIJi
0kXjAP9gzE7+3b8wGo8+7cIJEN3dcnt/5faCnm6i4/n+Lpit/QD8DuPg6PbVD7Mf
Q+cw1y8yVA7f7Y4Qa5H8AlJTVUWpSw8=
=LxFO
-----END PGP SIGNATURE-----

--Y6suV7oa2FgnRcti--
