Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A8310930C
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfKYRop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:44:45 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39571 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbfKYRoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:44:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E181422764;
        Mon, 25 Nov 2019 12:44:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fmf76T
        ZYGu/Jhqjs5HxCHMg4plKtPUTgqkBU7UKODtk=; b=i4EgGKh2XlpKKrGVcjvaBO
        7aJ/2a6sPc5Hh1Bsw8slBw8t4jG52vKy9v9RFqhJDss1VzHoF0P2myTXwemzB6NB
        tBlzbQpkzbonPZrdb3sWjW9dS+8+WGYpPl+HQVR1GztVixMjHoQlrbv1uZysmgE7
        3Byb7vTaXQr7YgHGsd/y96BLyw5KkUSWUJ5ejwOP+n6+4KsCX/CMImf36mD5Db2V
        QWghXqVsF6EVZt8uYMAX6nu82MVI2JYGPB55x/BXo++pP4f7rTpo7IkmL4Qk0FlE
        1dWs/BhwvNy0P6SP4jM8oxud7SwKeS0O3z948TLTUIl9rv/7BvpLLdZaPaWudXdw
        ==
X-ME-Sender: <xms:CxPcXTni87cm0sxf7m-pp-4Fa7bqXDIzw9ESsYJxKqnhYmzPYSsrgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:CxPcXSO7jwdCI3FmYvmvq0jso_bRSSonIZhrUbH1C6ozgQxOaBoc4A>
    <xmx:CxPcXXYiAEjXIKPoNccBCbeUjHFQrBJkXIX1Yp4yAIVXXniQLzVlSg>
    <xmx:CxPcXSHn-622pHekrvosh1oLZMpnzDHo000tafeyLxw7DSFqHInSUg>
    <xmx:CxPcXarNQ00LTv4skDEg5ahxwFzemB5-kT_v1syjaOLOS-fGLqbLcQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58607306005F;
        Mon, 25 Nov 2019 12:44:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio_balloon: fix shrinker count" failed to apply to 4.19-stable tree
To:     wei.w.wang@intel.com, david@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:44:42 +0100
Message-ID: <1574703882140153@kroah.com>
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

From c9a6820fc0da2603be3054ee7590eb9f350508a7 Mon Sep 17 00:00:00 2001
From: Wei Wang <wei.w.wang@intel.com>
Date: Tue, 19 Nov 2019 05:02:33 -0500
Subject: [PATCH] virtio_balloon: fix shrinker count

Instead of multiplying by page order, virtio balloon divided by page
order. The result is that it can return 0 if there are a bit less
than MAX_ORDER - 1 pages in use, and then shrinker scan won't be called.

Cc: stable@vger.kernel.org
Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 51134f9a3ee7..e05679c478e2 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -826,7 +826,7 @@ static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
 	unsigned long count;
 
 	count = vb->num_pages / VIRTIO_BALLOON_PAGES_PER_PAGE;
-	count += vb->num_free_page_blocks >> VIRTIO_BALLOON_FREE_PAGE_ORDER;
+	count += vb->num_free_page_blocks << VIRTIO_BALLOON_FREE_PAGE_ORDER;
 
 	return count;
 }

