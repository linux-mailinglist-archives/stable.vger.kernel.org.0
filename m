Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55732E99FE
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhADQGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbhADQC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD0B52245C;
        Mon,  4 Jan 2021 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776138;
        bh=3Cv24Vu//k+9LqcI5Km3zQxhoyl+adOYlUF9njqT6t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb3DrWAJKnHF3aZatQ+CFfriKhIWyskfxtL9Hf0NySLdkK2VyruXionv5uUaruimC
         61mo9ELsLyhgS7k6mD7N6U1GtXNVLALD8i9KNDnNa1s3n7O+C7d6R0eMtcSG3CWC5Y
         9jjsukpywN2pXNcoTk5kcmMTTiFEWquY+f/axvMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jubin Zhong <zhongjubin@huawei.com>,
        lizhe <lizhe67@huawei.com>, Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/63] jffs2: Allow setting rp_size to zero during remounting
Date:   Mon,  4 Jan 2021 16:57:01 +0100
Message-Id: <20210104155709.212682044@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lizhe <lizhe67@huawei.com>

[ Upstream commit cd3ed3c73ac671ff6b0230ccb72b8300292d3643 ]

Set rp_size to zero will be ignore during remounting.

The method to identify whether we input a remounting option of
rp_size is to check if the rp_size input is zero. It can not work
well if we pass "rp_size=0".

This patch add a bool variable "set_rp_size" to fix this problem.

Reported-by: Jubin Zhong <zhongjubin@huawei.com>
Signed-off-by: lizhe <lizhe67@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/jffs2_fs_sb.h | 1 +
 fs/jffs2/super.c       | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 778275f48a879..5a7091746f68b 100644
--- a/fs/jffs2/jffs2_fs_sb.h
+++ b/fs/jffs2/jffs2_fs_sb.h
@@ -38,6 +38,7 @@ struct jffs2_mount_opts {
 	 * users. This is implemented simply by means of not allowing the
 	 * latter users to write to the file system if the amount if the
 	 * available space is less then 'rp_size'. */
+	bool set_rp_size;
 	unsigned int rp_size;
 };
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 4fd297bdf0f3f..c523adaca79f3 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -88,7 +88,7 @@ static int jffs2_show_options(struct seq_file *s, struct dentry *root)
 
 	if (opts->override_compr)
 		seq_printf(s, ",compr=%s", jffs2_compr_name(opts->compr));
-	if (opts->rp_size)
+	if (opts->set_rp_size)
 		seq_printf(s, ",rp_size=%u", opts->rp_size / 1024);
 
 	return 0;
@@ -206,6 +206,7 @@ static int jffs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		if (opt > c->mtd->size)
 			return invalf(fc, "jffs2: Too large reserve pool specified, max is %llu KB",
 				      c->mtd->size / 1024);
+		c->mount_opts.set_rp_size = true;
 		c->mount_opts.rp_size = opt;
 		break;
 	default:
@@ -225,8 +226,10 @@ static inline void jffs2_update_mount_opts(struct fs_context *fc)
 		c->mount_opts.override_compr = new_c->mount_opts.override_compr;
 		c->mount_opts.compr = new_c->mount_opts.compr;
 	}
-	if (new_c->mount_opts.rp_size)
+	if (new_c->mount_opts.set_rp_size) {
+		c->mount_opts.set_rp_size = new_c->mount_opts.set_rp_size;
 		c->mount_opts.rp_size = new_c->mount_opts.rp_size;
+	}
 	mutex_unlock(&c->alloc_sem);
 }
 
-- 
2.27.0



