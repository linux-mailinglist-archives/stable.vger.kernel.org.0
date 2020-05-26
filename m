Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053B81E2A56
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389277AbgEZSzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389254AbgEZSzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2948A20885;
        Tue, 26 May 2020 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519300;
        bh=9BzVbIQ1RgoeVte0yG3HQz5ChixvNH7WvWk2e9xLJDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6ti+fLYl+bWB8wYTT77Uz1peEQGhEootiBnoGIEMfDMpIsy8Itls5FglRhZC1AhF
         ewhJYYcrttaNWcIY5nWRBVSoyQ6OUEZ3m+rs7wrw+9CVXWrw0sjcUyRboOMdqPyNQ5
         KeViJwwt7VrdGL7chPHSz4rXGCiKArh+cOq8denc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Kellermann <max@duempel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/65] media-devnode: add missing mutex lock in error handler
Date:   Tue, 26 May 2020 20:52:34 +0200
Message-Id: <20200526183911.693569472@linuxfoundation.org>
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

commit 88336e174645948da269e1812f138f727cd2896b upstream.

We should protect the device unregister patch too, at the error
condition.

Signed-off-by: Max Kellermann <max@duempel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-devnode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 6c56aebd8db0..86c7c3732c84 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -282,8 +282,11 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 	return 0;
 
 error:
+	mutex_lock(&media_devnode_lock);
 	cdev_del(&mdev->cdev);
 	clear_bit(mdev->minor, media_devnode_nums);
+	mutex_unlock(&media_devnode_lock);
+
 	return ret;
 }
 
-- 
2.25.1



