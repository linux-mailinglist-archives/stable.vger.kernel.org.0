Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4216F291E61
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgJRTwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgJRTVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A0B222E9;
        Sun, 18 Oct 2020 19:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048861;
        bh=RbRdRmxmA7c51+g6PuhXswlxwb3qBKIwuI4P+E8fAes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiMsrNAn5lz6dRx3YwPdQzW/CiedzQXKVFyy+yRE8A4zrTL6FiuLUVdtfIZlSViUv
         lfBIAEUetpvAPFWp/hSrspcbjkkhi42qfXxyS4mQs/wBbvGFN9XoGX0h6uRZBIxoTb
         7aaHHGW30nqWWOSAET+4JnVR5bJ9T/SZTQFqWoag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.8 028/101] media: atomisp: fix memleak in ia_css_stream_create
Date:   Sun, 18 Oct 2020 15:19:13 -0400
Message-Id: <20201018192026.4053674-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit c1bca5b5ced0cbd779d56f60cdbc9f5e6f6449fe ]

When aspect_ratio_crop_init() fails, curr_stream needs
to be freed just like what we've done in the following
error paths. However, current code is returning directly
and ends up leaking memory.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index 54434c2dbaf90..8473e14370747 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -9521,7 +9521,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 	if (err)
 	{
 		IA_CSS_LEAVE_ERR(err);
-		return err;
+		goto ERR;
 	}
 #endif
 	for (i = 0; i < num_pipes; i++)
-- 
2.25.1

