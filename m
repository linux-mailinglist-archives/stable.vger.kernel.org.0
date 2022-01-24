Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47742498BCD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241467AbiAXTQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:16:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42282 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346371AbiAXTMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04975611DA;
        Mon, 24 Jan 2022 19:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF88DC340E7;
        Mon, 24 Jan 2022 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051558;
        bh=an8wbRIoUSTqX7geJnMl5kKqR7w6jg1m7eh6WjdnOt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9rtlf9f5EZNvqpC7xK99ydPyWUKwupqVSoyyTB3mYNjCkD/ObaHn06ia7fPeOQ5o
         XX6p3w7afWuJ8NflCO1dMpL+q6nbIDo95q2O9HuciNzdcd2hOUANHE5FcZCdTDQuhh
         SUouzQR8Cp5veKi5CSciS4hg+ELljzGwCmRhcplg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 4.19 014/239] orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()
Date:   Mon, 24 Jan 2022 19:40:52 +0100
Message-Id: <20220124183943.568589736@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -179,7 +179,7 @@ orangefs_bufmap_free(struct orangefs_buf
 {
 	kfree(bufmap->page_array);
 	kfree(bufmap->desc_array);
-	kfree(bufmap->buffer_index_array);
+	bitmap_free(bufmap->buffer_index_array);
 	kfree(bufmap);
 }
 
@@ -229,8 +229,7 @@ orangefs_bufmap_alloc(struct ORANGEFS_de
 	bufmap->desc_size = user_desc->size;
 	bufmap->desc_shift = ilog2(bufmap->desc_size);
 
-	bufmap->buffer_index_array =
-		kzalloc(DIV_ROUND_UP(bufmap->desc_count, BITS_PER_LONG), GFP_KERNEL);
+	bufmap->buffer_index_array = bitmap_zalloc(bufmap->desc_count, GFP_KERNEL);
 	if (!bufmap->buffer_index_array)
 		goto out_free_bufmap;
 
@@ -253,7 +252,7 @@ orangefs_bufmap_alloc(struct ORANGEFS_de
 out_free_desc_array:
 	kfree(bufmap->desc_array);
 out_free_index_array:
-	kfree(bufmap->buffer_index_array);
+	bitmap_free(bufmap->buffer_index_array);
 out_free_bufmap:
 	kfree(bufmap);
 out:


