Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7401C1E2A59
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgEZSy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389242AbgEZSy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:54:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC94F2087D;
        Tue, 26 May 2020 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519298;
        bh=T60bd/FuGyzll5nwnnbnCo5b2FiEdm8175Y1UAsRFEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryILJr8YWvGZzcIJBj+ZPgr3tKSzVVaQUtHxmtexwrkbmVpBdRalgyFzeFP5vjSyd
         1YFonm73FxuYJS8GAVBRQEF9pKAC5R2UI3BGjQHSnbK3B2/hoE1Nihb7CQu8qpzUrp
         ee130Bz/iver1bjy9jR4TeaGgPQBvTo6MG0Cubhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Kellermann <max@duempel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/65] drivers/media/media-devnode: clear private_data before put_device()
Date:   Tue, 26 May 2020 20:52:33 +0200
Message-Id: <20200526183911.447183733@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Kellermann <max@duempel.org>

commit bf244f665d76d20312c80524689b32a752888838 upstream.

Callbacks invoked from put_device() may free the struct media_devnode
pointer, so any cleanup needs to be done before put_device().

Signed-off-by: Max Kellermann <max@duempel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-devnode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index a8cb52dc8c4f..6c56aebd8db0 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -197,10 +197,11 @@ static int media_release(struct inode *inode, struct file *filp)
 	if (mdev->fops->release)
 		mdev->fops->release(filp);
 
+	filp->private_data = NULL;
+
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	put_device(&mdev->dev);
-	filp->private_data = NULL;
 	return 0;
 }
 
-- 
2.25.1



