Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227D74984DD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243751AbiAXQcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:32:24 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42292 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiAXQcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:32:24 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2GU-000718-TM; Mon, 24 Jan 2022 17:32:22 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2GT-009zBR-On;
        Mon, 24 Jan 2022 17:32:21 +0100
Date:   Mon, 24 Jan 2022 17:32:21 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.9] cipso,calipso: resolve a number of problems with the DOI
 refcounts
Message-ID: <Ye7UlciYUYBcfI31@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HPnF665yLyUSjpMD"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HPnF665yLyUSjpMD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Paul Moore <paul@paul-moore.com>

commit ad5d07f4a9cd671233ae20983848874731102c08 upstream.

The current CIPSO and CALIPSO refcounting scheme for the DOI
definitions is a bit flawed in that we:

1. Don't correctly match gets/puts in netlbl_cipsov4_list().
2. Decrement the refcount on each attempt to remove the DOI from the
   DOI list, only removing it from the list once the refcount drops
   to zero.

This patch fixes these problems by adding the missing "puts" to
netlbl_cipsov4_list() and introduces a more conventional, i.e.
not-buggy, refcounting mechanism to the DOI definitions.  Upon the
addition of a DOI to the DOI list, it is initialized with a refcount
of one, removing a DOI from the list removes it from the list and
drops the refcount by one; "gets" and "puts" behave as expected with
respect to refcounts, increasing and decreasing the DOI's refcount by
one.

Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking with refr=
erence counts")
Fixes: d7cce01504a0 ("netlabel: Add support for removing a CALIPSO DOI.")
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/cipso_ipv4.c            | 11 +----------
 net/ipv6/calipso.c               | 14 +++++---------
 net/netlabel/netlabel_cipso_v4.c |  3 +++
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 553cda6f887a..b7dc20a65b64 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -534,16 +534,10 @@ int cipso_v4_doi_remove(u32 doi, struct netlbl_audit =
*audit_info)
 		ret_val =3D -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!atomic_dec_and_test(&doi_def->refcount)) {
-		spin_unlock(&cipso_v4_doi_list_lock);
-		ret_val =3D -EBUSY;
-		goto doi_remove_return;
-	}
 	list_del_rcu(&doi_def->list);
 	spin_unlock(&cipso_v4_doi_list_lock);
=20
-	cipso_v4_cache_invalidate();
-	call_rcu(&doi_def->rcu, cipso_v4_doi_free_rcu);
+	cipso_v4_doi_putdef(doi_def);
 	ret_val =3D 0;
=20
 doi_remove_return:
@@ -600,9 +594,6 @@ void cipso_v4_doi_putdef(struct cipso_v4_doi *doi_def)
=20
 	if (!atomic_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&cipso_v4_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&cipso_v4_doi_list_lock);
=20
 	cipso_v4_cache_invalidate();
 	call_rcu(&doi_def->rcu, cipso_v4_doi_free_rcu);
diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index b206415bbde7..7628963ddacc 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -97,6 +97,9 @@ struct calipso_map_cache_entry {
=20
 static struct calipso_map_cache_bkt *calipso_cache;
=20
+static void calipso_cache_invalidate(void);
+static void calipso_doi_putdef(struct calipso_doi *doi_def);
+
 /* Label Mapping Cache Functions
  */
=20
@@ -458,15 +461,10 @@ static int calipso_doi_remove(u32 doi, struct netlbl_=
audit *audit_info)
 		ret_val =3D -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!atomic_dec_and_test(&doi_def->refcount)) {
-		spin_unlock(&calipso_doi_list_lock);
-		ret_val =3D -EBUSY;
-		goto doi_remove_return;
-	}
 	list_del_rcu(&doi_def->list);
 	spin_unlock(&calipso_doi_list_lock);
=20
-	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
+	calipso_doi_putdef(doi_def);
 	ret_val =3D 0;
=20
 doi_remove_return:
@@ -522,10 +520,8 @@ static void calipso_doi_putdef(struct calipso_doi *doi=
_def)
=20
 	if (!atomic_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&calipso_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&calipso_doi_list_lock);
=20
+	calipso_cache_invalidate();
 	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
 }
=20
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso=
_v4.c
index 422fac2a4a3c..9a256d0fb957 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -587,6 +587,7 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, str=
uct genl_info *info)
=20
 		break;
 	}
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
=20
 	genlmsg_end(ans_skb, data);
@@ -595,12 +596,14 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, s=
truct genl_info *info)
 list_retry:
 	/* XXX - this limit is a guesstimate */
 	if (nlsze_mult < 4) {
+		cipso_v4_doi_putdef(doi_def);
 		rcu_read_unlock();
 		kfree_skb(ans_skb);
 		nlsze_mult *=3D 2;
 		goto list_start;
 	}
 list_failure_lock:
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
 list_failure:
 	kfree_skb(ans_skb);

--HPnF665yLyUSjpMD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu1JUACgkQ57/I7JWG
EQkRdQ//WPkgVnhlHdFY4EIw/P/3D6EiBCrkTbAv2tW4548vPuBfOWyFuCOoFkQw
HSwODEG1Mjz5DK0rEhYDpymADurbPpFFdxJWbryAauiWxii3nHRiuY9QTIqlqsiI
yYgO0hv174zB8QWE7WEBFjbhYm8hfwnXotmSTxvrhFBbdUXGjXVCn4td+vIhLTZ5
ktjYLTTwPfzYc3k2bBY9/nm01Ia/yanVgE9yxuHgSk/KEBu67Z3HOmn1So25qFYS
OIAjiviA6mKgXL71yqSOqM9GYKoyntm07uaOV1y+Ax1wmk13uf4oafUy6MpLElKj
ZvsscAhYPDTwSs3Ro1voE2DBDhA23lDH31J8VBw3s+lTO6w/rdm27GouasGBzj40
ZJ+AC1aH52s/v0ikK+od280UjlWXWeFLRPmkGh6CopZdEWs+XSKkXDOVBgF5QiLF
rvikdc+GEwNyOGftE3Y0YOkWDivo1YHVok7W57REGvNsaZ12UGd6LMzsicAgPx/S
854rE2LyQjqpdiZ6BvY0/yf8DbTWdnLUbN+BU+y2VsZuDNWwq8Zte5S5+q6jzrp3
yum/r/C/5V21as8SONG6jsubJccIZ5GG79H2LIbZql1kMxltdKhS0zQxRPwZb6zN
5+3xZVKQB4gKOv9OEBcEnwjNxSa3rCYF0ludMn+NyIx/eQWnMPg=
=SvE7
-----END PGP SIGNATURE-----

--HPnF665yLyUSjpMD--
