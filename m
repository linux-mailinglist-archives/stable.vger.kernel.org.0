Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFA6383262
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbhEQOrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241533AbhEQOpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E3761963;
        Mon, 17 May 2021 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261260;
        bh=rPHIF/+0AcFm8CFMCe2mNu3gaE4Hz8XPq3/3gL81Xe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTcv5IqUS/Ky4wRlvSeeTqFFwRldB9tlZrl3ICoREFmL4+e1YIhEWQgychkeXCQJy
         io+sGQyPKER15YkXCDGr+fjFy0MUFw43fnidKS0TMNut4oSqW51FMHf/Ult5Jm4yQE
         1Ra3dzF6vz5KZWcwexykfw8ZcoiFu8qaNLGFqgeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/141] cuse: prevent clone
Date:   Mon, 17 May 2021 16:01:18 +0200
Message-Id: <20210517140243.649349873@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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



