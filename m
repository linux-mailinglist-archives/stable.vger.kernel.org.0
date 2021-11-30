Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6A64638D5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244711AbhK3PGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244746AbhK3PCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:02:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D01BC08EA75;
        Tue, 30 Nov 2021 06:54:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7CBAB81A49;
        Tue, 30 Nov 2021 14:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9832C53FCD;
        Tue, 30 Nov 2021 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284037;
        bh=K+2c0PSx2JjRSSxO9jEIm1R5OerG8X4f4oMwS+g/AZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLKAg7sYZn0K5KidvS8a9x812aWblIMETwLFnaifahGDX+bW7YiOe/VSFn+0kJMdc
         8d79fypRcN/IE/AAdklCGf3DJv7XLme+2CCRuhzdtOxWNvmc18nunDJD2wgTH+2MOQ
         A0M3WCXpeMU1hGznx64iGKlSHoBO0oxvOZVoAOvMHVPFpO9OvvY/eEurVSyyUDhxaa
         uvUo/jFePvGuaOr5MKpUtAIx5lYla8uXQOzilwdDpoXIXr65tPfkyoDGv8o/VfrmNd
         wjsqwXXwVtQ/4T2LgPE8BT65pRqM9FvVapRqmUtdj7nBzP1W2QnRgDI9RV3xzPexh8
         GGl/HvFpxcebA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.9 09/12] smb2: clarify rc initialization in smb2_reconnect
Date:   Tue, 30 Nov 2021 09:53:37 -0500
Message-Id: <20211130145341.946891-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145341.946891-1-sashal@kernel.org>
References: <20211130145341.946891-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 350f4a562e1ffc2e4869e3083dc9b0ec4bca6c3a ]

It is clearer to initialize rc at the beginning of the function.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index cf1a3d2f6ad8b..a6ae56bf8996a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -155,7 +155,7 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
-	int rc;
+	int rc = 0;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
-- 
2.33.0

