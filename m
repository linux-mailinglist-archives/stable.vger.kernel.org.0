Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD4531E979
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 13:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhBRMC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 07:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhBRKJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 05:09:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3482964E2F;
        Thu, 18 Feb 2021 10:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613642902;
        bh=b+vI2uUyM0OCZs9iSfG7gA2+CR0nelYFr83a8brDzcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WR6EvwhaEAN3j90SJ6vFwhBts0VhC7om8/g6Wot3Fw7CsAaq1X+AEE39advNMQk8q
         jwadQHiVMeXQ8YHyHZ0dq2FWFQbhZ37BljC3LTEr+Iq9dhb0RHTd9r2JurTnZu93Pk
         Pa1kSDzRC7QpyDMllTZ0i+EkODgN3EIB6wKFM7aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Walle <michael@walle.cc>,
        Marc Zyngier <maz@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] debugfs: do not attempt to create a new file before the filesystem is initalized
Date:   Thu, 18 Feb 2021 11:08:18 +0100
Message-Id: <20210218100818.3622317-2-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210218100818.3622317-1-gregkh@linuxfoundation.org>
References: <20210218100818.3622317-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some subsystems want to add debugfs files at early boot, way before
debugfs is initialized.  This seems to work somehow as the vfs layer
will not allow it to happen, but let's be explicit and test to ensure we
are properly up and running before allowing files to be created.

Reported-by: Michael Walle <michael@walle.cc>
Reported-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index bbeb563cbe78..86c7f0489620 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -318,6 +318,9 @@ static struct dentry *start_creating(const char *name, struct dentry *parent)
 	if (!(debugfs_allow & DEBUGFS_ALLOW_API))
 		return ERR_PTR(-EPERM);
 
+	if (!debugfs_initialized())
+		return ERR_PTR(-ENOENT);
+
 	pr_debug("creating file '%s'\n", name);
 
 	if (IS_ERR(parent))
-- 
2.30.1

