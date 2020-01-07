Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B471331CB
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgAGVDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgAGVDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A1020678;
        Tue,  7 Jan 2020 21:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431032;
        bh=oXd5dKaowLc4ClFuqWWYnG6HXOWV+nA6qCKogbnQTPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjnaRPmcheJZeftCVz1dyXT5xn9UgfnhNL38Gpo63ieVYA3fcZnalNpLSt/eL5ERs
         eyHqiR429EdzNtvhnBhhCACAtAOV7YREBllT7TFyAuctbyvOrq++9fd/tCTvnV3FwP
         CLml/972mym2AT7CJtDKDZ5lbnXPX102I9R8ZCRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 170/191] cifs: Fix lookup of root ses in DFS referral cache
Date:   Tue,  7 Jan 2020 21:54:50 +0100
Message-Id: <20200107205342.101065922@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara (SUSE) <pc@cjr.nz>

commit df3df923b31d298c3d3653a0380202b9f2df9864 upstream.

We don't care about module aliasing validation in
cifs_compose_mount_options(..., is_smb3) when finding the root SMB
session of an DFS namespace in order to refresh DFS referral cache.

The following issue has been observed when mounting with '-t smb3' and
then specifying 'vers=2.0':

...
Nov 08 15:27:08 tw kernel: address conversion returned 0 for FS0.WIN.LOCAL
Nov 08 15:27:08 tw kernel: [kworke] ==> dns_query((null),FS0.WIN.LOCAL,13,(null))
Nov 08 15:27:08 tw kernel: [kworke] call request_key(,FS0.WIN.LOCAL,)
Nov 08 15:27:08 tw kernel: [kworke] ==> dns_resolver_cmp(FS0.WIN.LOCAL,FS0.WIN.LOCAL)
Nov 08 15:27:08 tw kernel: [kworke] <== dns_resolver_cmp() = 1
Nov 08 15:27:08 tw kernel: [kworke] <== dns_query() = 13
Nov 08 15:27:08 tw kernel: fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: FS0.WIN.LOCAL to 192.168.30.26
===> Nov 08 15:27:08 tw kernel: CIFS VFS: vers=2.0 not permitted when mounting with smb3
Nov 08 15:27:08 tw kernel: fs/cifs/dfs_cache.c: CIFS VFS: leaving refresh_tcon (xid = 26) rc = -22
...

Fixes: 5072010ccf05 ("cifs: Fix DFS cache refresher for DFS links")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dfs_cache.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1317,7 +1317,6 @@ static struct cifs_ses *find_root_ses(st
 	int rc;
 	struct dfs_info3_param ref = {0};
 	char *mdata = NULL, *devname = NULL;
-	bool is_smb3 = tcon->ses->server->vals->header_preamble_size == 0;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct smb_vol vol;
@@ -1344,7 +1343,7 @@ static struct cifs_ses *find_root_ses(st
 		goto out;
 	}
 
-	rc = cifs_setup_volume_info(&vol, mdata, devname, is_smb3);
+	rc = cifs_setup_volume_info(&vol, mdata, devname, false);
 	kfree(devname);
 
 	if (rc) {


