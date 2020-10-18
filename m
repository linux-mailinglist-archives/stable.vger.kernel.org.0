Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD82291F70
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388943AbgJRUAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 16:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgJRTSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9633C222B9;
        Sun, 18 Oct 2020 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048723;
        bh=N5QeLT4lYf6VW3DsLZV3yTNIyO2Q9L2kglcl6ro5PDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMdnw3boagkMJEYDFlds4XBJRtPuDZdKBiAhT71Cks6dKT4/qKp9RiG1H0ZWHdxHw
         +MLU3xhz3er/2KpecPu67FEjvtvZv93PsNBoQi0wx6nzszj8XG/AYi5IbY/12/vy/3
         UmYqm3XVeEpGBfSTNXWhU7cKb/ouy7Zky7l5VzIE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.9 029/111] media: atomisp: fix memleak in ia_css_stream_create
Date:   Sun, 18 Oct 2020 15:16:45 -0400
Message-Id: <20201018191807.4052726-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
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
index a68cbb4995f0f..33a0f8ff82aa8 100644
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

