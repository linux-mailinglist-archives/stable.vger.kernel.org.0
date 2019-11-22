Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E593910703E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfKVKpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbfKVKpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354A820715;
        Fri, 22 Nov 2019 10:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419532;
        bh=8iD2RbErPWDnc+352S6Dt9T6EhXU+MLXptMB07sJbVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOff5lxYhu9lpNhM/KUg+6LN7y/ehJcxyjzIh/WnfZaO1L5bRpokXJDiUHkMAtWQQ
         NhtxV3HccCzRJrvdJXsKz1KVuJxHwYI+SCDNZy9cXgXuQpOvYGkEmsuLtCgOzoqo6K
         8O2LWEyrUaWhdX2QxOVqjPkx69Am5SgovXIm6LVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 144/222] fuse: use READ_ONCE on congestion_threshold and max_background
Date:   Fri, 22 Nov 2019 11:28:04 +0100
Message-Id: <20191122100913.230281494@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>

[ Upstream commit 2a23f2b8adbe4bd584f936f7ac17a99750eed9d7 ]

Since they are of unsigned int type, it's allowed to read them
unlocked during reporting to userspace. Let's underline this fact
with READ_ONCE() macroses.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index e25c40c10f4fa..97ac2f5843fcc 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -107,7 +107,7 @@ static ssize_t fuse_conn_max_background_read(struct file *file,
 	if (!fc)
 		return 0;
 
-	val = fc->max_background;
+	val = READ_ONCE(fc->max_background);
 	fuse_conn_put(fc);
 
 	return fuse_conn_limit_read(file, buf, len, ppos, val);
@@ -144,7 +144,7 @@ static ssize_t fuse_conn_congestion_threshold_read(struct file *file,
 	if (!fc)
 		return 0;
 
-	val = fc->congestion_threshold;
+	val = READ_ONCE(fc->congestion_threshold);
 	fuse_conn_put(fc);
 
 	return fuse_conn_limit_read(file, buf, len, ppos, val);
-- 
2.20.1



