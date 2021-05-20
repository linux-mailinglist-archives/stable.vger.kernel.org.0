Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3967338A988
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbhETLDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239098AbhETLBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B9E61423;
        Thu, 20 May 2021 10:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505022;
        bh=T3kO8RrvNCX8As7P6Z7PFwvA19Yoow54UYuEWBXkQOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBzteK5eBY/1Znu3hDRCuWDRppBbb/U0mhteF9ijHxJp8h7WcQSg4DkpVQFFoi+ay
         1e6WB1swGPQhIyFiBn/TDDoFkLKtu1c6VIv3u8Jp/G2A3YoxTwwASJn/TAoQvt3nes
         dMiRa3hzq3hmVUjaB6hNpO2FhlYFvI3K1/7IFJ/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 180/240] cuse: prevent clone
Date:   Thu, 20 May 2021 11:22:52 +0200
Message-Id: <20210520092114.703207137@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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



