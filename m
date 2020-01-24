Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA97914808C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388816AbgAXLMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389966AbgAXLMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:12 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A6F22522;
        Fri, 24 Jan 2020 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864332;
        bh=O6dLP6uLyMkqnt7wJ8gNhg6JZgbeVd11Y3F8tMPSRV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuU5q37nEGXHiQtdBCThtq4S7Su2lCc9Zy0H9JWIj7lhZruFYHcz6syGXrgY4vc8L
         A4Mwk3tTz9haKxHEVHPiQ2kD1Y/YqZiEgmQPRdXvpn/VTm99PuUArruBRDfC11faUp
         AP02LC8w32qNF+F145OBpKyiu9GYKrwj649JWlbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/639] fs/nfs: Fix nfs_parse_devname to not modify its argument
Date:   Fri, 24 Jan 2020 10:26:34 +0100
Message-Id: <20200124093114.967613031@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index d90efdea9fbd6..5db7aceb41907 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1930,7 +1930,7 @@ static int nfs_parse_devname(const char *dev_name,
 		/* kill possible hostname list: not supported */
 		comma = strchr(dev_name, ',');
 		if (comma != NULL && comma < end)
-			*comma = 0;
+			len = comma - dev_name;
 	}
 
 	if (len > maxnamlen)
-- 
2.20.1



