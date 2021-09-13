Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F740936C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbhIMOVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243754AbhIMOTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87136610D1;
        Mon, 13 Sep 2021 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540741;
        bh=Uvy48YBSvTNhnWNU58N9edTWbSO+dtb3JbkoEzJbd6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWjao+MqENVFa0d7QYvQo23fW20sLtH+3lpqBMlw+E+PVpBSWM8h5ZN+Rto+U+yjn
         Xw1/fF0wXxIXSx3z3OVGd265PBAA8F1B0XZ7lFLWEI0XvVELe0mh0G3kiUtjKxfJKm
         KiIF58oVkmbmFNZc8i0tSmCyXxtDZojJGCMpKnSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 016/334] isofs: joliet: Fix iocharset=utf8 mount option
Date:   Mon, 13 Sep 2021 15:11:10 +0200
Message-Id: <20210913131113.958647342@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 28ce50f8d96ec9035f60c9348294ea26b94db944 ]

Currently iocharset=utf8 mount option is broken. To use UTF-8 as iocharset,
it is required to use utf8 mount option.

Fix iocharset=utf8 mount option to use be equivalent to the utf8 mount
option.

If UTF-8 as iocharset is used then s_nls_iocharset is set to NULL. So
simplify code around, remove s_utf8 field as to distinguish between UTF-8
and non-UTF-8 it is needed just to check if s_nls_iocharset is set to NULL
or not.

Link: https://lore.kernel.org/r/20210808162453.1653-5-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c  | 27 +++++++++++++--------------
 fs/isofs/isofs.h  |  1 -
 fs/isofs/joliet.c |  4 +---
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 21edc423b79f..678e2c51b855 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -155,7 +155,6 @@ struct iso9660_options{
 	unsigned int overriderockperm:1;
 	unsigned int uid_set:1;
 	unsigned int gid_set:1;
-	unsigned int utf8:1;
 	unsigned char map;
 	unsigned char check;
 	unsigned int blocksize;
@@ -356,7 +355,6 @@ static int parse_options(char *options, struct iso9660_options *popt)
 	popt->gid = GLOBAL_ROOT_GID;
 	popt->uid = GLOBAL_ROOT_UID;
 	popt->iocharset = NULL;
-	popt->utf8 = 0;
 	popt->overriderockperm = 0;
 	popt->session=-1;
 	popt->sbsector=-1;
@@ -389,10 +387,13 @@ static int parse_options(char *options, struct iso9660_options *popt)
 		case Opt_cruft:
 			popt->cruft = 1;
 			break;
+#ifdef CONFIG_JOLIET
 		case Opt_utf8:
-			popt->utf8 = 1;
+			kfree(popt->iocharset);
+			popt->iocharset = kstrdup("utf8", GFP_KERNEL);
+			if (!popt->iocharset)
+				return 0;
 			break;
-#ifdef CONFIG_JOLIET
 		case Opt_iocharset:
 			kfree(popt->iocharset);
 			popt->iocharset = match_strdup(&args[0]);
@@ -495,7 +496,6 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 	if (sbi->s_nocompress)		seq_puts(m, ",nocompress");
 	if (sbi->s_overriderockperm)	seq_puts(m, ",overriderockperm");
 	if (sbi->s_showassoc)		seq_puts(m, ",showassoc");
-	if (sbi->s_utf8)		seq_puts(m, ",utf8");
 
 	if (sbi->s_check)		seq_printf(m, ",check=%c", sbi->s_check);
 	if (sbi->s_mapping)		seq_printf(m, ",map=%c", sbi->s_mapping);
@@ -518,9 +518,10 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",fmode=%o", sbi->s_fmode);
 
 #ifdef CONFIG_JOLIET
-	if (sbi->s_nls_iocharset &&
-	    strcmp(sbi->s_nls_iocharset->charset, CONFIG_NLS_DEFAULT) != 0)
+	if (sbi->s_nls_iocharset)
 		seq_printf(m, ",iocharset=%s", sbi->s_nls_iocharset->charset);
+	else
+		seq_puts(m, ",iocharset=utf8");
 #endif
 	return 0;
 }
@@ -863,14 +864,13 @@ root_found:
 	sbi->s_nls_iocharset = NULL;
 
 #ifdef CONFIG_JOLIET
-	if (joliet_level && opt.utf8 == 0) {
+	if (joliet_level) {
 		char *p = opt.iocharset ? opt.iocharset : CONFIG_NLS_DEFAULT;
-		sbi->s_nls_iocharset = load_nls(p);
-		if (! sbi->s_nls_iocharset) {
-			/* Fail only if explicit charset specified */
-			if (opt.iocharset)
+		if (strcmp(p, "utf8") != 0) {
+			sbi->s_nls_iocharset = opt.iocharset ?
+				load_nls(opt.iocharset) : load_nls_default();
+			if (!sbi->s_nls_iocharset)
 				goto out_freesbi;
-			sbi->s_nls_iocharset = load_nls_default();
 		}
 	}
 #endif
@@ -886,7 +886,6 @@ root_found:
 	sbi->s_gid = opt.gid;
 	sbi->s_uid_set = opt.uid_set;
 	sbi->s_gid_set = opt.gid_set;
-	sbi->s_utf8 = opt.utf8;
 	sbi->s_nocompress = opt.nocompress;
 	sbi->s_overriderockperm = opt.overriderockperm;
 	/*
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 055ec6c586f7..dcdc191ed183 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -44,7 +44,6 @@ struct isofs_sb_info {
 	unsigned char s_session;
 	unsigned int  s_high_sierra:1;
 	unsigned int  s_rock:2;
-	unsigned int  s_utf8:1;
 	unsigned int  s_cruft:1; /* Broken disks with high byte of length
 				  * containing junk */
 	unsigned int  s_nocompress:1;
diff --git a/fs/isofs/joliet.c b/fs/isofs/joliet.c
index be8b6a9d0b92..c0f04a1e7f69 100644
--- a/fs/isofs/joliet.c
+++ b/fs/isofs/joliet.c
@@ -41,14 +41,12 @@ uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls)
 int
 get_joliet_filename(struct iso_directory_record * de, unsigned char *outname, struct inode * inode)
 {
-	unsigned char utf8;
 	struct nls_table *nls;
 	unsigned char len = 0;
 
-	utf8 = ISOFS_SB(inode->i_sb)->s_utf8;
 	nls = ISOFS_SB(inode->i_sb)->s_nls_iocharset;
 
-	if (utf8) {
+	if (!nls) {
 		len = utf16s_to_utf8s((const wchar_t *) de->name,
 				de->name_len[0] >> 1, UTF16_BIG_ENDIAN,
 				outname, PAGE_SIZE);
-- 
2.30.2



