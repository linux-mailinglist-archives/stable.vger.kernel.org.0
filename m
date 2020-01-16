Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4913EEBB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405429AbgAPRhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:37:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405422AbgAPRhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:37:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1145246C3;
        Thu, 16 Jan 2020 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196258;
        bh=bFpgvpIsX7xYt7AEP1O4Mz3AHiaUEeRaeY8XZmOCVNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcqONqGQtp7eHAZtDNiPZwRaidNWbYNNdeYuI0hFf0tW6rMYMk+sue+45OTBcAnMJ
         cqZbznNj0IG3oKHhh0/PGeuyiZoJgjug1UftpFTsRM85sdSAWGEF/0457+swCPxS8k
         YFNru5XjVQWzVEbh68gCJYuQ4VwjtCreznfMLY8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 083/251] fs/nfs: Fix nfs_parse_devname to not modify it's argument
Date:   Thu, 16 Jan 2020 12:33:52 -0500
Message-Id: <20200116173641.22137-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
index 42c31587a936..4c21e572f2d9 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1928,7 +1928,7 @@ static int nfs_parse_devname(const char *dev_name,
 		/* kill possible hostname list: not supported */
 		comma = strchr(dev_name, ',');
 		if (comma != NULL && comma < end)
-			*comma = 0;
+			len = comma - dev_name;
 	}
 
 	if (len > maxnamlen)
-- 
2.20.1

