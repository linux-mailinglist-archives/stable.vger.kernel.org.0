Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6EA3744F2
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhEERDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237126AbhEEQ5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D44A0619A3;
        Wed,  5 May 2021 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232768;
        bh=rPHIF/+0AcFm8CFMCe2mNu3gaE4Hz8XPq3/3gL81Xe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeMMCP0xH8ezYUD7i2WXuEFLrdKXi5TeP7L/pwU3qSNVfJt+Sxye0bs0fsBe4H5yr
         oEdQHEKSeUEP3vAuVWf4o9m17NsVHGAzp+jyv09oeyuTynbtlckm0z3MCzVdpriGUb
         AUHtvgh8QE1s9SqMssW6sN/oTdjUqzPQq/gByij4HRtVI73k2jC1Rfi4PyVpGmbNgT
         fCzEOQ0akZb8WwCKSATZa8sMHQhSddD8BhQc/h1w2pceswmIpf1DfVjYUoVW0ns48i
         KByXJM5eZreMBfvC2GULaBibzCpxap8gRIwwG1ljWDXMDr0sNZzgQtYVFYbQ7l+TRc
         2uU5TCdrVxkyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/46] cuse: prevent clone
Date:   Wed,  5 May 2021 12:38:32 -0400
Message-Id: <20210505163856.3463279-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index 00015d851382..e51b7019e887 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -624,6 +624,8 @@ static int __init cuse_init(void)
 	cuse_channel_fops.owner		= THIS_MODULE;
 	cuse_channel_fops.open		= cuse_channel_open;
 	cuse_channel_fops.release	= cuse_channel_release;
+	/* CUSE is not prepared for FUSE_DEV_IOC_CLONE */
+	cuse_channel_fops.unlocked_ioctl	= NULL;
 
 	cuse_class = class_create(THIS_MODULE, "cuse");
 	if (IS_ERR(cuse_class))
-- 
2.30.2

