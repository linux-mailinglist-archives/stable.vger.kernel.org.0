Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C374631E984
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 13:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBRMFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 07:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhBRLov (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 06:44:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87BCC061756;
        Thu, 18 Feb 2021 03:43:26 -0800 (PST)
Date:   Thu, 18 Feb 2021 11:43:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613648605;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXPnHH1CtmNgS2wIvrc2S+SjWgyqtPea6WfzNkaDZHg=;
        b=RF6unuoeOU1vZcfOK+oAgTC4EQQn8EYc9BpEXAoZ+qufZzHtrkbmsX+IQDScgy8ol98a4/
        yli+0jGK16bHi821/QJKuFBMtsltKDJAfu8FSQnTW+utQM5DvrNTa8GOhcPx1Ma3GirIuM
        S9kCr64eAi6wDDF9AJWlF39srQTzmhN53Xcxv1v8AiDkq3PVEsMepU9ek0IVg9QmtHwieh
        J07X+/Dh86q9mIcl/epv0raKATJlI/SNSizl4BePQ83UZkM8FCLumsha0BhQDTnG18x8tx
        1vifEg5N8tvvLnd1dC0YfykF4es8JMrudqhxdociKoe+Qj00z3KkqpAfq2KF1g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613648605;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXPnHH1CtmNgS2wIvrc2S+SjWgyqtPea6WfzNkaDZHg=;
        b=hWF7khrEh28voazgw41ODHMT6Kzt8pQlVOWTrfRAjr8TK/umB5X10igWQsBhqAc/UfeErc
        V8HLe40T/EMa9dBw==
From:   "irqchip-bot for Greg Kroah-Hartman" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] debugfs: do not attempt to create a new
 file before the filesystem is initalized
Cc:     Michael Walle <michael@walle.cc>, Marc Zyngier <maz@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        tglx@linutronix.de
In-Reply-To: <20210218100818.3622317-2-gregkh@linuxfoundation.org>
References: <20210218100818.3622317-2-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Message-ID: <161364860439.20312.9107550617720513848.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     fb0757f54bc9259c4c67907fd97ca3ad109d3f6f
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/fb0757f54bc9259c4c67907fd97ca3ad109d3f6f
Author:        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
AuthorDate:    Thu, 18 Feb 2021 11:08:18 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Thu, 18 Feb 2021 11:39:18 

debugfs: do not attempt to create a new file before the filesystem is initalized

Some subsystems want to add debugfs files at early boot, way before
debugfs is initialized.  This seems to work somehow as the vfs layer
will not allow it to happen, but let's be explicit and test to ensure we
are properly up and running before allowing files to be created.

Reported-by: Michael Walle <michael@walle.cc>
Reported-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210218100818.3622317-2-gregkh@linuxfoundation.org
---
 fs/debugfs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index bbeb563..86c7f04 100644
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
