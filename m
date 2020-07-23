Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2A22AC80
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 12:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGWK0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 06:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgGWK0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 06:26:04 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE1E206C1;
        Thu, 23 Jul 2020 10:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595499963;
        bh=0DOHNa/dupmS60QeduJc4gJNCjsD8OO86agX2wJYn/s=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=zuUSYFGHysPdbahMtErdQXJVuv55NJ5rZZ/IMhpXEEnA81JpwA78eXdnhQ4jM/Evu
         j2eDMj17JhFVAnzlI64IiHDgBCQjcjYomeZBdw/cLqnhBm0NQ1MuVifcnyHuT2YaA+
         9HNEd2euy1GxXVrqI3SPUTQjeVvllsuz6/qjFjyU=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CA+G9fYte5U-D7fqps2qJga_LSuGrb6t9Y1rOvPCPzz46BwchyA@mail.gmail.com>
References: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com> <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com> <159549159798.3847286.18202724980881020289@swboyd.mtv.corp.google.com> <CA+G9fYte5U-D7fqps2qJga_LSuGrb6t9Y1rOvPCPzz46BwchyA@mail.gmail.com>
Subject: Re: stable-rc 4.14: arm64: Internal error: Oops: clk_reparent __clk_set_parent_before on db410c
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        linux- stable <stable@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Clark <robdclark@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        samuel@sholland.org
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Jul 2020 03:26:02 -0700
Message-ID: <159549996283.3847286.2480782726716664105@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Naresh Kamboju (2020-07-23 03:10:37)
> On Thu, 23 Jul 2020 at 13:36, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Quoting Arnd Bergmann (2020-07-21 02:51:32)
> > >                         __clk_set_parent_before(orphan, parent);
> > >
> > > None of the above have changed in stable kernels.
> > >
> > > > [    5.633668]  pll_28nm_register+0xa4/0x340 [msm]
> > > > [    5.637492]  msm_dsi_pll_28nm_init+0xc8/0x1d8 [msm]
> > > > [    5.642007]  msm_dsi_pll_init+0x34/0xe0 [msm]
> > > > [    5.646870]  dsi_phy_driver_probe+0x1cc/0x310 [msm]
> > >
> > > The only changes to the dsi driver in v4.14-stable were:
> > >
> > > 89e30bb46074 drm/msm/dsi: save pll state before dsi host is powered o=
ff
> > > 892afde0f4a1 drm: msm: Fix return type of dsi_mgr_connector_mode_vali=
d for kCFI
> > > 35ff594b0da2 drm/msm/dsi: Implement reset correctly
> > > 5151a0c8d730 drm/msm/dsi: use correct enum in dsi_get_cmd_fmt
> > > e6bc3a4b0c23 clk: divider: fix incorrect usage of container_of
> > >
> > > None of these look suspicious to me.
> > >
> >
> > It sounds like maybe you need this patch?
> >
> > bdcf1dc25324 ("clk: Evict unregistered clks from parent caches")
>=20
> Cherry-pick did not work on stable-rc 4.14
> this patch might need backporting.
> I am not sure.
>=20

Ok. That commit fixes a regression in the 3.x series of the kernel so it
should go back to any LTS kernels. It looks like at least on 4.14 it's a
trivial conflict. Here's a backport to 4.14

---8<---
From: Stephen Boyd <sboyd@kernel.org>
Date: Wed, 28 Aug 2019 11:19:59 -0700
Subject: [PATCH] clk: Evict unregistered clks from parent caches

We leave a dangling pointer in each clk_core::parents array that has an
unregistered clk as a potential parent when that clk_core pointer is
freed by clk{_hw}_unregister(). It is impossible for the true parent of
a clk to be set with clk_set_parent() once the dangling pointer is left
in the cache because we compare parent pointers in
clk_fetch_parent_index() instead of checking for a matching clk name or
clk_hw pointer.

Before commit ede77858473a ("clk: Remove global clk traversal on fetch
parent index"), we would check clk_hw pointers, which has a higher
chance of being the same between registration and unregistration, but it
can still be allocated and freed by the clk provider. In fact, this has
been a long standing problem since commit da0f0b2c3ad2 ("clk: Correct
lookup logic in clk_fetch_parent_index()") where we stopped trying to
compare clk names and skipped over entries in the cache that weren't
NULL.

There are good (performance) reasons to not do the global tree lookup in
cases where the cache holds dangling pointers to parents that have been
unregistered. Let's take the performance hit on the uncommon
registration path instead. Loop through all the clk_core::parents arrays
when a clk is unregistered and set the entry to NULL when the parent
cache entry and clk being unregistered are the same pointer. This will
fix this problem and avoid the overhead for the "normal" case.

Based on a patch by Bjorn Andersson.

Fixes: da0f0b2c3ad2 ("clk: Correct lookup logic in clk_fetch_parent_index()=
")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190828181959.204401-1-sboyd@kernel.org
---
 drivers/clk/clk.c | 52 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 44b6f23cc851..4289c519af1b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -39,6 +39,17 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
=20
+static struct hlist_head *all_lists[] =3D {
+	&clk_root_list,
+	&clk_orphan_list,
+	NULL,
+};
+
+static struct hlist_head *orphan_list[] =3D {
+	&clk_orphan_list,
+	NULL,
+};
+
 /***    private data structures    ***/
=20
 struct clk_core {
@@ -1993,17 +2004,6 @@ static int inited =3D 0;
 static DEFINE_MUTEX(clk_debug_lock);
 static HLIST_HEAD(clk_debug_list);
=20
-static struct hlist_head *all_lists[] =3D {
-	&clk_root_list,
-	&clk_orphan_list,
-	NULL,
-};
-
-static struct hlist_head *orphan_list[] =3D {
-	&clk_orphan_list,
-	NULL,
-};
-
 static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
 				 int level)
 {
@@ -2735,6 +2735,34 @@ static const struct clk_ops clk_nodrv_ops =3D {
 	.set_parent	=3D clk_nodrv_set_parent,
 };
=20
+static void clk_core_evict_parent_cache_subtree(struct clk_core *root,
+						struct clk_core *target)
+{
+	int i;
+	struct clk_core *child;
+
+	for (i =3D 0; i < root->num_parents; i++)
+		if (root->parents[i] =3D=3D target)
+			root->parents[i] =3D NULL;
+
+	hlist_for_each_entry(child, &root->children, child_node)
+		clk_core_evict_parent_cache_subtree(child, target);
+}
+
+/* Remove this clk from all parent caches */
+static void clk_core_evict_parent_cache(struct clk_core *core)
+{
+	struct hlist_head **lists;
+	struct clk_core *root;
+
+	lockdep_assert_held(&prepare_lock);
+
+	for (lists =3D all_lists; *lists; lists++)
+		hlist_for_each_entry(root, *lists, child_node)
+			clk_core_evict_parent_cache_subtree(root, core);
+
+}
+
 /**
  * clk_unregister - unregister a currently registered clock
  * @clk: clock to unregister
@@ -2773,6 +2801,8 @@ void clk_unregister(struct clk *clk)
 			clk_core_set_parent(child, NULL);
 	}
=20
+	clk_core_evict_parent_cache(clk->core);
+
 	hlist_del_init(&clk->core->child_node);
=20
 	if (clk->core->prepare_count)
--=20
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
