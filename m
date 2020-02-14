Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCA115EF3F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389273AbgBNQCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389265AbgBNQCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4B024676;
        Fri, 14 Feb 2020 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696130;
        bh=HDNfsmOpb9MK1yv2aN+/E97lXV9iDVXQh3D1EFAviJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCeP60jhUGVvFg+8vLNWolMx7SIrbn2HxbQKN5BzRWlP/8Kw/Uts61Tcsm/XVi3iO
         pPFhJSsLqPnpW2WD/ozY94wtFflbVGLsfkmpq224GOocSGdZxtN6F73tbG5L/1rdCs
         weoyd/ubyLDYNWSWN3MzPqXIyn+mpuvgkTR204MU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 015/459] media: meson: add missing allocation failure check on new_buf
Date:   Fri, 14 Feb 2020 10:54:25 -0500
Message-Id: <20200214160149.11681-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 11e0e167d071a28288a7a0a211d48c571d19b56f ]

Currently if the allocation of new_buf fails then a null pointer
dereference occurs when assiging new_buf->vb. Avoid this by returning
early on a memory allocation failure as there is not much more can
be done at this point.

Addresses-Coverity: ("Dereference null return")

Fixes: 3e7f51bd9607 ("media: meson: add v4l2 m2m video decoder driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/meson/vdec/vdec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/meson/vdec/vdec.c b/drivers/staging/media/meson/vdec/vdec.c
index 0a1a04fd5d13d..8dd1396909d7e 100644
--- a/drivers/staging/media/meson/vdec/vdec.c
+++ b/drivers/staging/media/meson/vdec/vdec.c
@@ -133,6 +133,8 @@ vdec_queue_recycle(struct amvdec_session *sess, struct vb2_buffer *vb)
 	struct amvdec_buffer *new_buf;
 
 	new_buf = kmalloc(sizeof(*new_buf), GFP_KERNEL);
+	if (!new_buf)
+		return;
 	new_buf->vb = vb;
 
 	mutex_lock(&sess->bufs_recycle_lock);
-- 
2.20.1

