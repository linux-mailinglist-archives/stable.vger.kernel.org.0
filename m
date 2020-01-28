Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2879614BB47
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgA1OJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgA1OJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:09:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2FBD22522;
        Tue, 28 Jan 2020 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220554;
        bh=FTtjFYky1ag7/i8Q5RUFBCOxB8SZ086BNqLhqsOIBT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUP8jGTJyblFYFOcmU7wTbmiURdhh4A9+SLknw4WjfXforNBTfWA3hJNSL0N1hDt2
         ZTF9oklQjwfR8HoIR6avMwiMZhWOzliHBhxl0mZ7EU5J8Ib2JYolyB4z4HoTy15D33
         imA1kopsCQqdg1ufDmCh7qP9Grt06mt6jIYjG5pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 053/183] fs/nfs: Fix nfs_parse_devname to not modify its argument
Date:   Tue, 28 Jan 2020 15:04:32 +0100
Message-Id: <20200128135835.204447073@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 40cc394be1aa18848b8757e03bd8ed23281f572e ]

In the rare and unsupported case of a hostname list nfs_parse_devname
will modify dev_name.  There is no need to modify dev_name as the all
that is being computed is the length of the hostname, so the computed
length can just be shorted.

Fixes: dc04589827f7 ("NFS: Use common device name parsing logic for NFSv4 and NFSv2/v3")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index dced329a85844..47a7751146cf5 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1901,7 +1901,7 @@ static int nfs_parse_devname(const char *dev_name,
 		/* kill possible hostname list: not supported */
 		comma = strchr(dev_name, ',');
 		if (comma != NULL && comma < end)
-			*comma = 0;
+			len = comma - dev_name;
 	}
 
 	if (len > maxnamlen)
-- 
2.20.1



