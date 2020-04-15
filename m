Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC61A9BB6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896731AbgDOLFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:05:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44853 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408840AbgDOLDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:03:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 804095C0130;
        Wed, 15 Apr 2020 07:03:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uCaHUu
        2QCAgaOqH6cRlM5XnrilemGF+kZYaSjuizxwM=; b=4hDuLIyGXr1jVeWjn6COOm
        RnY56eI8R93XD4ULz/i8p+cgSq4DOAdDHvr8s3uRmw/iXSj4Y2wnhxluv7fKH/K9
        pAQuSzVYVFb/1XfvfPstYebN0SF3JYV5aSKPUMcQO66OhXkk1taQgylxWP+ryK+d
        0k3S35UXYCZKtCv2Qu8fdegviPE4gdz+vmitPISRplKpM8bfRCGZZJtpkr4WUnMe
        TTmnhjMDECUtDeJYXzyVSP+Vk9zsTk/5ynnAeFAMUh6hqtQRJatbp1XjEEbEb6Rn
        4rbvyTmMZbWmftIPh52nzSYibWzTYrAcx+y5K1TyGRJKqquWi1dtxCP3Y7M/N2GA
        ==
X-ME-Sender: <xms:DeqWXnJvrmtXRuG3PWUITMwvCwsY1asGfwR4nYpv-YThEi00pGhIHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DeqWXhni5TkfKYOEG6ASsLL7MUbiR32xBEgiRe2ikw7XhmYfKu2G5A>
    <xmx:DeqWXojxPhs_MaoFq-98hp-l1RbplsXDngDTQOME3zdLsEZ7PG3FzQ>
    <xmx:DeqWXvr63DAQaxhyjmPSwRqmceK3Ac7PrnhzUJMAQt67rCHMs14nfQ>
    <xmx:DeqWXq2-dh0my-myLeSc35ho28H5tOVMe4P9P3R7fa_zOUw4PutS1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC33F3060060;
        Wed, 15 Apr 2020 07:03:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm clone: Add missing casts to prevent overflows and data" failed to apply to 5.4-stable tree
To:     ntsironis@arrikto.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:03:39 +0200
Message-ID: <15869486198643@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fc06ff56845cc5ccafec52f545fc2e08d22f849 Mon Sep 17 00:00:00 2001
From: Nikos Tsironis <ntsironis@arrikto.com>
Date: Fri, 27 Mar 2020 16:01:10 +0200
Subject: [PATCH] dm clone: Add missing casts to prevent overflows and data
 corruption

Add missing casts when converting from regions to sectors.

In case BITS_PER_LONG == 32, the lack of the appropriate casts can lead
to overflows and miscalculation of the device sector.

As a result, we could end up discarding and/or copying the wrong parts
of the device, thus corrupting the device's data.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 6ee85fb3388a..ca5020c58f7c 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -282,7 +282,7 @@ static bool bio_triggers_commit(struct clone *clone, struct bio *bio)
 /* Get the address of the region in sectors */
 static inline sector_t region_to_sector(struct clone *clone, unsigned long region_nr)
 {
-	return (region_nr << clone->region_shift);
+	return ((sector_t)region_nr << clone->region_shift);
 }
 
 /* Get the region number of the bio */
@@ -471,7 +471,7 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
 	if (test_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags) && success) {
 		remap_to_dest(clone, bio);
 		bio_region_range(clone, bio, &rs, &nr_regions);
-		trim_bio(bio, rs << clone->region_shift,
+		trim_bio(bio, region_to_sector(clone, rs),
 			 nr_regions << clone->region_shift);
 		generic_make_request(bio);
 	} else
@@ -804,11 +804,14 @@ static void hydration_copy(struct dm_clone_region_hydration *hd, unsigned int nr
 	struct dm_io_region from, to;
 	struct clone *clone = hd->clone;
 
+	if (WARN_ON(!nr_regions))
+		return;
+
 	region_size = clone->region_size;
 	region_start = hd->region_nr;
 	region_end = region_start + nr_regions - 1;
 
-	total_size = (nr_regions - 1) << clone->region_shift;
+	total_size = region_to_sector(clone, nr_regions - 1);
 
 	if (region_end == clone->nr_regions - 1) {
 		/*

