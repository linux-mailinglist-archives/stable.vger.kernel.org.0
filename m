Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179D13745CD
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhEERHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238234AbhEERFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A82CE61C30;
        Wed,  5 May 2021 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232939;
        bh=T3kO8RrvNCX8As7P6Z7PFwvA19Yoow54UYuEWBXkQOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKslAOAJNKyr3g3abKLZ0NBKig+2yCrOdvc0IguF7twzDFWcjzb2Oq8ghcYlitofK
         WRBHK21rNA244F+gEGSM1p0i+QBC6LqbBg1A1r7XIn3tBAVHZSGf6ldY9zH1RAlFwk
         X+Spvje/wqyixR6pMYnIZIo09TP8Gbrn4bqIMnjv3MhF2ae5EVsdvBwtn+wOakpmZX
         2mLODE8ceEt7XUDscyn/ATETkI7vzJsajWx5TQdilPT30RtPm+oTOA6i5V+Z2ZR4xH
         EXBvMM1scP4712gfBC2+rAOgVlf8K+7Ufvv9FBMyt9Y/j7ilvfHBSxWrBVPpKHUuSl
         r1Vxx3Myf6i/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/19] cuse: prevent clone
Date:   Wed,  5 May 2021 12:41:55 -0400
Message-Id: <20210505164203.3464510-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164203.3464510-1-sashal@kernel.org>
References: <20210505164203.3464510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 8217673d07256b22881127bf50dce874d0e51653 ]

For cloned connections cuse_channel_release() will be called more than
once, resulting in use after free.

Prevent device cloning for CUSE, which does not make sense at this point,
and highly unlikely to be used in real life.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/cuse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index d9aba9700726..b83367300f48 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -616,6 +616,8 @@ static int __init cuse_init(void)
 	cuse_channel_fops.owner		= THIS_MODULE;
 	cuse_channel_fops.open		= cuse_channel_open;
 	cuse_channel_fops.release	= cuse_channel_release;
+	/* CUSE is not prepared for FUSE_DEV_IOC_CLONE */
+	cuse_channel_fops.unlocked_ioctl	= NULL;
 
 	cuse_class = class_create(THIS_MODULE, "cuse");
 	if (IS_ERR(cuse_class))
-- 
2.30.2

