Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38CA107827
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKVTtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfKVTtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7398320658;
        Fri, 22 Nov 2019 19:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452141;
        bh=uXh2vBvBRQO36GgVX8ar8zmIAph80dMhJHJkUXgaPvw=;
        h=From:To:Cc:Subject:Date:From;
        b=Zidza78BSt3f9YKVgCMPobEyOpxJNXtgCzWK81sEimiTw+zqlWVPc6eSkaCLZLvEG
         2JCy7TyNOjgp8AUSRRgjPLiy6mxDFLkGTUIN4eBXgPnk7i2mhsSgO/i9PJe7363vmI
         ID5mqmpZGIHUXo2WJqMx/akS1GrSzldrQL91GL0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        autofs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/25] autofs: fix a leak in autofs_expire_indirect()
Date:   Fri, 22 Nov 2019 14:48:34 -0500
Message-Id: <20191122194859.24508-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 03ad0d703df75c43f78bd72e16124b5b94a95188 ]

if the second call of should_expire() in there ends up
grabbing and returning a new reference to dentry, we need
to drop it before continuing.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/expire.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
index 28d9c2b1b3bb3..70e9afe589fbf 100644
--- a/fs/autofs/expire.c
+++ b/fs/autofs/expire.c
@@ -501,9 +501,10 @@ static struct dentry *autofs_expire_indirect(struct super_block *sb,
 		 */
 		how &= ~AUTOFS_EXP_LEAVES;
 		found = should_expire(expired, mnt, timeout, how);
-		if (!found || found != expired)
-			/* Something has changed, continue */
+		if (found != expired) { // something has changed, continue
+			dput(found);
 			goto next;
+		}
 
 		if (expired != dentry)
 			dput(dentry);
-- 
2.20.1

