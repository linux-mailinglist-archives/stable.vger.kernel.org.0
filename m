Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2236D37C3AB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhELPVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhELPTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 422D76199B;
        Wed, 12 May 2021 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832084;
        bh=OR7DWcC8PW+np9PLM+QZ25mU/ZeAoHeHEOy+mCMH33A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UFWfo7F0FPM1bIBwMvdOk/3+9yucn87O9AsJISct7TiZcAdFszq2qfkrukn9zhhu
         B3+FoVlPfeNf+REfMTeLe+LdtuhWT9x8fwBRIdq4gW+vlO9ikGN+uDZ01CEdJzUXGo
         ds4G8DHlA8onOi6uqOsI7Gybse62n9fqMNKaiqrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.10 108/530] Revert "drm/qxl: do not run release if qxl failed to init"
Date:   Wed, 12 May 2021 16:43:38 +0200
Message-Id: <20210512144823.348288024@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

commit 93d8da8d7efbf690c0a9eaca798acc0c625245e6 upstream.

This reverts commit b91907a6241193465ca92e357adf16822242296d.

Patch is broken, it effectively makes qxl_drm_release() a nop
because on normal driver shutdown qxl_drm_release() is called
*after* drm_dev_unregister().

Fixes: b91907a62411 ("drm/qxl: do not run release if qxl failed to init")
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: http://patchwork.freedesktop.org/patch/msgid/20210204145712.1531203-3-kraxel@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/qxl/qxl_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_drv.c
+++ b/drivers/gpu/drm/qxl/qxl_drv.c
@@ -144,8 +144,6 @@ static void qxl_drm_release(struct drm_d
 	 * reodering qxl_modeset_fini() + qxl_device_fini() calls is
 	 * non-trivial though.
 	 */
-	if (!dev->registered)
-		return;
 	qxl_modeset_fini(qdev);
 	qxl_device_fini(qdev);
 }


