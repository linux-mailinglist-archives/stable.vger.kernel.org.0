Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A54EC8B1
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 17:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348368AbiC3PrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345538AbiC3PrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:47:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59E43CFDC
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:45:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id b7-20020a633407000000b0038413d39ca9so10608997pga.4
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5RO0h7SlkhWDtkiwNNqQKmwwaSacTT2ooCOZR2ytR38=;
        b=B1ke7mtNtv/HPLK923j2Z2xWP4TSGijSqmxaVsaCbNYyTrvp11EZzDW3PWzH4XKLBj
         xw0lX40uRNlPYK898BfeODXb65IdEevuLZ/r79g2ne2z+mayz/OwF2sJDHAUDxoLCCUL
         S6XrfOHXUbvn2VxK0n4CJbonEC/cyCO6zI8CmLtIXPYPtMpCp4Udp7LtL/Dowux1fvSO
         uRonU0R2/3f4KWiC06+NBu9T8Wm3fP6UBkoOsgo54CQm0GzAZMcd+yDAhpnjbG0O4lVg
         a/OanRhwW9Nw+VDNNYIOSDWwZ/cIyMToKtGaEVF6TcHfb/FFvjYDOoaeGFXH15y0y8MJ
         cThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5RO0h7SlkhWDtkiwNNqQKmwwaSacTT2ooCOZR2ytR38=;
        b=MB0JwM8WC4Ls0bU/xXD7gX+TesZU34NjIvzxUf6Smwcr3Jwma3b7q0lUDT2TsCgpTv
         ppXIHnapQMqKam89HYw5ip/nv7CQWNVQgpADoRblB+2TzZWObKaaKWrPuGUSQ8mDJ7gJ
         lU/au9LMmFL0ZRAZnYDcGG3xiWo0OxQyOhzj1owZqC6BRbeJWT9VZf2oluJ2gURPbmoP
         Gu5kqMhJPxLYcTr594PCH8CY/s+wyxlyvB9phPJFLwE3hlG73erftg/s2N+ORO0uRFu7
         ZVK1hfoppjCdXuS+WI46wOOq0FMIKy0tzuH3JVkqB5UExc+xiMOKM0tClFc/HuRUv9+z
         +B6w==
X-Gm-Message-State: AOAM531jjFuE+PVdPVXGT1Ek6xEmOtMhu85YRkEKpu3yXedwuLbrwqIG
        55gevheH/K+do5z98npFPmmNNeMv6HOiCdSh9j41OQ1SnKwZmfsJxpUe7ej8NtqfiSb6SakPABE
        uDyzrMdCklxTTeG8oA3rXfG5os+XTXRR8Z2/rGvfvDQsnadMf/ohnZwKGWIxr2BF/
X-Google-Smtp-Source: ABdhPJyE25k/5jeT/3MRwPZxLUDWH2qfbV8M9RCP7ZbnIUyG1Uq5SzmCBlmMkX0MDWwlaTixPBEyJCT10xG7
X-Received: from zokeefe3.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1b6])
 (user=zokeefe job=sendgmr) by 2002:a63:2d07:0:b0:381:e49:ae0c with SMTP id
 t7-20020a632d07000000b003810e49ae0cmr6643967pgt.261.1648655123225; Wed, 30
 Mar 2022 08:45:23 -0700 (PDT)
Date:   Wed, 30 Mar 2022 08:45:04 -0700
Message-Id: <20220330154505.3761706-1-zokeefe@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v4.14 v4.19] fuse: fix pipe buffer lifetime for direct_io
From:   "Zach O'Keefe" <zokeefe@google.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, khazhy@google.com,
        Miklos Szeredi <mszeredi@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Zach O'Keefe" <zokeefe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 0c4bcfdecb1ac0967619ee7ff44871d93c08c909 upstream.

In FOPEN_DIRECT_IO mode, fuse_file_write_iter() calls
fuse_direct_write_iter(), which normally calls fuse_direct_io(), which then
imports the write buffer with fuse_get_user_pages(), which uses
iov_iter_get_pages() to grab references to userspace pages instead of
actually copying memory.

On the filesystem device side, these pages can then either be read to
userspace (via fuse_dev_read()), or splice()d over into a pipe using
fuse_dev_splice_read() as pipe buffers with &nosteal_pipe_buf_ops.

This is wrong because after fuse_dev_do_read() unlocks the FUSE request,
the userspace filesystem can mark the request as completed, causing write()
to return. At that point, the userspace filesystem should no longer have
access to the pipe buffer.

Fix by copying pages coming from the user address space to new pipe
buffers.

Reported-by: Jann Horn <jannh@google.com>
Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Zach O'Keefe <zokeefe@google.com>

---
Applies against stable-v4.14 and stable-v4.19

struct fuse_args hasn't been piped through relevant functions yet, so
place user_pages flag in an empty hole in struct fuse_req instead.

 fs/fuse/dev.c    | 12 +++++++++++-
 fs/fuse/file.c   |  1 +
 fs/fuse/fuse_i.h |  2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index db7d746633cf..1c98b5b7bead 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -991,7 +991,17 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
-			return fuse_ref_page(cs, page, offset, count);
+			/*
+			 * Can't control lifetime of pipe buffers, so always
+			 * copy user pages.
+			 */
+			if (cs->req->user_pages) {
+				err = fuse_copy_fill(cs);
+				if (err)
+					return err;
+			} else {
+				return fuse_ref_page(cs, page, offset, count);
+			}
 		} else if (!cs->len) {
 			if (cs->move_pages && page &&
 			    offset == 0 && count == PAGE_SIZE) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5f5da2911cea..a32b2ca3de6f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1325,6 +1325,7 @@ static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	req->user_pages = true;
 	if (write)
 		req->in.argpages = 1;
 	else
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index fac1f08dd32e..30fdede2ea64 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -312,6 +312,8 @@ struct fuse_req {
 	/** refcount */
 	refcount_t count;
 
+	bool user_pages;
+
 	/** Unique ID for the interrupt request */
 	u64 intr_unique;
 
-- 
2.35.1.1021.g381101b075-goog

