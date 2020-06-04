Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFBF1EDFEF
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 10:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgFDInH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 04:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgFDInG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 04:43:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3436C05BD1E
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 01:43:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y189so7291013ybc.14
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 01:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nlkXKlWFIYxfLs04PG1x7XFTLy1mblGWjCOyvzYPXHU=;
        b=UJ000Iqf10R44YN/3kxhUlycYRN3yTnbTPlNipV0FMnYH1WGgQJvc5zN3Nk0OjO4Ld
         5T0tJ2LHLrmGgJKTROWQE9w/K78/dLjh7hli7SJKaFrvmA8b/GmXCz0362vT++gHxfom
         eRvn2BoC/u5TmF7qNpNLlfDPnIQD+kSlg1DAVCn0SsIYY4TNoFrwvvC+zV09RFUMrfQz
         ctSx5F8TwpDkyk0NVPjl42bIm3H+6Ycve7PwXopqqNChdbqTKxxlyNdlcTE4PEnz7u7W
         seTSmJSDOo+nfpqYiAFrJDtWCI8E8FnnB1hyOn9QOKoxgMCrYNFz20q/lD/PTDzmxTPK
         4jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nlkXKlWFIYxfLs04PG1x7XFTLy1mblGWjCOyvzYPXHU=;
        b=RjepkU+lFpiqZoJt3asOsBhpBQMKY/BSEG1CaxfKEpM/MBBW/9E+c5nCgY1hIZd6xY
         APKOZop8hUep5yCLjdnuLaF4v25kEgRSFLoFpL2UlZ+n9Jxpoan49tv2AR0vCDRbUap8
         Sd/fd1e+fJb8ZZaFVkcrXUcn/kngtG1ItvWPRxuaYK9edCca1c4Al/97iOmerdMl1m8k
         iBNmzJIxOkKpmE3z+3/amjPuw6rHVnPZRiKO4FUBcIrKhNzZuzRTel+wHmHNRprKEpVw
         uyAsWm6cM/hmaxdWrJ5DJehDQik8sRJMk4UuE6u3tAAZhoTOvzs5DZ4oZ1no1gxhtbSS
         MdYA==
X-Gm-Message-State: AOAM531jElbpI2GMPMj5GmPmLZcxKySnzoV3hQT88wN6YTqQTbUaOl3i
        kC8l8FX0aN+QF7sctmUGYJBqfjle2aI=
X-Google-Smtp-Source: ABdhPJx/x3rTxyXVTfCzwPxpHuZZeyDbY0k/8MsEoTn1vhtNL6AF6homBmYHpgnkIBATuDvPKVRucxU6lT0=
X-Received: by 2002:a5b:512:: with SMTP id o18mr5703507ybp.419.1591260184074;
 Thu, 04 Jun 2020 01:43:04 -0700 (PDT)
Date:   Thu,  4 Jun 2020 10:42:45 +0200
Message-Id: <20200604084245.161480-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
Subject: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
From:   glider@google.com
To:     miklos@szeredi.hu, vgoyal@redhat.com
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, royyang@google.com, stable@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Under certain circumstances (we found this out running Docker on a
Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
return uninitialized value of |error| from ovl_copy_xattr().
It is then returned by ovl_create() to lookup_open(), which casts it to
an invalid dentry pointer, that can be further read or written by the
lookup_open() callers.

The uninitialized value is returned when all the xattr on the file
are ovl_is_private_xattr(), which is actually a successful case,
therefore we initialize |error| with 0.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Roy Yang <royyang@google.com>
Cc: <stable@vger.kernel.org> # 4.1

---

The bug seem to date back to at least v4.1 where the annotation has been
introduced (i.e. the compilers started noticing error could be used
before being initialized). I hovever didn't try to prove that the
problem is actually reproducible on such ancient kernels. We've seen it
on a real machine running v4.4 as well.

v2:
 -- Per Vivek Goyal's suggestion, changed |error| to be 0
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9709cf22cab3..07e0d1961e96 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -47,7 +47,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size, value_size = 0;
 	char *buf, *name, *value = NULL;
-	int uninitialized_var(error);
+	int error = 0;
 	size_t slen;
 
 	if (!(old->d_inode->i_opflags & IOP_XATTR) ||
-- 
2.27.0.278.ge193c7cf3a9-goog

