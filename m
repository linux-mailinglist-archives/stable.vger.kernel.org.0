Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9231E986
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBRMFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 07:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhBRLov (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 06:44:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECF8C061574;
        Thu, 18 Feb 2021 03:43:26 -0800 (PST)
Date:   Thu, 18 Feb 2021 11:43:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613648605;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scpXFIVn1GJFUw3gww4yPeV9xgaEAhOXwi4N+jmSIuI=;
        b=pdIA6KA+rBoKv582vWd417yyLZ6nVxH8IdxhwNKPu8QQ95ABoQvPHNQrBSv8hJbYDF64Gi
        Dppb6gWzeDpCUMgnpTgz/WeJYD+oKf3E2Ky2y4L4J3VBnHsupAxgKZ+OG7hr8mz2w4NVGh
        RLLGEJYUWI82sP4qSSf7lcntWeUc0XpvCrlhphwr1mfCR59FKHvgfCY0JZOJnT7WKpvNBT
        bIbZGMfH7SD4huvFrakJOqVsQ5jViPrXS3KSVqNBu8db+76fBXZ+bIzDc46N6sr7OLiSmv
        ul/4e2TKKAePSSoj5dBjvkJh96R1rrBV3FknFlOikWF/jjQj/ECGb7FeyxFFXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613648605;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scpXFIVn1GJFUw3gww4yPeV9xgaEAhOXwi4N+jmSIuI=;
        b=zBzrB8pvBNgc2MKocvRG0sEu8Jqjrla3Ujuy4MJRtfJmza4dNt91fu6Q8aeoI+ORBc4Y8v
        WhsYaeSHR9uojABQ==
From:   "irqchip-bot for Greg Kroah-Hartman" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] debugfs: be more robust at handling
 improper input in debugfs_lookup()
Cc:     Michael Walle <michael@walle.cc>, Marc Zyngier <maz@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        tglx@linutronix.de
In-Reply-To: <20210218100818.3622317-1-gregkh@linuxfoundation.org>
References: <20210218100818.3622317-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Message-ID: <161364860464.20312.2309189013450325518.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     2ad058730606cb68e75177ee7e330e1f94ab7b4b
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/2ad058730606cb68e75177ee7e330e1f94ab7b4b
Author:        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
AuthorDate:    Thu, 18 Feb 2021 11:08:17 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Thu, 18 Feb 2021 11:39:18 

debugfs: be more robust at handling improper input in debugfs_lookup()

debugfs_lookup() doesn't like it if it is passed an illegal name
pointer, or if the filesystem isn't even initialized yet.  If either of
these happen, it will crash the system, so fix it up by properly testing
for valid input and that we are up and running before trying to find a
file in the filesystem.

Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210218100818.3622317-1-gregkh@linuxfoundation.org
---
 fs/debugfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 2fcf664..bbeb563 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -297,7 +297,7 @@ struct dentry *debugfs_lookup(const char *name, struct dentry *parent)
 {
 	struct dentry *dentry;
 
-	if (IS_ERR(parent))
+	if (!debugfs_initialized() || IS_ERR_OR_NULL(name) || IS_ERR(parent))
 		return NULL;
 
 	if (!parent)
