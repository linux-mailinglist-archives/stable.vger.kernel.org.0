Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEC3635956
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbiKWKKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiKWKI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:08:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992A3116ABF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51A4FB81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E542C433D6;
        Wed, 23 Nov 2022 09:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197533;
        bh=BZLk6TBdkxn7IMvOdJn9b87NyszZT6B4IlHlLp+DYQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13QyDSDll7kqAm7IwhFgZZhnBHjvidZJUfFaWXeCTuAbI+sJ1rMUBBVOCdsvgX7bb
         vrCW/m/X+pTYWE3515UrBuZYfat5c7stpe4r0qa+H4Ugwn0pTV2GYGt9hddQk/AwHA
         kb546Af5E35q7jWLidBPXKIGzr2xQH6heK0XMnEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 309/314] mm: fs: initialize fsdata passed to write_begin/write_end interface
Date:   Wed, 23 Nov 2022 09:52:34 +0100
Message-Id: <20221123084639.574841655@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

commit 1468c6f4558b1bcd92aa0400f2920f9dc7588402 upstream.

Functions implementing the a_ops->write_end() interface accept the `void
*fsdata` parameter that is supposed to be initialized by the corresponding
a_ops->write_begin() (which accepts `void **fsdata`).

However not all a_ops->write_begin() implementations initialize `fsdata`
unconditionally, so it may get passed uninitialized to a_ops->write_end(),
resulting in undefined behavior.

Fix this by initializing fsdata with NULL before the call to
write_begin(), rather than doing so in all possible a_ops implementations.

This patch covers only the following cases found by running x86 KMSAN
under syzkaller:

 - generic_perform_write()
 - cont_expand_zero() and generic_cont_expand_simple()
 - page_symlink()

Other cases of passing uninitialized fsdata may persist in the codebase.

Link: https://lkml.kernel.org/r/20220915150417.722975-43-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/buffer.c  |    4 ++--
 fs/namei.c   |    2 +-
 mm/filemap.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2352,7 +2352,7 @@ int generic_cont_expand_simple(struct in
 	struct address_space *mapping = inode->i_mapping;
 	const struct address_space_operations *aops = mapping->a_ops;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 
 	err = inode_newsize_ok(inode, size);
@@ -2378,7 +2378,7 @@ static int cont_expand_zero(struct file
 	const struct address_space_operations *aops = mapping->a_ops;
 	unsigned int blocksize = i_blocksize(inode);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	pgoff_t index, curidx;
 	loff_t curpos;
 	unsigned zerofrom, offset, len;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5088,7 +5088,7 @@ int page_symlink(struct inode *inode, co
 	const struct address_space_operations *aops = mapping->a_ops;
 	bool nofs = !mapping_gfp_constraint(mapping, __GFP_FS);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 	unsigned int flags;
 
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3712,7 +3712,7 @@ ssize_t generic_perform_write(struct kio
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
-		void *fsdata;
+		void *fsdata = NULL;
 
 		offset = (pos & (PAGE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_SIZE - offset,


