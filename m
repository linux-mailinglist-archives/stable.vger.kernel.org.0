Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C14D137DBA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgAKKAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgAKKAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:00:42 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D552082E;
        Sat, 11 Jan 2020 10:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736841;
        bh=CkX6UQBjIFeLcLZ79NvCj/g6FZYRaRgU0byC7s/VAws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrVrL2+w8nZN7QZM2FVRhngnCEozV07I6K0KbvaBrY6omkeyDo1g62gcpLxHX/VNS
         o86lMUhAnY9iHzEutsLZORyDvHv4CLgFTfH97fJylbflZXppHOzT0eY4oCdwf0YJ3P
         uHuP5ySXGnMDY6dtkBzIbjvIcFRyDkzrm2LUDYvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/91] drm: limit to INT_MAX in create_blob ioctl
Date:   Sat, 11 Jan 2020 10:49:10 +0100
Message-Id: <20200111094849.671197015@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 5bf8bec3f4ce044a223c40cbce92590d938f0e9c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_property.c b/drivers/gpu/drm/drm_property.c
index a4d81cf4ffa0..16c72d2ddc2e 100644
--- a/drivers/gpu/drm/drm_property.c
+++ b/drivers/gpu/drm/drm_property.c
@@ -554,7 +554,7 @@ drm_property_create_blob(struct drm_device *dev, size_t length,
 	struct drm_property_blob *blob;
 	int ret;
 
-	if (!length || length > ULONG_MAX - sizeof(struct drm_property_blob))
+	if (!length || length > INT_MAX - sizeof(struct drm_property_blob))
 		return ERR_PTR(-EINVAL);
 
 	blob = kzalloc(sizeof(struct drm_property_blob)+length, GFP_KERNEL);
-- 
2.20.1



