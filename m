Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB86F16FC84
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgBZKv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:51:58 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:55103 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbgBZKv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:51:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CD360677;
        Wed, 26 Feb 2020 05:51:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:51:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=spdsP6
        /CSXIaj/FHzVJCwrbkIZue5gcA0aUxXV1P0yQ=; b=HwfnKUVOAtFAyzQ26UFpJ7
        gO3DbCJLHgiXL0sc/fOdrIS1TCj5EuiNnaJV95Wio9C6/p0s4FL0cznyAb2cjJ5s
        wC5zvjd63hrPq/ciLxczASHnyxky2B8QkECLdYNrVgJEE3s1wYqaLxg2uYI1C4Zv
        oM8baD8pm5Lf0cxEIqLyiHo5acJvXzqdydDssyFqtKJajJyRMfbUS2sB9vABGOGQ
        raRXULd0EaiD0L+7xAhVD/OyGaobsZSPSk73RUyizZ0sybnWJ2ZePeXiL/nKxWB2
        ri1Ki5xi46wOc2X2U0mZaIswP88rbsjwg8QXKck1uB57SmuXM7F1pGXrd9vaXefA
        ==
X-ME-Sender: <xms:zE1WXsjW7EzBF_lgbNWEcQ-vp79iG2TtVWlsURr9CgeozToQ1MowYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zE1WXpQYVJv_MztBjIX8nz4MbDijc7hagp556GryYDCGkLJQvrISqQ>
    <xmx:zE1WXvFb_nL7Q4OJwMWIc3YGE1ClIy6XKMqh3GTbEgaEogFdcpuZlg>
    <xmx:zE1WXhm1EkxFwGP410AuGZGHkJ94zoKWertgZkydGURFChBR95N8Vw>
    <xmx:zE1WXsFX4zMzk3H5UyxirJTVKahs3HqS4w5jDJe0F6uH5UGJutonTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15C3F328005A;
        Wed, 26 Feb 2020 05:51:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/nouveau/kms/gv100-: Re-set LUT after clearing for" failed to apply to 4.19-stable tree
To:     lyude@redhat.com, bskeggs@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:51:39 +0100
Message-ID: <1582714299255116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f287d3d19769b1d22cba4e51fa0487f2697713c9 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Wed, 12 Feb 2020 18:11:49 -0500
Subject: [PATCH] drm/nouveau/kms/gv100-: Re-set LUT after clearing for
 modesets

While certain modeset operations on gv100+ need us to temporarily
disable the LUT, we make the mistake of sometimes neglecting to
reprogram the LUT after such modesets. In particular, moving a head from
one encoder to another seems to trigger this quite often. GV100+ is very
picky about having a LUT in most scenarios, so this causes the display
engine to hang with the following error code:

disp: chid 1 stat 00005080 reason 5 [INVALID_STATE] mthd 0200 data
00000001 code 0000002d)

So, fix this by always re-programming the LUT if we're clearing it in a
state where the wndw is still visible, and has a XLUT handle programmed.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: facaed62b4cb ("drm/nouveau/kms/gv100: initial support")
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index 890315291b01..bb737f9281e6 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -458,6 +458,8 @@ nv50_wndw_atomic_check(struct drm_plane *plane, struct drm_plane_state *state)
 		asyw->clr.ntfy = armw->ntfy.handle != 0;
 		asyw->clr.sema = armw->sema.handle != 0;
 		asyw->clr.xlut = armw->xlut.handle != 0;
+		if (asyw->clr.xlut && asyw->visible)
+			asyw->set.xlut = asyw->xlut.handle != 0;
 		asyw->clr.csc  = armw->csc.valid;
 		if (wndw->func->image_clr)
 			asyw->clr.image = armw->image.handle[0] != 0;

