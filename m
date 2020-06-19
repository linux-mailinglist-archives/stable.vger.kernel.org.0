Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEF2200A38
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgFSNdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:33:36 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:54405 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgFSNdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:33:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B66419455A0;
        Fri, 19 Jun 2020 09:33:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YR4GgX
        6R94nSZii7hVShSZLxh4eLaAPd/DTLvPR8BuU=; b=uSjVpCcbJiaUVt6ocZH0gj
        +Phe5flefgoXXJFoWyCXbTN0wRXv1E77H5mkB80F7UzyLUtjK0okDCcbHMWZ7DZx
        MzulOofSosBgppuBxOTZYT5jKKsGdzyR8pdS8+KEZVbx3lUaEKrPMDdQbjf8+C1l
        CINrRQXCmineL8qMuh4El1sLQjSjIw3M6leUvJNzXIX9965C+SXfwbER3p1eRSW2
        OxkszUo4N6dhxKtW5QapCgnrPYRwLDIPCd4C3IMGTaNuoJrPnhY7rbAKRqzJrbdU
        me4wmMV62Nf13Dy1pwy2xs6AEBJQ0scmigySweN4rQ1tq62HUitnD5dSm551AB9A
        ==
X-ME-Sender: <xms:rr7sXpa_derqPPWe6Vk9_1N5-yXyOOy5VEmCvBWfUjFNSZCZpX8v6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:rr7sXgZzgZjXMfZE0kGnpxPLOGF6jCnacLlE4OKe1o35OCKE6TU8hg>
    <xmx:rr7sXr-1XXEIH_-FYitSWMqY0sKAgPODodHz9hcQk83I46Tbt4lLkg>
    <xmx:rr7sXnpoJ-ncBu-5UODPBzUff4VzOO-KuRaKUX7HxtmVKP2pEe8_1Q>
    <xmx:rr7sXrQr3t4vPzF_wgeTUPfmtqZSzUBymoiJ3RW8-ncu2JOvMlzcgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC52A3280065;
        Fri, 19 Jun 2020 09:33:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm crypt: avoid truncating the logical block size" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:33:31 +0200
Message-ID: <159257361122324@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64611a15ca9da91ff532982429c44686f4593b5f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 4 Jun 2020 12:01:26 -0700
Subject: [PATCH] dm crypt: avoid truncating the logical block size

queue_limits::logical_block_size got changed from unsigned short to
unsigned int, but it was forgotten to update crypt_io_hints() to use the
new type.  Fix it.

Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 71c651465bdd..000ddfab5ba0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3312,7 +3312,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->max_segment_size = PAGE_SIZE;
 
 	limits->logical_block_size =
-		max_t(unsigned short, limits->logical_block_size, cc->sector_size);
+		max_t(unsigned, limits->logical_block_size, cc->sector_size);
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);

