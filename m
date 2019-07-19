Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A016DF1A
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfGSEc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730526AbfGSEDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF6E821882;
        Fri, 19 Jul 2019 04:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509014;
        bh=09mf2kJdR2PiDv+6yW7BPKH28yF7qDFI6ijYWPiWF0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrqMYRZDcVtEUW4vZYXvmnSvJp6zk5EQrVm9zcmTLn1g4zpK3BEbPfJLW+aUOZ7+Z
         LLqZ4D/WsqCsGs0+o+11rJYCFivEAbZUninZHOEYZWahJkWnBBCoWmW4lommu8H1lT
         uCSisXG0k2DQ36TXTJk6gzm13bgpccceYVX66scc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 021/141] drm/edid: Fix a missing-check bug in drm_load_edid_firmware()
Date:   Fri, 19 Jul 2019 00:00:46 -0400
Message-Id: <20190719040246.15945-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

[ Upstream commit 9f1f1a2dab38d4ce87a13565cf4dc1b73bef3a5f ]

In drm_load_edid_firmware(), fwstr is allocated by kstrdup(). And fwstr
is dereferenced in the following codes. However, memory allocation
functions such as kstrdup() may fail and returns NULL. Dereferencing
this null pointer may cause the kernel go wrong. Thus we should check
this kstrdup() operation.
Further, if kstrdup() returns NULL, we should return ERR_PTR(-ENOMEM) to
the caller site.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190524023222.GA5302@zhanggen-UX430UQ
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid_load.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index a4915099aaa9..a0e107abc40d 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -290,6 +290,8 @@ struct edid *drm_load_edid_firmware(struct drm_connector *connector)
 	 * the last one found one as a fallback.
 	 */
 	fwstr = kstrdup(edid_firmware, GFP_KERNEL);
+	if (!fwstr)
+		return ERR_PTR(-ENOMEM);
 	edidstr = fwstr;
 
 	while ((edidname = strsep(&edidstr, ","))) {
-- 
2.20.1

