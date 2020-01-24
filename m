Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B414D147C6E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgAXJv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388090AbgAXJv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:51:56 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBA7206D5;
        Fri, 24 Jan 2020 09:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859516;
        bh=oU0qeGWTfKOBe4QFO1GHtK0vjjNyYqKezAFh/lfhEvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unu+QK8V9jCTIm1tb3SSjV0yNI7Je/isnphI1hT3L1CLmpyio+EI9vsnzzqKLFvPv
         Gxvx9Ds631zttld7Ac0HWQzYK6lSWuJU11FjSiStmQUPRoCnev8lEcQsDE6P3gZdlc
         fInOEQ7AXzxW0aa5XbHQZKBViX0XceIny+e5sVY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 121/343] fs/nfs: Fix nfs_parse_devname to not modify its argument
Date:   Fri, 24 Jan 2020 10:28:59 +0100
Message-Id: <20200124092935.934226320@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index f464f8d9060c0..470b761839a51 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1925,7 +1925,7 @@ static int nfs_parse_devname(const char *dev_name,
 		/* kill possible hostname list: not supported */
 		comma = strchr(dev_name, ',');
 		if (comma != NULL && comma < end)
-			*comma = 0;
+			len = comma - dev_name;
 	}
 
 	if (len > maxnamlen)
-- 
2.20.1



