Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA891483CC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403880AbgAXL10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391630AbgAXL1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:27:25 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD099206D4;
        Fri, 24 Jan 2020 11:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865244;
        bh=UG6DVkPTkCDOyF+/gG97qzFQZgKFrvVKu/YlrXfwUQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZL04jboQ8v9mMDCOwjMaoXf6WcJ6gwz1zxugCkABNnG2QxbexI3Tz8heijAwSSIB
         DGOt3anVifwf3mU3JPhKwn9Y/RJSkwFPs2WAuKdQ0QiYuKLdmocMNnYCSTR0YYvkLO
         +aG/jjh/LCA5siNDBbGcLfz720nCD/exkprz8ROA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sean Paul <sean@poorly.run>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 480/639] drm/panel: make drm_panel.h self-contained
Date:   Fri, 24 Jan 2020 10:30:50 +0100
Message-Id: <20200124093148.439717975@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit bf3f5e98559360661a3d2af340d46522512c0b00 ]

Fix build warning if drm_panel.h is built with CONFIG_OF=n or
CONFIG_DRM_PANEL=n and included without the prerequisite err.h:

./include/drm/drm_panel.h: In function ‘of_drm_find_panel’:
./include/drm/drm_panel.h:203:9: error: implicit declaration of function ‘ERR_PTR’ [-Werror=implicit-function-declaration]
  return ERR_PTR(-ENODEV);
         ^~~~~~~
./include/drm/drm_panel.h:203:9: error: returning ‘int’ from a function with return type ‘struct drm_panel *’ makes pointer from integer without a cast [-Werror=int-conversion]
  return ERR_PTR(-ENODEV);
         ^~~~~~~~~~~~~~~~

Fixes: 5fa8e4a22182 ("drm/panel: Make of_drm_find_panel() return an ERR_PTR() instead of NULL")
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Sean Paul <sean@poorly.run>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190718161507.2047-2-sam@ravnborg.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_panel.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/drm_panel.h b/include/drm/drm_panel.h
index 777814755fa62..675aa1e876ce6 100644
--- a/include/drm/drm_panel.h
+++ b/include/drm/drm_panel.h
@@ -24,6 +24,7 @@
 #ifndef __DRM_PANEL_H__
 #define __DRM_PANEL_H__
 
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/list.h>
 
-- 
2.20.1



