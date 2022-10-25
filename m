Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35060D37A
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 20:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiJYSV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 14:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiJYSV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 14:21:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA4FDD8A7
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 11:21:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y65-20020a25c844000000b006bb773548d5so12576342ybf.5
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 11:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PjNoCfBC/CKwMAwiLtsnaqEW9HWbqcvaYiZFCHqhX1A=;
        b=cUt63EGPJ5XLXHEiRR83p6e5nk3wF+EccI3J2Nj4Hz7sd+o45EdjHmClaVdJS7D6Qt
         SRVj8/gV7ow6GDJ8o9U0wqDQuR4bhJD648XzGLZIF6bPN1Sdx3E6Rg7CDPlZWdwOkQgp
         AldXSSSnsZD7zLMgOdb0Vfa/h8JHe098M+X4gSZKtZWQWp5p15UcDWhAiMMLrjUjhkcY
         KC0eBsTNKsCRaOvTdGIHQ6ESz+Ix1YWpg7YnPKEM4Ti4Gz2qXJY47W47EziC/8C/dDfo
         8xbZi5AbaDJ/hjFTwNPbJswDGS8yutCtZxwos1qagpx/I6fIYQdakdLMhuiTDm8H//iZ
         9INg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PjNoCfBC/CKwMAwiLtsnaqEW9HWbqcvaYiZFCHqhX1A=;
        b=28ZmWye4b8vYFPABraOONGo+YBybd2ccKY67pnJWJuIb/RveyYDVlVXOLnePCr5sMn
         2C+JD7MmKDsFPWT2NerotDC5OaQSts09okJC9bx3ks/amCCVfdnU23VhIrfEr3PY1eYu
         s9dzB6unv16hsc1owajvyWsEGZiiaI4Z/6j5xSL7sqm2RLPB6/egDurYnpRAYWBNKQbx
         CudntEJU1OzZKQiZjRz0N5gAOjBCS4jTUhs97MJbQIfmOgIdyHOZeHl1fbUW6w9qY029
         820M3ZCuxSlM3u4C6EqFg/YGgA7dtbwvC7G2ScahduIHIKAsLNxuFXJJp2LH56B+mGc0
         WUJQ==
X-Gm-Message-State: ACrzQf3uG+qkXRzMTunvrJFEBp5bdKj+GXmFW9TDfOm+sxMgPyRGFlQ2
        RxgMXYGXK9sof9OVCrdszI+D/9rKYQzWx30TOOJ6
X-Google-Smtp-Source: AMsMyM4O87oXuKbv1CK6ykDEbUdHUhv03vaFJfj6qvi2cGjc27L1Ng0hWt6v43WJjuwTFmjgJpiMHYC0BIw0H/MfKP8n
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2d4:203:9558:df20:7923:f362])
 (user=axelrasmussen job=sendgmr) by 2002:a0d:cc51:0:b0:36c:98b0:dc38 with
 SMTP id o78-20020a0dcc51000000b0036c98b0dc38mr12308042ywd.275.1666722115408;
 Tue, 25 Oct 2022 11:21:55 -0700 (PDT)
Date:   Tue, 25 Oct 2022 11:21:49 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221025182149.3076870-1-axelrasmussen@google.com>
Subject: [PATCH] userfaultfd: wake on unregister for minor faults as well as missing
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This was an overlooked edge case when minor faults were added. In
general, minor faults have the same rough edge here as missing faults:
if we unregister while there are waiting threads, they will just remain
waiting forever, as there is no way for userspace to wake them after
unregistration. To work around this, userspace needs to carefully wake
everything before unregistering.

So, wake for minor faults just like we already do for missing faults as
part of the unregistration process.

Cc: stable@vger.kernel.org
Fixes: 7677f7fd8be7 ("userfaultfd: add minor fault registration mode")
Reported-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 fs/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 07c81ab3fd4d..7daee4b9481c 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1606,7 +1606,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
-		if (userfaultfd_missing(vma)) {
+		if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
 			/*
 			 * Wake any concurrent pending userfault while
 			 * we unregister, so they will not hang
-- 
2.38.0.135.g90850a2211-goog

