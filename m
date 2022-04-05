Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EF84F2542
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiDEHsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiDEHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6925A9230F;
        Tue,  5 Apr 2022 00:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E445B81B92;
        Tue,  5 Apr 2022 07:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480ADC340EE;
        Tue,  5 Apr 2022 07:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144694;
        bh=LecwaT5KVLT3oBNuiWE6AgTFdlv3PkHkGM+dBuO+TkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxHXus2ek6GYK0WNwOPkpZLJoFGt3tmvNr3ntOWWW0KlEbXB/DzrKE5irTbtQ6Axi
         wxayW4alpfAbr3gcz6vgWmm9b6ypRg9VSqelYGtW5oGpkTDfU+FlHyle98UyQzBdme
         69W6PskK14UOP8umbswPr0KVh0BIF3GI9t7V2nYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.17 0135/1126] ext4: make mb_optimize_scan option work with set/unset mount cmd
Date:   Tue,  5 Apr 2022 09:14:42 +0200
Message-Id: <20220405070411.540956652@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 27b38686a3bb601db48901dbc4e2fc5d77ffa2c1 upstream.

After moving to the new mount API, mb_optimize_scan mount option
handling was not working as expected due to the parsed value always
being overwritten by default. Refactor and fix this to the expected
behavior described below:

*  mb_optimize_scan=1 - On
*  mb_optimize_scan=0 - Off
*  mb_optimize_scan not passed - On if no. of BGs > threshold else off
*  Remounts retain previous value unless we explicitly pass the option
   with a new value

Fixes: cebe85d570cf ("ext4: switch to the new mount api")
Cc: stable@kernel.org
Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/c98970fe99f26718586d02e942f293300fb48ef3.1646732698.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2021,12 +2021,12 @@ static int ext4_set_test_dummy_encryptio
 #define EXT4_SPEC_s_commit_interval		(1 << 16)
 #define EXT4_SPEC_s_fc_debug_max_replay		(1 << 17)
 #define EXT4_SPEC_s_sb_block			(1 << 18)
+#define EXT4_SPEC_mb_optimize_scan		(1 << 19)
 
 struct ext4_fs_context {
 	char		*s_qf_names[EXT4_MAXQUOTAS];
 	char		*test_dummy_enc_arg;
 	int		s_jquota_fmt;	/* Format of quota to use */
-	int		mb_optimize_scan;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
 #endif
@@ -2451,12 +2451,17 @@ static int ext4_parse_param(struct fs_co
 			ctx_clear_mount_opt(ctx, m->mount_opt);
 		return 0;
 	case Opt_mb_optimize_scan:
-		if (result.int_32 != 0 && result.int_32 != 1) {
+		if (result.int_32 == 1) {
+			ctx_set_mount_opt2(ctx, EXT4_MOUNT2_MB_OPTIMIZE_SCAN);
+			ctx->spec |= EXT4_SPEC_mb_optimize_scan;
+		} else if (result.int_32 == 0) {
+			ctx_clear_mount_opt2(ctx, EXT4_MOUNT2_MB_OPTIMIZE_SCAN);
+			ctx->spec |= EXT4_SPEC_mb_optimize_scan;
+		} else {
 			ext4_msg(NULL, KERN_WARNING,
 				 "mb_optimize_scan should be set to 0 or 1.");
 			return -EINVAL;
 		}
-		ctx->mb_optimize_scan = result.int_32;
 		return 0;
 	}
 
@@ -4369,7 +4374,6 @@ static int __ext4_fill_super(struct fs_c
 
 	/* Set defaults for the variables that will be set during parsing */
 	ctx->journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
-	ctx->mb_optimize_scan = DEFAULT_MB_OPTIMIZE_SCAN;
 
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
 	sbi->s_sectors_written_start =
@@ -5320,12 +5324,12 @@ no_journal:
 	 * turned off by passing "mb_optimize_scan=0". This can also be
 	 * turned on forcefully by passing "mb_optimize_scan=1".
 	 */
-	if (ctx->mb_optimize_scan == 1)
-		set_opt2(sb, MB_OPTIMIZE_SCAN);
-	else if (ctx->mb_optimize_scan == 0)
-		clear_opt2(sb, MB_OPTIMIZE_SCAN);
-	else if (sbi->s_groups_count >= MB_DEFAULT_LINEAR_SCAN_THRESHOLD)
-		set_opt2(sb, MB_OPTIMIZE_SCAN);
+	if (!(ctx->spec & EXT4_SPEC_mb_optimize_scan)) {
+		if (sbi->s_groups_count >= MB_DEFAULT_LINEAR_SCAN_THRESHOLD)
+			set_opt2(sb, MB_OPTIMIZE_SCAN);
+		else
+			clear_opt2(sb, MB_OPTIMIZE_SCAN);
+	}
 
 	err = ext4_mb_init(sb);
 	if (err) {


