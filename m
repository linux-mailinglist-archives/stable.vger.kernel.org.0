Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA4916AD8
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 21:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEGTEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 15:04:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33158 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbfEGTEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 15:04:06 -0400
Received: from ben by shadbolt.decadent.org.uk with local (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hO5Nk-0000CA-9x; Tue, 07 May 2019 20:04:04 +0100
Date:   Tue, 7 May 2019 20:04:04 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Message-ID: <20190507190404.ub43rr4iuvqfkbsq@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="amebupxkjdtzns4d"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        shadbolt.decadent.org.uk
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=5.0 tests=NO_RELAYS autolearn=disabled
        version=3.4.2
Subject: [PATCH 3.16-4.9] timer/debug: Change /proc/timer_stats from 0644 to
 0600
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--amebupxkjdtzns4d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The timer_stats facility should filter and translate PIDs if opened
=66rom a non-initial PID namespace, to avoid leaking information about
the wider system.  It should also not show kernel virtual addresses.
Unfortunately it has now been removed upstream (as redundant)
instead of being fixed.

For stable, fix the leak by restricting access to root only.  A
similar change was already made for the /proc/timer_list file.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -417,7 +417,7 @@ static int __init init_tstats_procfs(voi
 {
 	struct proc_dir_entry *pe;
=20
-	pe =3D proc_create("timer_stats", 0644, NULL, &tstats_fops);
+	pe =3D proc_create("timer_stats", 0600, NULL, &tstats_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;

--amebupxkjdtzns4d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzR1p8ACgkQ57/I7JWG
EQmWjRAAlQYmNI5JGQtxg9flkPCLOgKwLMAsglvtPB7NybwoxxH1z7cpfUwK65hb
Z+hAFX+TBBSyuRYuf0Pq0cgG1ieFU31YxC3jpxtoP3PmIRIPVydyca+Dg8b0Wt1M
aLDcnicyPXaDnrzRpIJoG6PwblVPB1Pswa0fshN0vMRT0HfbtxWeOrS3Ne0y1Z2Z
LEhxhYXBMN3Z4b/ReORRviJGjtquznrRx5bCGdkJpL74hR2dstDb8JLwO/UFDpCD
gg0IPcW3QLsciiIM+CoCTDu4+qLsOf9JIbhRD9jrhxXTbX7ANkg5XmplHNtcKnow
ZklPX0M48pChdqeGxvN1AmXGMaxnB1USUrXfqGF96ioaHNlwu3vtqntMt4PrfIoC
bYzi8nku3CWjcoPari6fYbK+qSVCJZRZthGWSidrjqaC8mO5Y7150TTDgxqLpbUL
nXfq22bkONVjEI8OSNZj1hd32gvy3Xx9cliodoVgTBUM8di5H9PMjwy3Y5y/7VjP
j+QeqM0OJmY3mmi5gNrl7opvCAMUMKsGL6G9r5v5XOXc1qpPh0wwCMxsewway9OJ
qPX3Yv18+YcQAKuFVRS7aRY+aufjw/KSLQCXr+FIJJx0dKvdlzJVEsX0p+I+Clnq
PcXK/LzyxU8idVlXt3G2ZieDZKKoM1F5RszvEFLIrbR4uMu+1AE=
=y6da
-----END PGP SIGNATURE-----

--amebupxkjdtzns4d--
