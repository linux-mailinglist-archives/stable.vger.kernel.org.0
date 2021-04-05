Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3254E35401F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbhDEJQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240314AbhDEJPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F0061393;
        Mon,  5 Apr 2021 09:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614135;
        bh=mAe0AMo/Vz3uUUPI3lRQeA7kElFgeIoVf38DfeJpueQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSo4NAVJMaXLgOuBI4CfX6++yb0xnre6O6Ny9BEDDQhTXdUqfFRo5w9KGQOQqTibE
         itbykmZ1841X/VS49L8hTUvmzztdkooIeciIMGs/YSUpXOn/Zt6xVtwL5sAQeEsdj0
         zADR3W+lrs7ULzADrmQO5rF19yyTKF7mhMGKwAhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.11 095/152] drm/imx: fix memory leak when fails to init
Date:   Mon,  5 Apr 2021 10:54:04 +0200
Message-Id: <20210405085037.335242081@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 69c3ed7282a143439bbc2d03dc00d49c68fcb629 upstream.

Put DRM device on initialization failure path rather than directly
return error code.

Fixes: a67d5088ceb8 ("drm/imx: drop explicit drm_mode_config_cleanup")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/imx-drm-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -215,7 +215,7 @@ static int imx_drm_bind(struct device *d
 
 	ret = drmm_mode_config_init(drm);
 	if (ret)
-		return ret;
+		goto err_kms;
 
 	ret = drm_vblank_init(drm, MAX_CRTC);
 	if (ret)


