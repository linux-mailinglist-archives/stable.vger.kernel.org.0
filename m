Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF50492A39
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346474AbiARQIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346472AbiARQHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:07:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B918CC061747;
        Tue, 18 Jan 2022 08:07:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18FB0CE1A36;
        Tue, 18 Jan 2022 16:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E737FC00446;
        Tue, 18 Jan 2022 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522057;
        bh=bKimfoQ1gskIREFUdIgvDX+yOxQ8Y2Lm3TDY/b8xxzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZOZMY4TfrXtA1bprCX53GXoAK3/j/VK3MyAbIwiNVKU09CYC7X2k1OBeLizjzpWJ
         dG8/FnJC59L9wG7FkhN5YuxhD6Ktv13cNUrtquTLnGNf3f7BNYfj2Qm09qPaMLwiQz
         koYGtiZMnuCAU0++eVDmL0oq2K3P5s4IEDqq1z/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 5.10 03/23] orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()
Date:   Tue, 18 Jan 2022 17:05:43 +0100
Message-Id: <20220118160451.359902371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 40a74870b2d1d3d44e13b3b73c6571dd34f5614d upstream.

'buffer_index_array' really looks like a bitmap. So it should be allocated
as such.
When kzalloc is called, a number of bytes is expected, but a number of
longs is passed instead.

In get(), if not enough memory is allocated, un-allocated memory may be
read or written.

So use bitmap_zalloc() to safely allocate the correct memory size and
avoid un-expected behavior.

While at it, change the corresponding kfree() into bitmap_free() to keep
the semantic.

Fixes: ea2c9c9f6574 ("orangefs: bufmap rewrite")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/orangefs-bufmap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/orangefs/orangefs-bufmap.c
+++ b/fs/orangefs/orangefs-bufmap.c
@@ -176,7 +176,7 @@ orangefs_bufmap_free(struct orangefs_buf
 {
 	kfree(bufmap->page_array);
 	kfree(bufmap->desc_array);
-	kfree(bufmap->buffer_index_array);
+	bitmap_free(bufmap->buffer_index_array);
 	kfree(bufmap);
 }
 
@@ -226,8 +226,7 @@ orangefs_bufmap_alloc(struct ORANGEFS_de
 	bufmap->desc_size = user_desc->size;
 	bufmap->desc_shift = ilog2(bufmap->desc_size);
 
-	bufmap->buffer_index_array =
-		kzalloc(DIV_ROUND_UP(bufmap->desc_count, BITS_PER_LONG), GFP_KERNEL);
+	bufmap->buffer_index_array = bitmap_zalloc(bufmap->desc_count, GFP_KERNEL);
 	if (!bufmap->buffer_index_array)
 		goto out_free_bufmap;
 
@@ -250,7 +249,7 @@ orangefs_bufmap_alloc(struct ORANGEFS_de
 out_free_desc_array:
 	kfree(bufmap->desc_array);
 out_free_index_array:
-	kfree(bufmap->buffer_index_array);
+	bitmap_free(bufmap->buffer_index_array);
 out_free_bufmap:
 	kfree(bufmap);
 out:


