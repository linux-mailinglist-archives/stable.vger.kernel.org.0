Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C43745A3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbhEERGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234752AbhEERDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC171613F5;
        Wed,  5 May 2021 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232907;
        bh=T3kO8RrvNCX8As7P6Z7PFwvA19Yoow54UYuEWBXkQOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QliHd3S27pOvCJFj6ZNcgSoAOCkgGQ+0CqAxnpOsOV5K1zuw9gfgratFBM68OlhFd
         SwHNw3Ef2Yj63I2V52EYdxdlIgRy3tIIzU8l7sQzY8cN+VsnkO95jYovdMr0e4tWwc
         dRnmMi3ozIyTONk6iM/tq0AEEII7Rla/C3cYAnMh9EL5qnLx/ssBE4t5iKg7pa/TUi
         mr66xm4xrwp3VjhDdSc9UzaTBJejm9xBahA8G/5EOQDXLhFgeVwnwCefTYeFYDv+KT
         KdZPuvBOJi4wKprzH26VmMgELileBtgTviojtMAxRyY55R4X8VZUotzwtq2XrshTns
         h2GLjjgI3ElMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/22] cuse: prevent clone
Date:   Wed,  5 May 2021 12:41:19 -0400
Message-Id: <20210505164129.3464277-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164129.3464277-1-sashal@kernel.org>
References: <20210505164129.3464277-1-sashal@kernel.org>
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

