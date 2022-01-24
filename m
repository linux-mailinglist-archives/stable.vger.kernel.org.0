Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DCC4984E1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiAXQdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:33:05 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42298 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243770AbiAXQdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:33:05 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2H9-00071V-UW; Mon, 24 Jan 2022 17:33:03 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2H9-009zCl-5S;
        Mon, 24 Jan 2022 17:33:03 +0100
Date:   Mon, 24 Jan 2022 17:33:03 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4.9 1/2] rbtree: cache leftmost node internally
Message-ID: <Ye7Uv7mOe8NWdbqP@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MVysiewe1KeBBovb"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MVysiewe1KeBBovb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Davidlohr Bueso <dave@stgolabs.net>

commit cd9e61ed1eebbcd5dfad59475d41ec58d9b64b6a upstream.

Patch series "rbtree: Cache leftmost node internally", v4.

A series to extending rbtrees to internally cache the leftmost node such
that we can have fast overlap check optimization for all interval tree
users[1].  The benefits of this series are that:

(i)   Unify users that do internal leftmost node caching.
(ii)  Optimize all interval tree users.
(iii) Convert at least two new users (epoll and procfs) to the new interfac=
e.

This patch (of 16):

Red-black tree semantics imply that nodes with smaller or greater (or
equal for duplicates) keys always be to the left and right,
respectively.  For the kernel this is extremely evident when considering
our rb_first() semantics.  Enabling lookups for the smallest node in the
tree in O(1) can save a good chunk of cycles in not having to walk down
the tree each time.  To this end there are a few core users that
explicitly do this, such as the scheduler and rtmutexes.  There is also
the desire for interval trees to have this optimization allowing faster
overlap checking.

This patch introduces a new 'struct rb_root_cached' which is just the
root with a cached pointer to the leftmost node.  The reason why the
regular rb_root was not extended instead of adding a new structure was
that this allows the user to have the choice between memory footprint
and actual tree performance.  The new wrappers on top of the regular
rb_root calls are:

 - rb_first_cached(cached_root) -- which is a fast replacement
     for rb_first.

 - rb_insert_color_cached(node, cached_root, new)

 - rb_erase_cached(node, cached_root)

In addition, augmented cached interfaces are also added for basic
insertion and deletion operations; which becomes important for the
interval tree changes.

With the exception of the inserts, which adds a bool for updating the
new leftmost, the interfaces are kept the same.  To this end, porting rb
users to the cached version becomes really trivial, and keeping current
rbtree semantics for users that don't care about the optimization
requires zero overhead.

Link: http://lkml.kernel.org/r/20170719014603.19029-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/rbtree.txt         | 33 +++++++++++++++++++++++++++++++
 include/linux/rbtree.h           | 21 ++++++++++++++++++++
 include/linux/rbtree_augmented.h | 33 ++++++++++++++++++++++++++++---
 lib/rbtree.c                     | 34 +++++++++++++++++++++++++++-----
 4 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index b9d9cc57be18..9fedfedfd85f 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,6 +190,39 @@ rb_entry(node, type, member).
   for (node =3D rb_first(&mytree); node; node =3D rb_next(node))
 	printk("key=3D%s\n", rb_entry(node, struct mytype, node)->keystring);
=20
+Cached rbtrees
+--------------
+
+Computing the leftmost (smallest) node is quite a common task for binary
+search trees, such as for traversals or users relying on a the particular
+order for their own logic. To this end, users can use 'struct rb_root_cach=
ed'
+to optimize O(logN) rb_first() calls to a simple pointer fetch avoiding
+potentially expensive tree iterations. This is done at negligible runtime
+overhead for maintanence; albeit larger memory footprint.
+
+Similar to the rb_root structure, cached rbtrees are initialized to be
+empty via:
+
+  struct rb_root_cached mytree =3D RB_ROOT_CACHED;
+
+Cached rbtree is simply a regular rb_root with an extra pointer to cache t=
he
+leftmost node. This allows rb_root_cached to exist wherever rb_root does,
+which permits augmented trees to be supported as well as only a few extra
+interfaces:
+
+  struct rb_node *rb_first_cached(struct rb_root_cached *tree);
+  void rb_insert_color_cached(struct rb_node *, struct rb_root_cached *, b=
ool);
+  void rb_erase_cached(struct rb_node *node, struct rb_root_cached *);
+
+Both insert and erase calls have their respective counterpart of augmented
+trees:
+
+  void rb_insert_augmented_cached(struct rb_node *node, struct rb_root_cac=
hed *,
+				  bool, struct rb_augment_callbacks *);
+  void rb_erase_augmented_cached(struct rb_node *, struct rb_root_cached *,
+				 struct rb_augment_callbacks *);
+
+
 Support for Augmented rbtrees
 -----------------------------
=20
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index e585018498d5..d574361943ea 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -44,10 +44,25 @@ struct rb_root {
 	struct rb_node *rb_node;
 };
=20
+/*
+ * Leftmost-cached rbtrees.
+ *
+ * We do not cache the rightmost node based on footprint
+ * size vs number of potential users that could benefit
+ * from O(1) rb_last(). Just not worth it, users that want
+ * this feature can always implement the logic explicitly.
+ * Furthermore, users that want to cache both pointers may
+ * find it a bit asymmetric, but that's ok.
+ */
+struct rb_root_cached {
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+};
=20
 #define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3))
=20
 #define RB_ROOT	(struct rb_root) { NULL, }
+#define RB_ROOT_CACHED (struct rb_root_cached) { {NULL, }, NULL }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
=20
 #define RB_EMPTY_ROOT(root)  (READ_ONCE((root)->rb_node) =3D=3D NULL)
@@ -69,6 +84,12 @@ extern struct rb_node *rb_prev(const struct rb_node *);
 extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);
=20
+extern void rb_insert_color_cached(struct rb_node *,
+				   struct rb_root_cached *, bool);
+extern void rb_erase_cached(struct rb_node *node, struct rb_root_cached *);
+/* Same as rb_first(), but O(1) */
+#define rb_first_cached(root) (root)->rb_leftmost
+
 /* Postorder iteration - always visit the parent after its children */
 extern struct rb_node *rb_first_postorder(const struct rb_root *);
 extern struct rb_node *rb_next_postorder(const struct rb_node *);
diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmen=
ted.h
index d076183e49be..023d64657e95 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -41,7 +41,9 @@ struct rb_augment_callbacks {
 	void (*rotate)(struct rb_node *old, struct rb_node *new);
 };
=20
-extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *ro=
ot,
+extern void __rb_insert_augmented(struct rb_node *node,
+				  struct rb_root *root,
+				  bool newleft, struct rb_node **leftmost,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
 /*
  * Fixup the rbtree and update the augmented information when rebalancing.
@@ -57,7 +59,16 @@ static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
 {
-	__rb_insert_augmented(node, root, augment->rotate);
+	__rb_insert_augmented(node, root, false, NULL, augment->rotate);
+}
+
+static inline void
+rb_insert_augmented_cached(struct rb_node *node,
+			   struct rb_root_cached *root, bool newleft,
+			   const struct rb_augment_callbacks *augment)
+{
+	__rb_insert_augmented(node, &root->rb_root,
+			      newleft, &root->rb_leftmost, augment->rotate);
 }
=20
 #define RB_DECLARE_CALLBACKS(rbstatic, rbname, rbstruct, rbfield,	\
@@ -148,6 +159,7 @@ extern void __rb_erase_color(struct rb_node *parent, st=
ruct rb_root *root,
=20
 static __always_inline struct rb_node *
 __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		     struct rb_node **leftmost,
 		     const struct rb_augment_callbacks *augment)
 {
 	struct rb_node *child =3D node->rb_right;
@@ -155,6 +167,9 @@ __rb_erase_augmented(struct rb_node *node, struct rb_ro=
ot *root,
 	struct rb_node *parent, *rebalance;
 	unsigned long pc;
=20
+	if (leftmost && node =3D=3D *leftmost)
+		*leftmost =3D rb_next(node);
+
 	if (!tmp) {
 		/*
 		 * Case 1: node to erase has no more than 1 child (easy!)
@@ -254,9 +269,21 @@ static __always_inline void
 rb_erase_augmented(struct rb_node *node, struct rb_root *root,
 		   const struct rb_augment_callbacks *augment)
 {
-	struct rb_node *rebalance =3D __rb_erase_augmented(node, root, augment);
+	struct rb_node *rebalance =3D __rb_erase_augmented(node, root,
+							 NULL, augment);
 	if (rebalance)
 		__rb_erase_color(rebalance, root, augment->rotate);
 }
=20
+static __always_inline void
+rb_erase_augmented_cached(struct rb_node *node, struct rb_root_cached *roo=
t,
+			  const struct rb_augment_callbacks *augment)
+{
+	struct rb_node *rebalance =3D __rb_erase_augmented(node, &root->rb_root,
+							 &root->rb_leftmost,
+							 augment);
+	if (rebalance)
+		__rb_erase_color(rebalance, &root->rb_root, augment->rotate);
+}
+
 #endif	/* _LINUX_RBTREE_AUGMENTED_H */
diff --git a/lib/rbtree.c b/lib/rbtree.c
index eb8a19fee110..53746be42903 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -95,10 +95,14 @@ __rb_rotate_set_parents(struct rb_node *old, struct rb_=
node *new,
=20
 static __always_inline void
 __rb_insert(struct rb_node *node, struct rb_root *root,
+	    bool newleft, struct rb_node **leftmost,
 	    void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
 	struct rb_node *parent =3D rb_red_parent(node), *gparent, *tmp;
=20
+	if (newleft)
+		*leftmost =3D node;
+
 	while (true) {
 		/*
 		 * Loop invariant: node is red
@@ -417,19 +421,38 @@ static const struct rb_augment_callbacks dummy_callba=
cks =3D {
=20
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
-	__rb_insert(node, root, dummy_rotate);
+	__rb_insert(node, root, false, NULL, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_insert_color);
=20
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *rebalance;
-	rebalance =3D __rb_erase_augmented(node, root, &dummy_callbacks);
+	rebalance =3D __rb_erase_augmented(node, root,
+					 NULL, &dummy_callbacks);
 	if (rebalance)
 		____rb_erase_color(rebalance, root, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_erase);
=20
+void rb_insert_color_cached(struct rb_node *node,
+			    struct rb_root_cached *root, bool leftmost)
+{
+	__rb_insert(node, &root->rb_root, leftmost,
+		    &root->rb_leftmost, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_insert_color_cached);
+
+void rb_erase_cached(struct rb_node *node, struct rb_root_cached *root)
+{
+	struct rb_node *rebalance;
+	rebalance =3D __rb_erase_augmented(node, &root->rb_root,
+					 &root->rb_leftmost, &dummy_callbacks);
+	if (rebalance)
+		____rb_erase_color(rebalance, &root->rb_root, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_erase_cached);
+
 /*
  * Augmented rbtree manipulation functions.
  *
@@ -438,9 +461,10 @@ EXPORT_SYMBOL(rb_erase);
  */
=20
 void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+			   bool newleft, struct rb_node **leftmost,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
-	__rb_insert(node, root, augment_rotate);
+	__rb_insert(node, root, newleft, leftmost, augment_rotate);
 }
 EXPORT_SYMBOL(__rb_insert_augmented);
=20
@@ -485,7 +509,7 @@ struct rb_node *rb_next(const struct rb_node *node)
 	 * as we can.
 	 */
 	if (node->rb_right) {
-		node =3D node->rb_right;=20
+		node =3D node->rb_right;
 		while (node->rb_left)
 			node=3Dnode->rb_left;
 		return (struct rb_node *)node;
@@ -517,7 +541,7 @@ struct rb_node *rb_prev(const struct rb_node *node)
 	 * as we can.
 	 */
 	if (node->rb_left) {
-		node =3D node->rb_left;=20
+		node =3D node->rb_left;
 		while (node->rb_right)
 			node=3Dnode->rb_right;
 		return (struct rb_node *)node;


--MVysiewe1KeBBovb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu1L8ACgkQ57/I7JWG
EQlocw//ZIlElHuA4AFJbBzNO+C9cHiskp2ExOOA7rK4F1YEK9OJBj5xruDzkHOo
/Tu4PRb4lfYdxrF0ojjbNlQXX4JQL7318YezV2OjCAoEdJgr6li7eQ56tUV7gyIF
rihL1jx/AK/Ado1VON9jCZX37FOmmRlw9SxyEvzGkCv0+W+SVpZSuAiXxREU6j81
hXZEK6RST90QbBjRg2zSCQMMZzosoPagGZK9ypIJ5AG2PHKDnRA+jjxfDNKZPUy6
qYbjFD12xIqtfvQkujlbzCgCcu4ImfJKVguC7IL7/UKRJU33fbF9VHcdRWjFC3NH
ZRUxXI/ydb08MAtwhmTiETDM/zuABmQbrlR0bsTJ9YcIYwPKRxnaukjcJcWPbhvH
JxE0iqWgF9kj6aDrxpf1vnH2qsAIgOvS40Pf40L+49panG/AO3X8yi/yaeE6FUTn
Qvx3QuF7zaGRTQEk9XWZcan4Sm0bPoVxbQ3zqsumqeJT9D+PW1N5KwOycrhxEZNW
iY937O3eSNT8K4LBeh9BKEvAmbWKa1nJI6Uil6OfiECqF4TICzJ7FAkLxDX6hh8t
sG6INEQcs9wVWB7iq1z6egvOHbdP5jXBRa0+bg3x132KX9coC5AJwHDqbWECzLgI
HyFJr7fz8A3tbZCgR66kuadMF0k4Jgrb++a7F7LAE5PMKSNPtkA=
=hDXX
-----END PGP SIGNATURE-----

--MVysiewe1KeBBovb--
