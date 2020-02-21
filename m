Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BF21675C7
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbgBUIOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:14:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732732AbgBUIOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:14:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F84C2467A;
        Fri, 21 Feb 2020 08:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272857;
        bh=dfkQTTlWdh9yeBtr6FQzHpZfrJDgKsq5R03253NZN1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOubqzmLX/DvNbIz8Kn5RjiNRbA4HUFausXZGlPa9u0Jhd/ny1VRPZLQTZTlmHfxF
         JCFrxX+1kvQ3sunmP5LHRzqSqmVzipTfsU8YRrz3uo0U9a/YQlT4gGS4hg6079wygj
         NLnxdJ45t+2KC44si8Qxl2a66W0IPD4i+5TrHcJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 302/344] cifs: fix unitialized variable poential problem with network I/O cache lock patch
Date:   Fri, 21 Feb 2020 08:41:41 +0100
Message-Id: <20200221072417.330758319@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 463a7b457c02250a84faa1d23c52da9e3364aed2 ]

static analysis with Coverity detected an issue with the following
commit:

 Author: Paulo Alcantara (SUSE) <pc@cjr.nz>
 Date:   Wed Dec 4 17:38:03 2019 -0300

    cifs: Avoid doing network I/O while holding cache lock

Addresses-Coverity: ("Uninitialized pointer read")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dfs_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 2faa05860a483..cf6cec59696c2 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1319,7 +1319,7 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
 	char *mdata = NULL, *devname = NULL;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
-	struct smb_vol vol;
+	struct smb_vol vol = {NULL};
 
 	rpath = get_dfs_root(path);
 	if (IS_ERR(rpath))
-- 
2.20.1



