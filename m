Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481D1217103
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgGGPXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729954AbgGGPXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DFB52065D;
        Tue,  7 Jul 2020 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135394;
        bh=fBu0ClO0KQXec2oBjKGmKPAybI4/hbfUxR6w24vd01g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIXdiFjUTjDIkYxdP1rFuAcrXIqygCZ4l3B0/LLxWa5oA8UAkE1dLb+gSNwX4S62M
         cfDv0pw2vhmJhjJl7o3Tyo3umTqvVYHPHR+6i0mieV3+bQX6b4wP/ohkODuWaG8LFv
         XNc2FxRLdlk/LJeeJoXwr25oKLQvicSrNRpQ8JKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 003/112] exfat: call sync_filesystem for read-only remount
Date:   Tue,  7 Jul 2020 17:16:08 +0200
Message-Id: <20200707145801.096068829@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit a0271a15cf2cf907ea5b0f2ba611123f1b7935ec ]

We need to commit dirty metadata and pages to disk
before remounting exfat as read-only.

This fixes a failure in xfstests generic/452

generic/452 does the following:
cp something <exfat>/
mount -o remount,ro <exfat>

the <exfat>/something is corrupted. because while
exfat is remounted as read-only, exfat doesn't
have a chance to commit metadata and
vfs invalidates page caches in a block device.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index c1b1ed306a485..e879801533980 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -637,10 +637,20 @@ static void exfat_free(struct fs_context *fc)
 	}
 }
 
+static int exfat_reconfigure(struct fs_context *fc)
+{
+	fc->sb_flags |= SB_NODIRATIME;
+
+	/* volume flag will be updated in exfat_sync_fs */
+	sync_filesystem(fc->root->d_sb);
+	return 0;
+}
+
 static const struct fs_context_operations exfat_context_ops = {
 	.parse_param	= exfat_parse_param,
 	.get_tree	= exfat_get_tree,
 	.free		= exfat_free,
+	.reconfigure	= exfat_reconfigure,
 };
 
 static int exfat_init_fs_context(struct fs_context *fc)
-- 
2.25.1



