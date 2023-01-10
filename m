Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5556649F7
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbjAJS2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239304AbjAJS1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:27:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637F8633A7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:23:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18C14B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487CDC433EF;
        Tue, 10 Jan 2023 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374977;
        bh=a5YlWnWmTHLR+tA/IesIk1jVQD9pXdX3MKABXMyf6EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1OJPG46VVnjPQGOzxFsVpM69FLcSUNPtJMnkXDXyo+86xb8LayahnyNFmrnFT2WCI
         wiQaBDHaYbElsbWGOqP9T0MnZy3o0ZkCF/KOrrEv3S/QGJD3aYl5T9Oqx2Ow3kLou3
         6EzD+wneXsEv4lXe2EHJXfh7NKVAKfSfzMOp9Cds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aditya Garg <gargaditya08@live.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 038/290] hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
Date:   Tue, 10 Jan 2023 19:02:10 +0100
Message-Id: <20230110180032.896690089@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

commit 9f2b5debc07073e6dfdd774e3594d0224b991927 upstream.

Despite specifying UID and GID in mount command, the specified UID and GID
were not being assigned. This patch fixes this issue.

Link: https://lkml.kernel.org/r/C0264BF5-059C-45CF-B8DA-3A3BD2C803A2@live.com
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/hfsplus_fs.h |    2 ++
 fs/hfsplus/inode.c      |    4 ++--
 fs/hfsplus/options.c    |    4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -190,11 +190,11 @@ static void hfsplus_get_perms(struct ino
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
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
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


