Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63CB6463E8
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 23:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLGWNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 17:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLGWNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 17:13:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000445B5B8;
        Wed,  7 Dec 2022 14:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E9D561CC8;
        Wed,  7 Dec 2022 22:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5127C433C1;
        Wed,  7 Dec 2022 22:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670451195;
        bh=YpbjzjWC9I0eFOaFE9Bp5AlRNnZYuPHzc2mx03tDTO0=;
        h=Date:To:From:Subject:From;
        b=npo+Ulw+os8icHSTTMWeVYI1VTisMKmI9Z+NoiqCjzPF4LZiS9koyWsCcPn3zclKc
         E4vJBGB3jtYyGMXMhfUL0j3ydSDat5e/6oEv4sA7ahYIvVzlPR04gXdC82H7lFoenj
         bravBgeZhStDpYhoJqOn9iLGEtasKjpaPIeUZ0j8=
Date:   Wed, 07 Dec 2022 14:13:14 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        slava@dubeyko.com, gargaditya08@live.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount.patch added to mm-nonmm-unstable branch
Message-Id: <20221207221314.E5127C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Aditya Garg <gargaditya08@live.com>
Subject: hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
Date: Wed, 7 Dec 2022 03:05:40 +0000

Despite specifying UID and GID in mount command, the specified UID and GID
were not being assigned. This patch fixes this issue.

Link: https://lkml.kernel.org/r/C0264BF5-059C-45CF-B8DA-3A3BD2C803A2@live.com
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
--- a/fs/hfsplus/inode.c~hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount
+++ a/fs/hfsplus/inode.c
@@ -192,11 +192,11 @@ static void hfsplus_get_perms(struct ino
 	mode = be16_to_cpu(perms->mode);
 
 	i_uid_write(inode, be32_to_cpu(perms->owner));
-	if (!i_uid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || (!i_uid_read(inode) && !mode))
 		inode->i_uid = sbi->uid;
 
 	i_gid_write(inode, be32_to_cpu(perms->group));
-	if (!i_gid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_GID, &sbi->flags)) || (!i_gid_read(inode) && !mode))
 		inode->i_gid = sbi->gid;
 
 	if (dir) {
--- a/fs/hfsplus/options.c~hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount
+++ a/fs/hfsplus/options.c
@@ -140,6 +140,8 @@ int hfsplus_parse_options(char *input, s
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			}
 			break;
 		case opt_gid:
@@ -151,6 +153,8 @@ int hfsplus_parse_options(char *input, s
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			}
 			break;
 		case opt_part:
_

Patches currently in -mm which might be from gargaditya08@live.com are

hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount.patch

