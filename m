Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FB437CB5A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbhELQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241696AbhELQ1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A556162B;
        Wed, 12 May 2021 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834914;
        bh=QyQZzy9wNswj6b7C3cVJiUuMu0wDsZ/emzhge6jGPOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjKnTxF0LHpXBK8NYSZtyt9UmrF7BqgEP3s926/CTySVRaQcpxsfRdZ2Gy0VZp/O5
         tYm46vP5QP3tTi24zzpMqAVVFtjeVAlSn6EEtuEasylGZWPEKUewK6F7Ov8MJZbBmg
         LeTpNqgzlahgj+FhCybX7dlrio60DSQBVe3Zv+dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.12 134/677] Revert "drm/qxl: do not run release if qxl failed to init"
Date:   Wed, 12 May 2021 16:43:00 +0200
Message-Id: <20210512144841.680305257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
 	 * reordering qxl_modeset_fini() + qxl_device_fini() calls is
 	 * non-trivial though.
 	 */
-	if (!dev->registered)
-		return;
 	qxl_modeset_fini(qdev);
 	qxl_device_fini(qdev);
 }


