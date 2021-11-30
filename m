Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656D8463896
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244162AbhK3PFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243799AbhK3O6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F66AC0613B5;
        Tue, 30 Nov 2021 06:51:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17661B81A22;
        Tue, 30 Nov 2021 14:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C7EC53FCF;
        Tue, 30 Nov 2021 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283901;
        bh=mvfh7oVZeXZA36lXXXo7Z+ltFgM+teaqeOEjVs7N4CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFSjDA9rdY/iWsUjnZLP5aGt9WwdukSfLaelFl79hVmW2bcMZzrmUBhy/CbdtbmF5
         LewPa00iUFaL7zRyKite7EwxWOVRwxZ5/psNiIWkAarEMInfNdys5PcMOHAiA7SxlV
         ehxjV5ARM5aLDE9zC+rRxzcp0X53F9CoBn7VubiBN3K+RucG6S4G1cXooffA470A7N
         gm79QG+ggrpYGjULMKLWvXoSt6vNwI2XWITkN3NheJjcFoXPsMZjboedfc7XFtybk1
         O//+yzp+NbviN2yz6vrq6U1Q5Z9xqSXTySYhz2zerepkMGXAx1qfkvc6VSnmg1LDX5
         aItWOUtWUgdTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.10 35/43] xen: flag xen_drm_front to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:50:12 -0500
Message-Id: <20211130145022.945517-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 1c669938c31b6e2a0d5149c3c6257ca9df6cb100 ]

Similar to the virtual frame buffer (vfb) the pv display driver is not
essential for booting the system. Set the respective flag.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-3-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xen/xen_drm_front.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xen/xen_drm_front.c b/drivers/gpu/drm/xen/xen_drm_front.c
index 8ea91542b567a..a2789ac2d4540 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -783,6 +783,7 @@ static struct xenbus_driver xen_driver = {
 	.probe = xen_drv_probe,
 	.remove = xen_drv_remove,
 	.otherend_changed = displback_changed,
+	.not_essential = true,
 };
 
 static int __init xen_drv_init(void)
-- 
2.33.0

