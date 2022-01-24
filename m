Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4811C4984E9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbiAXQdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:33:49 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42302 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiAXQdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:33:49 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2Hr-00071k-NM; Mon, 24 Jan 2022 17:33:47 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2Hq-009zDV-Rl;
        Mon, 24 Jan 2022 17:33:46 +0100
Date:   Mon, 24 Jan 2022 17:33:46 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 2/2] lib/timerqueue: Rely on rbtree semantics for next
 timer
Message-ID: <Ye7U6m6TkFmoM5iZ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PAlXKhjSpNkIs5Ka"
Content-Disposition: inline
In-Reply-To: <Ye7Uv7mOe8NWdbqP@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PAlXKhjSpNkIs5Ka
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Davidlohr Bueso <dave@stgolabs.net>

commit 511885d7061eda3eb1faf3f57dcc936ff75863f1 upstream.

Simplify the timerqueue code by using cached rbtrees and rely on the tree
leftmost node semantics to get the timer with earliest expiration time.
This is a drop in conversion, and therefore semantics remain untouched.

The runtime overhead of cached rbtrees is be pretty much the same as the
current head->next method, noting that when removing the leftmost node,
a common operation for the timerqueue, the rb_next(leftmost) is O(1) as
well, so the next timer will either be the right node or its parent.
Therefore no extra pointer chasing. Finally, the size of the struct
timerqueue_head remains the same.

Passes several hours of rcutorture.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190724152323.bojciei3muvfxalm@linux-r8p5
[bwh: While this was supposed to be just refactoring, it also fixed a
 security flaw (CVE-2021-20317).  Backported to 4.9:
 - Deleted code in timerqueue_del() is different before commit d852d39432f5
   "timerqueue: Use rb_entry_safe() instead of open-coding it"
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/timerqueue.h | 13 ++++++-------
 lib/timerqueue.c           | 31 ++++++++++++-------------------
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index 7eec17ad7fa1..42868a9b4365 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -11,8 +11,7 @@ struct timerqueue_node {
 };
=20
 struct timerqueue_head {
-	struct rb_root head;
-	struct timerqueue_node *next;
+	struct rb_root_cached rb_root;
 };
=20
=20
@@ -28,13 +27,14 @@ extern struct timerqueue_node *timerqueue_iterate_next(
  *
  * @head: head of timerqueue
  *
- * Returns a pointer to the timer node that has the
- * earliest expiration time.
+ * Returns a pointer to the timer node that has the earliest expiration ti=
me.
  */
 static inline
 struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 {
-	return head->next;
+	struct rb_node *leftmost =3D rb_first_cached(&head->rb_root);
+
+	return rb_entry(leftmost, struct timerqueue_node, node);
 }
=20
 static inline void timerqueue_init(struct timerqueue_node *node)
@@ -44,7 +44,6 @@ static inline void timerqueue_init(struct timerqueue_node=
 *node)
=20
 static inline void timerqueue_init_head(struct timerqueue_head *head)
 {
-	head->head =3D RB_ROOT;
-	head->next =3D NULL;
+	head->rb_root =3D RB_ROOT_CACHED;
 }
 #endif /* _LINUX_TIMERQUEUE_H */
diff --git a/lib/timerqueue.c b/lib/timerqueue.c
index 782ae8ca2c06..4f99b5c3ac0e 100644
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -38,9 +38,10 @@
  */
 bool timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *=
node)
 {
-	struct rb_node **p =3D &head->head.rb_node;
+	struct rb_node **p =3D &head->rb_root.rb_root.rb_node;
 	struct rb_node *parent =3D NULL;
-	struct timerqueue_node  *ptr;
+	struct timerqueue_node *ptr;
+	bool leftmost =3D true;
=20
 	/* Make sure we don't add nodes that are already added */
 	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
@@ -48,19 +49,17 @@ bool timerqueue_add(struct timerqueue_head *head, struc=
t timerqueue_node *node)
 	while (*p) {
 		parent =3D *p;
 		ptr =3D rb_entry(parent, struct timerqueue_node, node);
-		if (node->expires.tv64 < ptr->expires.tv64)
+		if (node->expires.tv64 < ptr->expires.tv64) {
 			p =3D &(*p)->rb_left;
-		else
+		} else {
 			p =3D &(*p)->rb_right;
+			leftmost =3D false;
+		}
 	}
 	rb_link_node(&node->node, parent, p);
-	rb_insert_color(&node->node, &head->head);
+	rb_insert_color_cached(&node->node, &head->rb_root, leftmost);
=20
-	if (!head->next || node->expires.tv64 < head->next->expires.tv64) {
-		head->next =3D node;
-		return true;
-	}
-	return false;
+	return leftmost;
 }
 EXPORT_SYMBOL_GPL(timerqueue_add);
=20
@@ -76,16 +75,10 @@ bool timerqueue_del(struct timerqueue_head *head, struc=
t timerqueue_node *node)
 {
 	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
=20
-	/* update next pointer */
-	if (head->next =3D=3D node) {
-		struct rb_node *rbn =3D rb_next(&node->node);
-
-		head->next =3D rbn ?
-			rb_entry(rbn, struct timerqueue_node, node) : NULL;
-	}
-	rb_erase(&node->node, &head->head);
+	rb_erase_cached(&node->node, &head->rb_root);
 	RB_CLEAR_NODE(&node->node);
-	return head->next !=3D NULL;
+
+	return !RB_EMPTY_ROOT(&head->rb_root.rb_root);
 }
 EXPORT_SYMBOL_GPL(timerqueue_del);
=20

--PAlXKhjSpNkIs5Ka
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu1OoACgkQ57/I7JWG
EQnyCQ/8CvKdZdZzGIa5BouhEfClPL9L7h5EUnLI9oI5gvG2fp8Hcb4tPsmrilqR
DQcggEvTzBpYue/yowd27RA95KateXfL2uqNaxuUovnHTRd2oVjQ+E5gzNyVQAbX
8SgXJeBO5PR/d4XIqQLdwjgZd2GRjcp60U35ILI7hQvXZmpRRbAUwfIJ4+H5yHQX
yOtYkTVcHFOFblKDGQZJb782fB9OWf0tvUOkJHJxcG2FG1N7btaeYKb99PGt3HT2
7s+zBxI0HX26BDJlHtPG2MOQrVFzKMY1aGSYIZTGRrvk6h2urs8PDoMTcXpODohk
8hoe6VCrs9/AOcUENatlicVZE5TN43FWN+n50UclVwWnw3L9MwJ0NOyj02QcHcFw
zXw2VWtMNZD+2Vu/0PPaBjJCXiH/gw/sUWrOQDcZW3NWEvNJijfJc3qL8D05WAbh
fPZQqznh72EkLWvlNLJXdDqEcD29GfdB4vb25sqp7GUJ4BG1QaOIx+ae73/AZOLG
jTX7JhncAQ1yvbMuv2dVaIx/XU1vgZWEBGMDBxpjDtz9tHiiWxKHGQDwNJTPhUDm
vXTmU99lO/bSSoTdxgVaWe39y4URyrx3yl+h8vbaMntdU/dBi7yaMx6Dbtlaurwm
TEpYgPq/5uHyAtZ75gztBlUT/L8a729YVZP4gUnp7c/HIm2XVvE=
=9+Kq
-----END PGP SIGNATURE-----

--PAlXKhjSpNkIs5Ka--
