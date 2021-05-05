Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D353743FC
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhEEQxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234697AbhEEQvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BDB361453;
        Wed,  5 May 2021 16:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232676;
        bh=YETmwC0vmkJEnYjZRQtB8GtVeKH+RSjRHV996b86cVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFMF1pfplnynn2KMDz2yc5x2GUCFioOrMzcdnUv9A8j48kcxNkIEvM5T3ZstsfbOY
         xUH1wWI+EKXCMP8sLCGqcBT8XhGtPoghCI34faoQXJb5CBoa1RJpIl2tey6vUKs17P
         6ifokCQn37elGkgTx6hE/Ze1x7jM/uq/VfizKlUyJdV+9MGc5tdDf3oGiiOYAffzR6
         16UyuqjONp0CaIXr6nnOV8/TykF6sQk42yP9OGvwOcDkq7n7G2jSr+sHTyfYLY8tfP
         sYHK1/WISb8VYizCWmLMgxYLLW4KQq/CSORi21MGT1SDmzv/LnNSejUu2GJdsZbeaT
         hX0g/rHMZyzNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 46/85] cuse: prevent clone
Date:   Wed,  5 May 2021 12:36:09 -0400
Message-Id: <20210505163648.3462507-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 45082269e698..a37528b51798 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -627,6 +627,8 @@ static int __init cuse_init(void)
 	cuse_channel_fops.owner		= THIS_MODULE;
 	cuse_channel_fops.open		= cuse_channel_open;
 	cuse_channel_fops.release	= cuse_channel_release;
+	/* CUSE is not prepared for FUSE_DEV_IOC_CLONE */
+	cuse_channel_fops.unlocked_ioctl	= NULL;
 
 	cuse_class = class_create(THIS_MODULE, "cuse");
 	if (IS_ERR(cuse_class))
-- 
2.30.2

