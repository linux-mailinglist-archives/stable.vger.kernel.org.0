Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99E315EFB5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgBNP7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388709AbgBNP7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46BC924680;
        Fri, 14 Feb 2020 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695946;
        bh=dfkQTTlWdh9yeBtr6FQzHpZfrJDgKsq5R03253NZN1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPH6KNkUG2S1lLCHSWvva7deZQb4BDtgIXbJKksgrK8O+watKtKzuLO8b4/FPNNJH
         lKJ7hVi+MdnOIssU943PTpEYvOvuwkkHxWEQaKwF1AGcpOPinh/kOWrU8bXO9LhpP/
         SeqfMs3CsiwwVJaaI7h9N/hAQx+oX+MOgHeF812M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.5 478/542] cifs: fix unitialized variable poential problem with network I/O cache lock patch
Date:   Fri, 14 Feb 2020 10:47:50 -0500
Message-Id: <20200214154854.6746-478-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

