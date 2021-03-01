Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00A23287C4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbhCAR2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238107AbhCARXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184C565070;
        Mon,  1 Mar 2021 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617317;
        bh=Xr9MYXotqaA1aMkdBxJqf2KE67TRHHRc4wXHCpaodTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+001qvPeqlBi/psyqW776tDpOv6blEoGlBK5pH1AtediFnpNN2bSrDphTJHONnEi
         tbbjLwwyKdmxeS6Jv3s11txDnP+mXXHULDjRiK6fLKfFwVE60in1FFl1JWCQ1gwo7X
         qEagChVqGH0OGn3gT4Q/bXHxy1IySpb95QBZMPnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Michael Walle <michael@walle.cc>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 004/340] debugfs: do not attempt to create a new file before the filesystem is initalized
Date:   Mon,  1 Mar 2021 17:09:08 +0100
Message-Id: <20210301161048.516545344@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 56348560d495d2501e87db559a61de717cd3ab02 upstream.

Some subsystems want to add debugfs files at early boot, way before
debugfs is initialized.  This seems to work somehow as the vfs layer
will not allow it to happen, but let's be explicit and test to ensure we
are properly up and running before allowing files to be created.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Walle <michael@walle.cc>
Reported-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210218100818.3622317-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -315,6 +315,9 @@ static struct dentry *start_creating(con
 	struct dentry *dentry;
 	int error;
 
+	if (!debugfs_initialized())
+		return ERR_PTR(-ENOENT);
+
 	pr_debug("creating file '%s'\n", name);
 
 	if (IS_ERR(parent))


