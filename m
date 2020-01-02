Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D239412F0F0
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgABW4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgABWRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8A6422314;
        Thu,  2 Jan 2020 22:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003464;
        bh=cB4IX+UJzd1OLwcNmkie+J4gIlrd3T4EWRRZqLEQPyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8icWJQmSpV9naIY47ALjVsXLTOc9UMKDrWVaJDsj6z4efQgYC7//IpzIwiGkk1fn
         GxRQKAKdyNFKAU5ikM9WzKC6U3eF/lF8rrClwnxvYwoLLMNWR6K8XOxUeBir7jP8GY
         KoEqXWAuwrwPPtReR/yCU1BsZ7cz85lMIa9+2tew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 145/191] drm: limit to INT_MAX in create_blob ioctl
Date:   Thu,  2 Jan 2020 23:07:07 +0100
Message-Id: <20200102215845.053049824@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 5bf8bec3f4ce044a223c40cbce92590d938f0e9c upstream.

The hardened usercpy code is too paranoid ever since commit 6a30afa8c1fb
("uaccess: disallow > INT_MAX copy sizes")

Code itself should have been fine as-is.

Link: http://lkml.kernel.org/r/20191106164755.31478-1-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reported-by: syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com
Fixes: 6a30afa8c1fb ("uaccess: disallow > INT_MAX copy sizes")
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_property.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_property.c
+++ b/drivers/gpu/drm/drm_property.c
@@ -561,7 +561,7 @@ drm_property_create_blob(struct drm_devi
 	struct drm_property_blob *blob;
 	int ret;
 
-	if (!length || length > ULONG_MAX - sizeof(struct drm_property_blob))
+	if (!length || length > INT_MAX - sizeof(struct drm_property_blob))
 		return ERR_PTR(-EINVAL);
 
 	blob = kvzalloc(sizeof(struct drm_property_blob)+length, GFP_KERNEL);


