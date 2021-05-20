Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A28E38A4B4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhETKH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235540AbhETKFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DBEC6193A;
        Thu, 20 May 2021 09:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503656;
        bh=3L1CmHKeh51fexmnpwdHomXdngQC/duxMdMR4iWCr84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ET98uUCYdGWX4GwXuZxBxRc6npDhmRWl6vReFmmP196pITo0yDjv3cdnMB0vjfdTy
         w94ZPTlqjGqiXvqHGVHyHuLaTXldEvAqvuiFqX6E+qG3AjsuoYIVCRjesdfNY7hPzJ
         R5lT14UwGM0aaNSpNAYEptLZn3zuICACAUHiTDp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 319/425] cuse: prevent clone
Date:   Thu, 20 May 2021 11:21:28 +0200
Message-Id: <20210520092141.910887920@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



