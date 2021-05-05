Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BF3374538
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhEEREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237782AbhEERBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85CF5619D5;
        Wed,  5 May 2021 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232832;
        bh=3L1CmHKeh51fexmnpwdHomXdngQC/duxMdMR4iWCr84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWs1ticXeVPoSvegDavVWEU9LVc3cEf/04uS8QhHklsrEcLPyn/FrhTNwZU5RzF/E
         JAg29QSCpu4ttROP9eakodafCFV9m9eOqIBaHPpQjw80ZcM2Hir0HWxrmipRqMH0Kc
         ZPl84N7ODjEEd2srzRjCZisBG8bCKo9+a44nX43pey88WveWkqIQ8pbN0CsG/Eeqes
         S/L6s3oNlaoDphuQsaN4CzNGFTWvEJGaxAbBbJCPyag2747vukLgXki4LOKJ7HXM3a
         tvyFJgDJvpGBxBmcYwxzrHsr4ZjZO1IyDfoJEjooqBGcgjq4DIKClkoeVF+Ae3ff68
         eT3wtlxr/Nf7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/32] cuse: prevent clone
Date:   Wed,  5 May 2021 12:39:51 -0400
Message-Id: <20210505164004.3463707-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index f057c213c453..e10e2b62ccf4 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -621,6 +621,8 @@ static int __init cuse_init(void)
 	cuse_channel_fops.owner		= THIS_MODULE;
 	cuse_channel_fops.open		= cuse_channel_open;
 	cuse_channel_fops.release	= cuse_channel_release;
+	/* CUSE is not prepared for FUSE_DEV_IOC_CLONE */
+	cuse_channel_fops.unlocked_ioctl	= NULL;
 
 	cuse_class = class_create(THIS_MODULE, "cuse");
 	if (IS_ERR(cuse_class))
-- 
2.30.2

