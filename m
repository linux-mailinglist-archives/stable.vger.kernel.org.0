Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA560461D97
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377897AbhK2S0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:26:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349599AbhK2SYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:24:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBFC1B815CF;
        Mon, 29 Nov 2021 18:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047F0C53FAD;
        Mon, 29 Nov 2021 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210090;
        bh=ZD2mWSV3ePzau/4DyXKXKwtar36HxC0s/POOFGwy+uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihU0IakHYG2G4IOOFTPHzck+aK5GVxyj+hcwUBNBVJr50drsMjWWj8nDVRgcxm0aQ
         QBsE6ZmbsFd9+ZmClyZtze8n6EdE+A4QoarGKBkFfpD89rChl5k9pW4J522duP4As8
         lmf39KmZEA/Wk/tvkyb0ecPKpfevkmBX+6mjhO4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 07/69] ALSA: ctxfi: Fix out-of-range access
Date:   Mon, 29 Nov 2021 19:17:49 +0100
Message-Id: <20211129181703.906646450@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 76c47183224c86e4011048b80f0e2d0d166f01c2 upstream.

The master and next_conj of rcs_ops are used for iterating the
resource list entries, and currently those are supposed to return the
current value.  The problem is that next_conf may go over the last
entry before the loop abort condition is evaluated, and it may return
the "current" value that is beyond the array size.  It was caught
recently as a GPF, for example.

Those return values are, however, never actually evaluated, hence
basically we don't have to consider the current value as the return at
all.  By dropping those return values, the potential out-of-range
access above is also fixed automatically.

This patch changes the return type of master and next_conj callbacks
to void and drop the superfluous code accordingly.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214985
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211118215729.26257-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctamixer.c   |   14 ++++++--------
 sound/pci/ctxfi/ctdaio.c     |   16 ++++++++--------
 sound/pci/ctxfi/ctresource.c |    7 +++----
 sound/pci/ctxfi/ctresource.h |    4 ++--
 sound/pci/ctxfi/ctsrc.c      |    7 +++----
 5 files changed, 22 insertions(+), 26 deletions(-)

--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -27,16 +27,15 @@
 
 #define BLANK_SLOT		4094
 
-static int amixer_master(struct rsc *rsc)
+static void amixer_master(struct rsc *rsc)
 {
 	rsc->conj = 0;
-	return rsc->idx = container_of(rsc, struct amixer, rsc)->idx[0];
+	rsc->idx = container_of(rsc, struct amixer, rsc)->idx[0];
 }
 
-static int amixer_next_conj(struct rsc *rsc)
+static void amixer_next_conj(struct rsc *rsc)
 {
 	rsc->conj++;
-	return container_of(rsc, struct amixer, rsc)->idx[rsc->conj];
 }
 
 static int amixer_index(const struct rsc *rsc)
@@ -335,16 +334,15 @@ int amixer_mgr_destroy(struct amixer_mgr
 
 /* SUM resource management */
 
-static int sum_master(struct rsc *rsc)
+static void sum_master(struct rsc *rsc)
 {
 	rsc->conj = 0;
-	return rsc->idx = container_of(rsc, struct sum, rsc)->idx[0];
+	rsc->idx = container_of(rsc, struct sum, rsc)->idx[0];
 }
 
-static int sum_next_conj(struct rsc *rsc)
+static void sum_next_conj(struct rsc *rsc)
 {
 	rsc->conj++;
-	return container_of(rsc, struct sum, rsc)->idx[rsc->conj];
 }
 
 static int sum_index(const struct rsc *rsc)
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -55,12 +55,12 @@ static struct daio_rsc_idx idx_20k2[NUM_
 	[SPDIFIO] = {.left = 0x05, .right = 0x85},
 };
 
-static int daio_master(struct rsc *rsc)
+static void daio_master(struct rsc *rsc)
 {
 	/* Actually, this is not the resource index of DAIO.
 	 * For DAO, it is the input mapper index. And, for DAI,
 	 * it is the output time-slot index. */
-	return rsc->conj = rsc->idx;
+	rsc->conj = rsc->idx;
 }
 
 static int daio_index(const struct rsc *rsc)
@@ -68,19 +68,19 @@ static int daio_index(const struct rsc *
 	return rsc->conj;
 }
 
-static int daio_out_next_conj(struct rsc *rsc)
+static void daio_out_next_conj(struct rsc *rsc)
 {
-	return rsc->conj += 2;
+	rsc->conj += 2;
 }
 
-static int daio_in_next_conj_20k1(struct rsc *rsc)
+static void daio_in_next_conj_20k1(struct rsc *rsc)
 {
-	return rsc->conj += 0x200;
+	rsc->conj += 0x200;
 }
 
-static int daio_in_next_conj_20k2(struct rsc *rsc)
+static void daio_in_next_conj_20k2(struct rsc *rsc)
 {
-	return rsc->conj += 0x100;
+	rsc->conj += 0x100;
 }
 
 static const struct rsc_ops daio_out_rsc_ops = {
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -113,18 +113,17 @@ static int audio_ring_slot(const struct
     return (rsc->conj << 4) + offset_in_audio_slot_block[rsc->type];
 }
 
-static int rsc_next_conj(struct rsc *rsc)
+static void rsc_next_conj(struct rsc *rsc)
 {
 	unsigned int i;
 	for (i = 0; (i < 8) && (!(rsc->msr & (0x1 << i))); )
 		i++;
 	rsc->conj += (AUDIO_SLOT_BLOCK_NUM >> i);
-	return rsc->conj;
 }
 
-static int rsc_master(struct rsc *rsc)
+static void rsc_master(struct rsc *rsc)
 {
-	return rsc->conj = rsc->idx;
+	rsc->conj = rsc->idx;
 }
 
 static const struct rsc_ops rsc_generic_ops = {
--- a/sound/pci/ctxfi/ctresource.h
+++ b/sound/pci/ctxfi/ctresource.h
@@ -43,8 +43,8 @@ struct rsc {
 };
 
 struct rsc_ops {
-	int (*master)(struct rsc *rsc);	/* Move to master resource */
-	int (*next_conj)(struct rsc *rsc); /* Move to next conjugate resource */
+	void (*master)(struct rsc *rsc); /* Move to master resource */
+	void (*next_conj)(struct rsc *rsc); /* Move to next conjugate resource */
 	int (*index)(const struct rsc *rsc); /* Return the index of resource */
 	/* Return the output slot number */
 	int (*output_slot)(const struct rsc *rsc);
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -594,16 +594,15 @@ int src_mgr_destroy(struct src_mgr *src_
 
 /* SRCIMP resource manager operations */
 
-static int srcimp_master(struct rsc *rsc)
+static void srcimp_master(struct rsc *rsc)
 {
 	rsc->conj = 0;
-	return rsc->idx = container_of(rsc, struct srcimp, rsc)->idx[0];
+	rsc->idx = container_of(rsc, struct srcimp, rsc)->idx[0];
 }
 
-static int srcimp_next_conj(struct rsc *rsc)
+static void srcimp_next_conj(struct rsc *rsc)
 {
 	rsc->conj++;
-	return container_of(rsc, struct srcimp, rsc)->idx[rsc->conj];
 }
 
 static int srcimp_index(const struct rsc *rsc)


