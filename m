Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43299408C74
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhIMNTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238378AbhIMNST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F8CD6103B;
        Mon, 13 Sep 2021 13:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539023;
        bh=5RQoPvDgGfLZAQ/8yfoPzU6wW/Z5WH6feRmCOJAAJeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9yNPSK6OmBuwPrNX+6DYHPZBYVZt6JHASHs4siUolX3oE2ug0fsQxoeUfSI8/Geb
         VobIeP+RJQTjDkwDeZlXWZWVzFFWfjJAg/SJjcYQBFjQC2sCwep0/YHRv8Kl1yIOze
         gQ7sDeo6GjuXVmDvX4Rn6Pwa+gujV0vfszVfMXCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/144] udf: Fix iocharset=utf8 mount option
Date:   Mon, 13 Sep 2021 15:13:14 +0200
Message-Id: <20210913131048.410715831@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b645333443712d2613e4e863f81090d5dc509657 ]

Currently iocharset=utf8 mount option is broken. To use UTF-8 as iocharset,
it is required to use utf8 mount option.

Fix iocharset=utf8 mount option to use be equivalent to the utf8 mount
option.

If UTF-8 as iocharset is used then s_nls_map is set to NULL. So simplify
code around, remove UDF_FLAG_NLS_MAP and UDF_FLAG_UTF8 flags as to
distinguish between UTF-8 and non-UTF-8 it is needed just to check if
s_nls_map set to NULL or not.

Link: https://lore.kernel.org/r/20210808162453.1653-4-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c   | 50 ++++++++++++++++++------------------------------
 fs/udf/udf_sb.h  |  2 --
 fs/udf/unicode.c |  4 ++--
 3 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index a1efcf0593cb..5663bae95700 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -343,10 +343,10 @@ static int udf_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",lastblock=%u", sbi->s_last_block);
 	if (sbi->s_anchor != 0)
 		seq_printf(seq, ",anchor=%u", sbi->s_anchor);
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-		seq_puts(seq, ",utf8");
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP) && sbi->s_nls_map)
+	if (sbi->s_nls_map)
 		seq_printf(seq, ",iocharset=%s", sbi->s_nls_map->charset);
+	else
+		seq_puts(seq, ",iocharset=utf8");
 
 	return 0;
 }
@@ -551,19 +551,24 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			/* Ignored (never implemented properly) */
 			break;
 		case Opt_utf8:
-			uopt->flags |= (1 << UDF_FLAG_UTF8);
+			if (!remount) {
+				unload_nls(uopt->nls_map);
+				uopt->nls_map = NULL;
+			}
 			break;
 		case Opt_iocharset:
 			if (!remount) {
-				if (uopt->nls_map)
-					unload_nls(uopt->nls_map);
-				/*
-				 * load_nls() failure is handled later in
-				 * udf_fill_super() after all options are
-				 * parsed.
-				 */
+				unload_nls(uopt->nls_map);
+				uopt->nls_map = NULL;
+			}
+			/* When nls_map is not loaded then UTF-8 is used */
+			if (!remount && strcmp(args[0].from, "utf8") != 0) {
 				uopt->nls_map = load_nls(args[0].from);
-				uopt->flags |= (1 << UDF_FLAG_NLS_MAP);
+				if (!uopt->nls_map) {
+					pr_err("iocharset %s not found\n",
+						args[0].from);
+					return 0;
+				}
 			}
 			break;
 		case Opt_uforget:
@@ -2152,21 +2157,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	if (!udf_parse_options((char *)options, &uopt, false))
 		goto parse_options_failure;
 
-	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
-	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
-		udf_err(sb, "utf8 cannot be combined with iocharset\n");
-		goto parse_options_failure;
-	}
-	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map) {
-		uopt.nls_map = load_nls_default();
-		if (!uopt.nls_map)
-			uopt.flags &= ~(1 << UDF_FLAG_NLS_MAP);
-		else
-			udf_debug("Using default NLS map\n");
-	}
-	if (!(uopt.flags & (1 << UDF_FLAG_NLS_MAP)))
-		uopt.flags |= (1 << UDF_FLAG_UTF8);
-
 	fileset.logicalBlockNum = 0xFFFFFFFF;
 	fileset.partitionReferenceNum = 0xFFFF;
 
@@ -2321,8 +2311,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 error_out:
 	iput(sbi->s_vat_inode);
 parse_options_failure:
-	if (uopt.nls_map)
-		unload_nls(uopt.nls_map);
+	unload_nls(uopt.nls_map);
 	if (lvid_open)
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
@@ -2372,8 +2361,7 @@ static void udf_put_super(struct super_block *sb)
 	sbi = UDF_SB(sb);
 
 	iput(sbi->s_vat_inode);
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-		unload_nls(sbi->s_nls_map);
+	unload_nls(sbi->s_nls_map);
 	if (!sb_rdonly(sb))
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 3d83be54c474..8eace7a633d3 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -20,8 +20,6 @@
 #define UDF_FLAG_UNDELETE		6
 #define UDF_FLAG_UNHIDE			7
 #define UDF_FLAG_VARCONV		8
-#define UDF_FLAG_NLS_MAP		9
-#define UDF_FLAG_UTF8			10
 #define UDF_FLAG_UID_FORGET     11    /* save -1 for uid to disk */
 #define UDF_FLAG_GID_FORGET     12
 #define UDF_FLAG_UID_SET	13
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 5fcfa96463eb..622569007b53 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -177,7 +177,7 @@ static int udf_name_from_CS0(struct super_block *sb,
 		return 0;
 	}
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
+	if (UDF_SB(sb)->s_nls_map)
 		conv_f = UDF_SB(sb)->s_nls_map->uni2char;
 	else
 		conv_f = NULL;
@@ -285,7 +285,7 @@ static int udf_name_to_CS0(struct super_block *sb,
 	if (ocu_max_len <= 0)
 		return 0;
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
+	if (UDF_SB(sb)->s_nls_map)
 		conv_f = UDF_SB(sb)->s_nls_map->char2uni;
 	else
 		conv_f = NULL;
-- 
2.30.2



