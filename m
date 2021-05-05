Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C78837458B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbhEERGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236531AbhEERBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78C6961428;
        Wed,  5 May 2021 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232873;
        bh=GkZH2jLkvJLUIT5boZSGask8fzSznjyBbbhHLFjVEbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvwGJpeDgQiy399N0oWJsPZpUVrE4GGLfVwV5UYZg2W2djgCnCQS1T+gS5DpS5eGY
         w6+3W9w1vOJt/chRbj6AV+ZS6vWIXCJzgDLHVDD0bXERsaush2QFAlm3kIPbF7Smii
         2PBUVz56C/Qy2v6fatfFtNfBbE6k5AffYBZVu7Eg1xn/ars6W8D7ZErD1jiu0jDDfe
         0ZhxFIRwu2cJKyjt7EbLL3KFdh9nXqFzQv5Nxqssogv3QWmgziH31rVtWRyvBdPqbA
         nSTsvm6nQ5iZwfrOm1uhe9Z00oYsUB6cZB9aVBOGxaO4+dzFFYoSRuHBRKU50PcNdB
         +HkETLWNVj8ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/25] cuse: prevent clone
Date:   Wed,  5 May 2021 12:40:40 -0400
Message-Id: <20210505164051.3464020-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164051.3464020-1-sashal@kernel.org>
References: <20210505164051.3464020-1-sashal@kernel.org>
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
index 55db06c7c587..b15eaa9e6cd7 100644
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

