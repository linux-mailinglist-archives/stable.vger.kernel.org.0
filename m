Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8E32887E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhCARlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:41:24 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:32862 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbhCARcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:32:48 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOp-0002al-Jg; Mon, 01 Mar 2021 18:32:03 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmOo-004iYu-P8; Mon, 01 Mar 2021 18:32:02 +0100
Date:   Mon, 1 Mar 2021 18:32:02 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 4.9 7/7] futex: Don't enable IRQs unconditionally in
 put_pi_state()
Message-ID: <YD0lErDoywqSJyM8@decadent.org.uk>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xpdcucgc0C52I5eD"
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xpdcucgc0C52I5eD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Dan Carpenter <dan.carpenter@oracle.com>

commit 1e106aa3509b86738769775969822ffc1ec21bf4 upstream.

The exit_pi_state_list() function calls put_pi_state() with IRQs disabled
and is not expecting that IRQs will be enabled inside the function.

Use the _irqsave() variant so that IRQs are restored to the original state
instead of being enabled unconditionally.

Fixes: 153fbd1226fb ("futex: Fix more put_pi_state() vs. exit_pi_state_list=
() races")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201106085205.GA1159983@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 855dae277f83..0015c14ac2c0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -882,10 +882,12 @@ static void put_pi_state(struct futex_pi_state *pi_st=
ate)
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
-		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
 		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}
=20
 	if (current->pi_state_cache) {

--xpdcucgc0C52I5eD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JRIACgkQ57/I7JWG
EQm++g//WVM4wDWPLGHcHeDHM5cs6+8nWg3N6Lxr/mZR3z8YwTAMcUTdibrCx2o1
D4nLJ/uraxRF1SSDQwM4hQbrJRteI3jMmzWx+EpMFxLJFdHj8m/Jwgocvx7Nncub
fxpdhgjL5a3Kw3AKDPDRaqiJO3e8egKM6y1zFlDnmF+r9apfa8q4+y4hWYn3XX/O
F0mrUj37O1xEKw2L9e9iHAhPi/RSvRtT6DHwzb6GbKVYPADMcs5FvPZgji+mhcgT
5qEEDBhrlJfDxEl1NwvwPKZzTsOTgYtQB8S3DIC8VtnemCe/gZczL2C8MeZsmV8r
XlfA9Vw2Jg3eXDwipapfraqs2aZjOjZTL6LM/SDex4CAW9/JaNViqTf4TWvBuNMT
TeHqhFXB4qwYqFE1G3ASWkZjAYB09I9rPxWvIaAhm7opgh6csj/i4VHodkPWPszo
i3kwaEb4kxLqsh3BnbcTQeZgBAJluehtAd2O62HmRl3r4+gEsEKE9RHrdVoyY5/O
hbadRIF0G1LvaP+0tzDQEmD0jRVW89TmUl3tdjWes3/V6ivLX3/k8sCxnz5UOAI/
f20jqz1qPa5LmvMNY15zx4xCRhKyJMNd7xgpoXkeWsFPPXqAFM2U9RzQ6vEn4dPs
TMN/cSjIpVpURr30VPH/KHsYMfezrFIIYLkbiyE2oXm5q2/vl6E=
=1rHh
-----END PGP SIGNATURE-----

--xpdcucgc0C52I5eD--
