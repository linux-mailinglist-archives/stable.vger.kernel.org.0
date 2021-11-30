Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E859046375B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbhK3OxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57184 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242654AbhK3OwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4FDA7CE1A40;
        Tue, 30 Nov 2021 14:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901FFC53FC1;
        Tue, 30 Nov 2021 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283732;
        bh=X5gu/kT5daZtFyc8XEQBM7EGsfaolPn22n7otTygLDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkckyUanS66q6sZkYH+52wa+o+W45as/AbQDS6XhIT61dS7qE+Tl3IglvBGm4fI63
         3IJUQDqX4Bdh0b9Q28SKQpNoUyEI+G4DjPDIgCAQWZJzB9boM64zNKzNJldS+D8tKr
         BJIE5dwyHEUH/vK3Sx9EML8uyhYtb+soUXQo1v91UgBghWg3s2agWneO+lt6zrNRKh
         78w4NOZdBoNRDNEjjBoWlMObV08BXNOk7l74xjnQVAVeD7vtzhymgN8qf23w7V8D1T
         bh/zQfWPBDiJ4tX5dTKv1IQIfSov4ZKPtrLoqqsZfDP66vqy0Yecks/eaaapt6WrhK
         YDqnNBARY92Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 39/68] smb2: clarify rc initialization in smb2_reconnect
Date:   Tue, 30 Nov 2021 09:46:35 -0500
Message-Id: <20211130144707.944580-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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
index 7829c590eeac6..3b527274de2b6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -143,7 +143,7 @@ static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
 {
-	int rc;
+	int rc = 0;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
 	int retries;
-- 
2.33.0

