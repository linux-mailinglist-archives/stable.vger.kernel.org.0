Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A243CE507
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbhGSPrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349484AbhGSPpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 915E06113A;
        Mon, 19 Jul 2021 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711912;
        bh=2l3H4EHNYgT3yM4ZUxgFppRbrJS+2LeXY3D4BoXwaQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6smRn2ml1Cg7lAlHmlnZgKoToHpl5ko0C+qqZ0qX3uFQHIFYKTrvBWPDaAGaE4dE
         jQo0D7/OY6v0UaV37N1ChI0kpTfVNxbpIF79sXo5gdKj7f6VVu0hJ2DuBgES+yA5Rn
         yH7D1VyeO4K5R0Z7hHpsfpNWcaJvSoBHlosJTUUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 178/292] f2fs: compress: fix to disallow temp extension
Date:   Mon, 19 Jul 2021 16:54:00 +0200
Message-Id: <20210719144948.349908853@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 4a67d9b07ac8dce7f1034e0d887f2f4ee00fe118 ]

This patch restricts to configure compress extension as format of:

 [filename + '.' + extension]

rather than:

 [filename + '.' + extension + (optional: '.' + temp extension)]

in order to avoid to enable compression incorrectly:

1. compress_extension=so
2. touch file.soa
3. touch file.so.tmp

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 17bd072a5d39..11aafe93180c 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -153,7 +153,8 @@ fail_drop:
 	return ERR_PTR(err);
 }
 
-static inline int is_extension_exist(const unsigned char *s, const char *sub)
+static inline int is_extension_exist(const unsigned char *s, const char *sub,
+						bool tmp_ext)
 {
 	size_t slen = strlen(s);
 	size_t sublen = strlen(sub);
@@ -169,6 +170,13 @@ static inline int is_extension_exist(const unsigned char *s, const char *sub)
 	if (slen < sublen + 2)
 		return 0;
 
+	if (!tmp_ext) {
+		/* file has no temp extension */
+		if (s[slen - sublen - 1] != '.')
+			return 0;
+		return !strncasecmp(s + slen - sublen, sub, sublen);
+	}
+
 	for (i = 1; i < slen - sublen; i++) {
 		if (s[i] != '.')
 			continue;
@@ -194,7 +202,7 @@ static inline void set_file_temperature(struct f2fs_sb_info *sbi, struct inode *
 	hot_count = sbi->raw_super->hot_ext_count;
 
 	for (i = 0; i < cold_count + hot_count; i++) {
-		if (is_extension_exist(name, extlist[i]))
+		if (is_extension_exist(name, extlist[i], true))
 			break;
 	}
 
@@ -295,7 +303,7 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
 	hot_count = sbi->raw_super->hot_ext_count;
 
 	for (i = cold_count; i < cold_count + hot_count; i++) {
-		if (is_extension_exist(name, extlist[i])) {
+		if (is_extension_exist(name, extlist[i], false)) {
 			up_read(&sbi->sb_lock);
 			return;
 		}
@@ -306,7 +314,7 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
 	ext = F2FS_OPTION(sbi).extensions;
 
 	for (i = 0; i < ext_cnt; i++) {
-		if (!is_extension_exist(name, ext[i]))
+		if (!is_extension_exist(name, ext[i], false))
 			continue;
 
 		set_compress_context(inode);
-- 
2.30.2



