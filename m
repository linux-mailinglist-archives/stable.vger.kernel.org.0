Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB6A1E2A53
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbgEZSy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389192AbgEZSy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:54:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4685820823;
        Tue, 26 May 2020 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519295;
        bh=/In5JdT69yn57IumW2iR6+2tiJcSI5hBOP0xi1d5Da4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoDYFOpDy7aBAAWpMCZ0pjHjf6uBqDvFOC4P3hHJX+G44xEX8mAwHxJkLVgLNeq8v
         ANAv+G9wk7NzuyPBKRqKZWolyvXxpeJOfgAO68wgpOsdtB16khAMAxWl+DvRfuAnEx
         qz+Vu5j0ECeVnziAgnwuarqqS49ipZ73xAU3JprA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/65] media: Fix media_open() to clear filp->private_data in error leg
Date:   Tue, 26 May 2020 20:52:32 +0200
Message-Id: <20200526183911.159307281@linuxfoundation.org>
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

From: Shuah Khan <shuahkh@osg.samsung.com>

commit d40ec6fdb0b03b7be4c7923a3da0e46bf943740a upstream.

Fix media_open() to clear filp->private_data when file open
fails.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-devnode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ebf9626e5ae5..a8cb52dc8c4f 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -181,6 +181,7 @@ static int media_open(struct inode *inode, struct file *filp)
 		ret = mdev->fops->open(filp);
 		if (ret) {
 			put_device(&mdev->dev);
+			filp->private_data = NULL;
 			return ret;
 		}
 	}
-- 
2.25.1



