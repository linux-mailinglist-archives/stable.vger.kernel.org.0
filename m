Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72B4637BB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbhK3Ozl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243109AbhK3OyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCBAC061373;
        Tue, 30 Nov 2021 06:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68A91B81A2B;
        Tue, 30 Nov 2021 14:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F2AC53FD0;
        Tue, 30 Nov 2021 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283752;
        bh=hT3aGfUZtBFN7mjve8TZ4k4c9lSYCLKWOPLX7f4q8tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geZ+47HHdWTz21zPbCanXvm4heCBScEJvStN+tjdivUFTLWZU/rj2rKKn5qXR6msT
         mesrYI4vEK83SKu7a/KZBdoHfQJ5XWjNzZIo5M1CzXcUZhnEENpzfAOIZYeAJlGJ9d
         zRZgDyiLA5/9IxKk6juzT5sjnwKlnLHMZPDXCWjp2+l95XSa0lwZFyW0G6AcbEhQ8l
         M3sfOgya70Da4E2K/Gfy+9yVaL36UMgUeaMxWIGkjSLa9n+2t8H/bS3Embo41VnlLu
         svbxB4ixe7Da5iYv0BO/ozcEi0TMpETlRRElpJBXuZFpzGwu9TjVrXwx+j38aXYaDH
         ON75XRjcRoCZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.15 49/68] xen: flag xen_drm_front to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:46:45 -0500
Message-Id: <20211130144707.944580-49-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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
index 9f14d99c763c2..bc7605324db39 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -773,6 +773,7 @@ static struct xenbus_driver xen_driver = {
 	.probe = xen_drv_probe,
 	.remove = xen_drv_remove,
 	.otherend_changed = displback_changed,
+	.not_essential = true,
 };
 
 static int __init xen_drv_init(void)
-- 
2.33.0

