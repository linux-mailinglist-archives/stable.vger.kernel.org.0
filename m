Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E5111E2A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbfLCWz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbfLCWz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7161A2053B;
        Tue,  3 Dec 2019 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413757;
        bh=LblJZ/hDggYRNLdYlwjonAHuue8tQ0vAk81anousPrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc+fKa3hlGJX+lrls44eWlhPef/xDzFg6QLLgAKvK4dg4GAfAYC1zk4fPYwiJuXc8
         GuS0pqM5g3sBOPW6JgVqCpiwtzyHfdLFx8I3iozkC+WJNMV8VU1Mk7BTi7McysgVpZ
         hY90EfO34czCNUZaxRGpayAnaurk5h3/trUh9f0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Coulson <chris.coulson@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 249/321] apparmor: delete the dentry in aafs_remove() to avoid a leak
Date:   Tue,  3 Dec 2019 23:35:15 +0100
Message-Id: <20191203223440.091070967@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Coulson <chris.coulson@canonical.com>

[ Upstream commit 201218e4d3dfa1346e30997f48725acce3f26d01 ]

Although the apparmorfs dentries are always dropped from the dentry cache
when the usage count drops to zero, there is no guarantee that this will
happen in aafs_remove(), as another thread might still be using it. In
this scenario, this means that the dentry will temporarily continue to
appear in the results of lookups, even after the call to aafs_remove().

In the case of removal of a profile - it also causes simple_rmdir()
on the profile directory to fail, as the directory won't be empty until
the usage counts of all child dentries have decreased to zero. This
results in the dentry for the profile directory leaking and appearing
empty in the file system tree forever.

Signed-off-by: Chris Coulson <chris.coulson@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 40e3a098f6fb5..d95a7e41a29d4 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -361,6 +361,7 @@ static void aafs_remove(struct dentry *dentry)
 			simple_rmdir(dir, dentry);
 		else
 			simple_unlink(dir, dentry);
+		d_delete(dentry);
 		dput(dentry);
 	}
 	inode_unlock(dir);
-- 
2.20.1



