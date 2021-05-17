Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347C73831C0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhEQOk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241023AbhEQOh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:37:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8675C613F6;
        Mon, 17 May 2021 14:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261076;
        bh=YETmwC0vmkJEnYjZRQtB8GtVeKH+RSjRHV996b86cVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSzHVJgVKfbiQQ0Ywk6/VxdODE5OmZvV13jmRzHjleYYcTU2pUB6+g/CvAMtG0pTf
         4hsChe7xnXmxiDNj3iA0dC4LrtgjLPzZ4gGp4VPI5UFnpGRMArCQJJfya7FSWZ2ztK
         mSlraBRsIFtsxmfNFsMtLRTfZtts2dVcqPbRj91c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 068/329] cuse: prevent clone
Date:   Mon, 17 May 2021 15:59:39 +0200
Message-Id: <20210517140304.362587280@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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



