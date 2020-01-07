Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00613335B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAGVSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgAGVFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B37822081E;
        Tue,  7 Jan 2020 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431119;
        bh=U9lMCLFW3Qzr90gPJad9aP/+wLzkKDUNDwbbADjCt/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQnenis3FGLAKoJNwKkZvO8BHvMBq/rGh/bJdzzHRm+RnZ7ZpHvTfzMA7OtJ9IzEd
         zcfN3hsTRbOx5p2WWVOZznshwkqRr1u6pmZlB4slRvssKVcIZMwC5qq8N5s6okb3C5
         M2dHI8Wev8Z2E2364C5v9JBG+6ucFFuSYp1Igy6E=
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
Subject: [PATCH 4.19 040/115] drm: limit to INT_MAX in create_blob ioctl
Date:   Tue,  7 Jan 2020 21:54:10 +0100
Message-Id: <20200107205301.771918206@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
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
index cdb10f885a4f..69dfed57c2f8 100644
--- a/drivers/gpu/drm/drm_property.c
+++ b/drivers/gpu/drm/drm_property.c
@@ -556,7 +556,7 @@ drm_property_create_blob(struct drm_device *dev, size_t length,
 	struct drm_property_blob *blob;
 	int ret;
 
-	if (!length || length > ULONG_MAX - sizeof(struct drm_property_blob))
+	if (!length || length > INT_MAX - sizeof(struct drm_property_blob))
 		return ERR_PTR(-EINVAL);
 
 	blob = kvzalloc(sizeof(struct drm_property_blob)+length, GFP_KERNEL);
-- 
2.20.1



