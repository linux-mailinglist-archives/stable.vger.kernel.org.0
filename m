Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8002816321D
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgBRUBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgBRUBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6CB24670;
        Tue, 18 Feb 2020 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056063;
        bh=kGdLVHL/THTjJhhpqr03GaJod5K4yM68dteKfBWbwVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNheNY/crsjKq/W8a7qs4p2ccH+WZz/FBX3OpqvtdoyFL4Lp6p/eaYMJNDYGTcW9m
         KkmfIaJ5Gx8SR8pOmPqIGkdS6Yh6wzDmRRdpnNiljHvDDNTKZF08ySJCiaNuiWrUVz
         AFwfGCt7i4bKAFOa10oecBn2UZzlxW/Rmnj4/+L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.5 20/80] ext4: improve explanation of a mount failure caused by a misconfigured kernel
Date:   Tue, 18 Feb 2020 20:54:41 +0100
Message-Id: <20200218190434.192702260@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
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
@@ -2964,17 +2964,11 @@ static int ext4_feature_set_ok(struct su
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


