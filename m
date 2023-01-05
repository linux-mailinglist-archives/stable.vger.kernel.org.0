Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4915665EC52
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjAENIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbjAENIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:08:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671EB5C1FB
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:07:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19794B81AD0
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39460C433D2;
        Thu,  5 Jan 2023 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672924061;
        bh=JV4IgYA288s9OiFIvLOqYQSNHDTOr622m0a57g9jNM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2RhalPV8SN7h7/twHmTQ2TqClbrux4igKYtpjTzmEa3X2SfqynVt+5Fg/z+iIfeY
         MBIagOXzo+whha3Mc2vK1yDadElJewiAeuogzMh7sLCKpP2j4C9UDOHuELr3Mohzpe
         U2ItlovZWNJS0BN3O1hvmzOlrYCTwOKNEks2c520=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aditya Garg <gargaditya08@live.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 220/251] hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
Date:   Thu,  5 Jan 2023 13:55:57 +0100
Message-Id: <20230105125344.926924191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
@@ -186,11 +186,11 @@ static void hfsplus_get_perms(struct ino
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
@@ -139,6 +139,8 @@ int hfsplus_parse_options(char *input, s
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			}
 			break;
 		case opt_gid:
@@ -150,6 +152,8 @@ int hfsplus_parse_options(char *input, s
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			}
 			break;
 		case opt_part:


