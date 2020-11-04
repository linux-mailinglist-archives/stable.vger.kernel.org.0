Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9904B2A6EF6
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 21:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgKDUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 15:40:20 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42662 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbgKDUkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 15:40:20 -0500
X-Greylist: delayed 2529 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2020 15:40:19 EST
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1kaOv2-0006Ta-Lq; Wed, 04 Nov 2020 20:58:08 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1kaOv1-001x7t-Gt; Wed, 04 Nov 2020 19:58:07 +0000
Date:   Wed, 4 Nov 2020 19:58:07 +0000
From:   Ben Hutchings <benh@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.4-4.19] xen/events: don't use chip_data for legacy IRQs
Message-ID: <20201104195807.GA464862@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 88.96.1.126
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Juergen Gross <jgross@suse.com>

commit 0891fb39ba67bd7ae023ea0d367297ffff010781 upstream.

Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data=
 to store a per interrupt XEN data pointer which contains XEN specific info=
rmation.")
Xen is using the chip_data pointer for storing IRQ specific data. When
running as a HVM domain this can result in problems for legacy IRQs, as
those might use chip_data for their own purposes.

Use a local array for this purpose in case of legacy IRQs, avoiding the
double use.

Cc: stable@vger.kernel.org
Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to st=
ore a per interrupt XEN data pointer which contains XEN specific informatio=
n.")
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <benh@debian.org>
---
 drivers/xen/events/events_base.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -91,6 +91,8 @@ static bool (*pirq_needs_eoi)(unsigned i
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) !=3D 0)
=20
+static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
+
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
@@ -155,7 +157,18 @@ int get_evtchn_to_irq(unsigned evtchn)
 /* Get info for IRQ */
 struct irq_info *info_for_irq(unsigned irq)
 {
-	return irq_get_chip_data(irq);
+	if (irq < nr_legacy_irqs())
+		return legacy_info_ptrs[irq];
+	else
+		return irq_get_chip_data(irq);
+}
+
+static void set_info_for_irq(unsigned int irq, struct irq_info *info)
+{
+	if (irq < nr_legacy_irqs())
+		legacy_info_ptrs[irq] =3D info;
+	else
+		irq_set_chip_data(irq, info);
 }
=20
 /* Constructors for packed IRQ information. */
@@ -384,7 +397,7 @@ static void xen_irq_init(unsigned irq)
 	info->type =3D IRQT_UNBOUND;
 	info->refcnt =3D -1;
=20
-	irq_set_chip_data(irq, info);
+	set_info_for_irq(irq, info);
=20
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
@@ -433,14 +446,14 @@ static int __must_check xen_allocate_irq
=20
 static void xen_free_irq(unsigned irq)
 {
-	struct irq_info *info =3D irq_get_chip_data(irq);
+	struct irq_info *info =3D info_for_irq(irq);
=20
 	if (WARN_ON(!info))
 		return;
=20
 	list_del(&info->list);
=20
-	irq_set_chip_data(irq, NULL);
+	set_info_for_irq(irq, NULL);
=20
 	WARN_ON(info->refcnt > 0);
=20
@@ -610,7 +623,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 static void __unbind_from_irq(unsigned int irq)
 {
 	int evtchn =3D evtchn_from_irq(irq);
-	struct irq_info *info =3D irq_get_chip_data(irq);
+	struct irq_info *info =3D info_for_irq(irq);
=20
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -1114,7 +1127,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
=20
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
-	struct irq_info *info =3D irq_get_chip_data(irq);
+	struct irq_info *info =3D info_for_irq(irq);
=20
 	if (WARN_ON(!info))
 		return;
@@ -1148,7 +1161,7 @@ int evtchn_make_refcounted(unsigned int
 	if (irq =3D=3D -1)
 		return -ENOENT;
=20
-	info =3D irq_get_chip_data(irq);
+	info =3D info_for_irq(irq);
=20
 	if (!info)
 		return -ENOENT;
@@ -1176,7 +1189,7 @@ int evtchn_get(unsigned int evtchn)
 	if (irq =3D=3D -1)
 		goto done;
=20
-	info =3D irq_get_chip_data(irq);
+	info =3D info_for_irq(irq);
=20
 	if (!info)
 		goto done;

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl+jB8oACgkQ57/I7JWG
EQmWow//Rpt/PcCl/2sWibDu9pa1xs7hIHzTpkaKGapJAXAPseZO55Bgk41/+taa
AunBndeRwwUmhcHV+IQCLqGLoI0MgwoLFMd6ga3w3krMlXUkNS4kGO1vvPNFtccs
18c1C0sQMalzYu+Onxiy2JXLP3DObgpnxj7WoQijPkjANjQ08ehk2rnOzFCl0peb
+l7go9rPyy8kuf7/VnPUBwZrA56R4Js5fi+rZr0kPuoVd0YkJFqUb9D2S4CpKmKi
iIzKuwTCS6tuFWK25sXtqB0ClLO51t2lVNVn5G3zOKbwj2VOcibBd+3HscJmFBtg
Hho2B7+VbpomMX91FTwpSRyvDhMRXyggyV6U4CiM721zW+Q4UVp2uwdZ22CdcIOw
5xWEbg/IioaX+ehlR/c0utOS75F42Fw2c0xIuivbmUCk1r8wTI5EvcMuc0AXdFvs
ftGq85LySKzmFb91NGLWhqjNaZRFViYSjDcf853vFOLxhHbsRIUKWEg0xaeWbUqc
hzIMv7KpOmQxesGc3g7tdJxzv/ppK073eM3O1QiZcFjsMOQTG4+mHpVkoMAV8wwX
qWKx0JhHNfyQ5bV08jsPgGE50qjp6bd01t0OX/aqXTIpdTCLQh6SoWkI2tNs8NZA
IjYlJZABJNDro5tOWOQVFmEu13x1KShMmBcMpDqvVmGE9bTdyQg=
=h5fW
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
