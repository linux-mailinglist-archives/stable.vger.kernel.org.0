Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F360F1719AA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgB0Nq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbgB0Nq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:46:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88062469F;
        Thu, 27 Feb 2020 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811215;
        bh=MXXrokOjUI6fldjQTvPfgDimBBeXh8U36Bp/rLg6hYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGreC+lKZ/HM4Es1ANw/qbedH1saGIsKfQbmy9cbQEiGoVwQRLIUOmvBqbFgvrgGz
         s3lQI92t94tLdLXFcHNI8is05xJVGPAgOmqS66RH0jkSX2AFGXiXZP5jvixATACELy
         rY9jfjNh0CuAnGjj7X7nyUH1u+BHX5z+7CjIFbys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.9 009/165] ext4: improve explanation of a mount failure caused by a misconfigured kernel
Date:   Thu, 27 Feb 2020 14:34:43 +0100
Message-Id: <20200227132232.476517249@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit d65d87a07476aa17df2dcb3ad18c22c154315bec upstream.

If CONFIG_QFMT_V2 is not enabled, but CONFIG_QUOTA is enabled, when a
user tries to mount a file system with the quota or project quota
enabled, the kernel will emit a very confusing messsage:

    EXT4-fs warning (device vdc): ext4_enable_quotas:5914: Failed to enable quota tracking (type=0, err=-3). Please run e2fsck to fix.
    EXT4-fs (vdc): mount failed

We will now report an explanatory message indicating which kernel
configuration options have to be enabled, to avoid customer/sysadmin
confusion.

Link: https://lore.kernel.org/r/20200215012738.565735-1-tytso@mit.edu
Google-Bug-Id: 149093531
Fixes: 7c319d328505b778 ("ext4: make quota as first class supported feature")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2743,17 +2743,11 @@ static int ext4_feature_set_ok(struct su
 		return 0;
 	}
 
-#ifndef CONFIG_QUOTA
-	if (ext4_has_feature_quota(sb) && !readonly) {
+#if !defined(CONFIG_QUOTA) || !defined(CONFIG_QFMT_V2)
+	if (!readonly && (ext4_has_feature_quota(sb) ||
+			  ext4_has_feature_project(sb))) {
 		ext4_msg(sb, KERN_ERR,
-			 "Filesystem with quota feature cannot be mounted RDWR "
-			 "without CONFIG_QUOTA");
-		return 0;
-	}
-	if (ext4_has_feature_project(sb) && !readonly) {
-		ext4_msg(sb, KERN_ERR,
-			 "Filesystem with project quota feature cannot be mounted RDWR "
-			 "without CONFIG_QUOTA");
+			 "The kernel was not built with CONFIG_QUOTA and CONFIG_QFMT_V2");
 		return 0;
 	}
 #endif  /* CONFIG_QUOTA */


