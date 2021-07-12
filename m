Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9F03C5199
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244248AbhGLHmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245492AbhGLHhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 639456193D;
        Mon, 12 Jul 2021 07:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075190;
        bh=9I4P98nw/TH7inHBdRHqWHOLI2uqRL4qTkQnABJ42dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+TmvcSrdyie8NiJ7FZUvOpLRlKjB6GNDJxjp1gQdT3gZ1cWnyz7lJJDPpWkjlDN0
         vFSxjDvFNVk6fSGpabE20aLF1EEsayOIuGGDRCFw6xfuplwQdhTBnogBU3CU0JkfX8
         1hshEH8PB1jo2T0FQECUugkUGN7cLQOmZ8Jxooeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 135/800] media: sh_vou: fix pm_runtime_get_sync() usage count
Date:   Mon, 12 Jul 2021 08:02:38 +0200
Message-Id: <20210712060932.034703069@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 6e8b1526db164c9d4b9dacfb9bc48e365d7c4860 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, check if the PM runtime error was caught at open time.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sh_vou.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 4ac48441f22c..ca4310e26c49 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1133,7 +1133,11 @@ static int sh_vou_open(struct file *file)
 	if (v4l2_fh_is_singular_file(file) &&
 	    vou_dev->status == SH_VOU_INITIALISING) {
 		/* First open */
-		pm_runtime_get_sync(vou_dev->v4l2_dev.dev);
+		err = pm_runtime_resume_and_get(vou_dev->v4l2_dev.dev);
+		if (err < 0) {
+			v4l2_fh_release(file);
+			goto done_open;
+		}
 		err = sh_vou_hw_init(vou_dev);
 		if (err < 0) {
 			pm_runtime_put(vou_dev->v4l2_dev.dev);
-- 
2.30.2



