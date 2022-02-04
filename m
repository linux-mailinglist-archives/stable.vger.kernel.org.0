Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B503E4A918A
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 01:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349242AbiBDAUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 19:20:01 -0500
Received: from bluehome.net ([96.66.250.149]:41852 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245100AbiBDAUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Feb 2022 19:20:00 -0500
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id 636094B40587
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 16:20:00 -0800 (PST)
Date:   Thu, 3 Feb 2022 16:19:59 -0800
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: Regression/boot failure on 5.16.3
Message-ID: <20220203161959.3edf1d6e@valencia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/2zjER3HsKi.Ll0jT2UCnaSS"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/2zjER3HsKi.Ll0jT2UCnaSS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The computer (amd64) fails to boot. The init was stuck at the
synchronization of the time through the network. This began between
5.16.2 (good) and 5.16.3 (bad.) This continues on 5.16.4 and 5.16.5.
Git bisect revealed the following. In this case the nonfree firmwre is
not present on the system. Blacklisting the iwflwifi module works as a
workaround for now.

6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1 is the first bad commit
commit 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Dec 10 11:12:42 2021 +0200

    iwlwifi: fix leaks/bad data after failed firmware load
   =20
    [ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]
   =20
    If firmware load fails after having loaded some parts of the
    firmware, e.g. the IML image, then this would leak. For the
    host command list we'd end up running into a WARN on the next
    attempt to load another firmware image.
   =20
    Fix this by calling iwl_dealloc_ucode() on failures, and make
    that also clear the data so we start fresh on the next round.
   =20
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
    Link:
    https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f=
6aa632d94ae2069f85e1bca5e734dce0@changeid
    Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--Sig_/2zjER3HsKi.Ll0jT2UCnaSS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmH8cS8ACgkQnQ2zG1Ra
MZiVchAAkA5anv4xBCvH+Vo18cZ/GFfHPU4VDJp0Ep7csd+EABzQfknwwk6WhnP9
F3jlWWXRwjlKuitGXsIcWBe0kVY+tww0x1dXOqRtPRIex1VAdE/YtRPcbsnKbA3Q
krUKzx5nzt+a+wKaP5KSXHDu8LW9pyH8w9HmIpw0dPhBxNsUe+dJkZYyGPUGNRoZ
NjdJYEXJaoMh0nXErrBTwzcsIOjcUbGaAkgbL44C64KRGuJw58/uLuGMxC1f2bys
/5EfNsAac+fUrb0eiELY6PnynQ1EA/GBy7hINAaTboptwm3DV8b+MS/cmBmj7WHA
8Q4J54boujgWYsdLrLgAmw/tjSaOnP+sV93z6+HiChcdaMboiuhd0cjkaiNjLYF5
JFZbFZCnNVDWR2/D312vTsLa2XsTUtjTWbWZnqVinX47E/zo2GQfAwJzatY6iDAs
bEDngFQxa9kp2NTJLWxxxmU8GtD+18qJMl5F0BMaQLunY/+TJmyjjuUpttOBa00c
9GNr3GvFXZhRijlE5XHjDnQqJqxB2QZec2/6oTCFonPOu75plIteAQZxt292yB/r
u6Zkwv+lff0LEeGSDdTrNSAw3yHsm7impk8EKOy2Be0egaHEff3a/ttyxRRyCDJo
dapVWiGPnI6SL9MLOVTBEqWNYj3piYZKVSTmAU2M+bUit32x83k=
=ZoLH
-----END PGP SIGNATURE-----

--Sig_/2zjER3HsKi.Ll0jT2UCnaSS--
