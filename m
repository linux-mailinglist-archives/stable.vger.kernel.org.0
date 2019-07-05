Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83DB602A2
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 10:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfGEIvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 04:51:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45625 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbfGEIvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 04:51:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 13CE621BBA;
        Fri,  5 Jul 2019 04:51:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 05 Jul 2019 04:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AxrOtU
        15ld7IVfxFkLq6UiSZHSIZ/0sxSCEN2d1pU/Y=; b=F9/0sWlTNQrgS2QeNya9kq
        vfSxTBY7224tTUbZCNp2kxkgUMDgvj9/acofE2TY0M8NoLLX/qoYbKTcUz12vY7o
        cuTnWZ4q6Wnz9GanU12dSc5/LEzCtB3eKqx30nKCnmJJTZnKNtkfSgXBpT5TzXx6
        Amqacisn0KHZJMsooWQC3+SyW58hs5pbslN/f0hZLWLC6aYG2CRMLUcOYITrXEvB
        GEHMsgPWE8kvC2TcfBs50FZZFoen8XNXTFHafQcFi5tyIJwD+SdfPQRnKlX3ZSyD
        Ds3MJIco3OFHFbSfBqz4cYr/SWOaSW6l25B8G8ULrsVUud1Qk+4GQyGA8M4xDf7A
        ==
X-ME-Sender: <xms:oA8fXRRchQNswHhCCqUkZEnzXBr-xNFAoLURMRFtbX5qFWQr_eU0iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeggddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekgedruddviedrvdegvdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:oA8fXWdWHWlqnOM_8eb6BBmsdvaQbzVL0RWUgYeeebm16EXE7ud7sw>
    <xmx:oA8fXWnqNNTyohPxnqscXvbwDFJeLUOhYogbjNqPUpIx7YR3oTxFfg>
    <xmx:oA8fXcMklFSkBhC3sbAvyNlrCwqdJmZoHPH4c-zc6FBU4zi-wuZqhw>
    <xmx:oQ8fXdRNvVz_PLIK3OvceiAKxL1y_D0bp25zsM7Jer0lA2GHMjIyvw>
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 282EA380074;
        Fri,  5 Jul 2019 04:51:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dax: Fix xarray entry association for mixed mappings" failed to apply to 4.19-stable tree
To:     jack@suse.cz, dan.j.williams@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 05 Jul 2019 10:51:41 +0200
Message-ID: <156231670118611@kroah.com>
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

From 1571c029a2ff289683ddb0a32253850363bcb8a7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 6 Jun 2019 11:10:28 +0200
Subject: [PATCH] dax: Fix xarray entry association for mixed mappings

When inserting entry into xarray, we store mapping and index in
corresponding struct pages for memory error handling. When it happened
that one process was mapping file at PMD granularity while another
process at PTE granularity, we could wrongly deassociate PMD range and
then reassociate PTE range leaving the rest of struct pages in PMD range
without mapping information which could later cause missed notifications
about memory errors. Fix the problem by calling the association /
deassociation code if and only if we are really going to update the
xarray (deassociating and associating zero or empty entries is just
no-op so there's no reason to complicate the code with trying to avoid
the calls for these cases).

Cc: <stable@vger.kernel.org>
Fixes: d2c997c0f145 ("fs, dax: use page->mapping to warn if truncate...")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/fs/dax.c b/fs/dax.c
index f74386293632..9fd908f3df32 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -728,12 +728,11 @@ static void *dax_insert_entry(struct xa_state *xas,
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+		void *old;
+
 		dax_disassociate_entry(entry, mapping, false);
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
-	}
-
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -742,7 +741,7 @@ static void *dax_insert_entry(struct xa_state *xas,
 		 * existing entry is a PMD, we will just leave the PMD in the
 		 * tree and dirty it if necessary.
 		 */
-		void *old = dax_lock_entry(xas, new_entry);
+		old = dax_lock_entry(xas, new_entry);
 		WARN_ON_ONCE(old != xa_mk_value(xa_to_value(entry) |
 					DAX_LOCKED));
 		entry = new_entry;

