Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29A9463889
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbhK3PE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:04:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60810 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243592AbhK3O5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA0D5CE1A88;
        Tue, 30 Nov 2021 14:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E483C53FC7;
        Tue, 30 Nov 2021 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284054;
        bh=kqw4KJl49Bf4gJ9zShLQlSuNASPRd4wGpZoA7EOfaaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epgl2DJxYRX/umJK+5atOyzqI5XMZUz5xdLXys+BUsgmfqEnirYbZ+i85v+iy5bax
         pc3Vbr+xNGrNniaI+zKYMJxY1xdp0g5jy3QGMtYg7ZawU8+m4dSmgdAAUS/PwxTu3A
         L/H6WMZ3cp5fqDs7miqF1LgOeIhZZp6mo9Dldrz3dGBW9KcYoY4vsYNCqp/NqsPiXn
         hXs+zlgpkigc/7vAy9sA53VQDD7osA9XlAV6mEsj96+6C5AdfbohpOGLI7Pr5rKqzK
         EvSBHE4WvG3b4YeeAJUkDv6BHxK+EGtjJxbqkrdGhfEPwkHP+QUED9dNeyep479rkz
         +KELEJWIFxt0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.4 6/9] smb2: clarify rc initialization in smb2_reconnect
Date:   Tue, 30 Nov 2021 09:53:59 -0500
Message-Id: <20211130145402.947049-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
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
index 4ffd5e177288e..a8fcaee83d8f3 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -158,7 +158,7 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
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

