Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7953B37415B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhEEQhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234684AbhEEQfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9288861425;
        Wed,  5 May 2021 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232380;
        bh=YETmwC0vmkJEnYjZRQtB8GtVeKH+RSjRHV996b86cVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFjIgBKbFJrAvvChsXxBgWCAkEN8dzk6xz366t5VAiUE/t8HELfPoL5MW5ILVAwqF
         MVJks9pxfyfS1QNtx8h6FkHbSuRTtY6d0lMdMGJfl0YwfgFRCYFxND9Ph0uly3oStr
         Xr3idramM2jMwGnAyNEWwoVKpfnb+EcRJDsST2wz7UlQb1c9wEixNMCz69BWigmwk4
         uIGcOz0ZCkJqydCBjPVjpUsmobEnJwAWH7pTmGGEw1qtuBl9ctLqgKEULS7s5PrDv0
         uMvXaCyX9zzbITH3fgVoQtpqtuFgsWUf7iuCM3dUq2qmfTI3xyRN4iro4lxSglYlit
         jhGaxUDhK8A+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 068/116] cuse: prevent clone
Date:   Wed,  5 May 2021 12:30:36 -0400
Message-Id: <20210505163125.3460440-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

