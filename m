Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE8178025
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbgCCRy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732612AbgCCRy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:54:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2E5215A4;
        Tue,  3 Mar 2020 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258098;
        bh=RchmEYyTUEL8AkXFS0vGV7V164wLZUymJTRDUL3USm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHuhx7PWTiWkni4HGxbC8b9wjLkTH8lup3jbJj20x49gALMOo7bwH63jBPF0hF74e
         D4yeRwEDUKqdO0SnnMUAplTLoIRpMzdsVzwTHvtXfoNyd2Smd4scXCjy1+oByb3Ktl
         4lJmzQQA+x79QdWMGNCZjoNBvYsqzaOGzohV+vOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suraj Jitindar Singh <surajjs@amazon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 070/152] ext4: potential crash on allocation error in ext4_alloc_flex_bg_array()
Date:   Tue,  3 Mar 2020 18:42:48 +0100
Message-Id: <20200303174310.405674611@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 37b0b6b8b99c0e1c1f11abbe7cf49b6d03795b3f upstream.

If sbi->s_flex_groups_allocated is zero and the first allocation fails
then this code will crash.  The problem is that "i--" will set "i" to
-1 but when we compare "i >= sbi->s_flex_groups_allocated" then the -1
is type promoted to unsigned and becomes UINT_MAX.  Since UINT_MAX
is more than zero, the condition is true so we call kvfree(new_groups[-1]).
The loop will carry on freeing invalid memory until it crashes.

Fixes: 7c990728b99e ("ext4: fix potential race between s_flex_groups online resizing and access")
Reviewed-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20200228092142.7irbc44yaz3by7nb@kili.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2343,7 +2343,7 @@ int ext4_alloc_flex_bg_array(struct supe
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct flex_groups **old_groups, **new_groups;
-	int size, i;
+	int size, i, j;
 
 	if (!sbi->s_log_groups_per_flex)
 		return 0;
@@ -2364,8 +2364,8 @@ int ext4_alloc_flex_bg_array(struct supe
 					 sizeof(struct flex_groups)),
 					 GFP_KERNEL);
 		if (!new_groups[i]) {
-			for (i--; i >= sbi->s_flex_groups_allocated; i--)
-				kvfree(new_groups[i]);
+			for (j = sbi->s_flex_groups_allocated; j < i; j++)
+				kvfree(new_groups[j]);
 			kvfree(new_groups);
 			ext4_msg(sb, KERN_ERR,
 				 "not enough memory for %d flex groups", size);


