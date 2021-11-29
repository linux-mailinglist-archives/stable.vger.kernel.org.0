Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3DD46265F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhK2WvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbhK2WuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:50:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B151C12B6B2;
        Mon, 29 Nov 2021 10:38:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A26B81630;
        Mon, 29 Nov 2021 18:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41142C53FC7;
        Mon, 29 Nov 2021 18:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211099;
        bh=PNfJYavmxmD1mSQO4+BCCkDlZAxZcQqzg92mqCseBfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTtUGidkrvJ785D+7q9nghqgYz10p4zKIXnPO2S6Zs1IMmFdYeyYSl58cT+A6W0Kz
         pcChNDOxSCBMgHR4llkGYUgVoFRsRML3jwx4Z1aVyon8bKD18xIbFC45AmG+HU/04P
         Jc8kFEvlsEK1Y0AVU+tZdwBs9J3ZZcy1JwuEW4zA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oskar Senft <osk@google.com>,
        Joel Stanley <joel@jms.id.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/179] drm/aspeed: Fix vga_pw sysfs output
Date:   Mon, 29 Nov 2021 19:18:06 +0100
Message-Id: <20211129181721.961334674@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit b4a6aaeaf4aa79f23775f6688a7e8db3ee1c1303 ]

Before the drm driver had support for this file there was a driver that
exposed the contents of the vga password register to userspace. It would
present the entire register instead of interpreting it.

The drm implementation chose to mask of the lower bit, without explaining
why. This breaks the existing userspace, which is looking for 0xa8 in
the lower byte.

Change our implementation to expose the entire register.

Fixes: 696029eb36c0 ("drm/aspeed: Add sysfs for output settings")
Reported-by: Oskar Senft <osk@google.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>
Tested-by: Oskar Senft <osk@google.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211117010145.297253-1-joel@jms.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
index b53fee6f1c170..65f172807a0d5 100644
--- a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
+++ b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
@@ -291,7 +291,7 @@ vga_pw_show(struct device *dev, struct device_attribute *attr, char *buf)
 	if (rc)
 		return rc;
 
-	return sprintf(buf, "%u\n", reg & 1);
+	return sprintf(buf, "%u\n", reg);
 }
 static DEVICE_ATTR_RO(vga_pw);
 
-- 
2.33.0



