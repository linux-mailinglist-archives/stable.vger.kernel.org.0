Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B9C45C3F5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351208AbhKXNoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353537AbhKXNn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 732D96329E;
        Wed, 24 Nov 2021 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758721;
        bh=5oOrkpf11x0V5ApWhDqEvqTbOKGwmb03yAlf3uLxp0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+T6Cum3IIzD214bpl5UXNUEj2tCXs7TB5Es6yr1ITnfnNNb/At5eC3xchmobMPGc
         fA0LFDWZYCOA//1ypEjr4MmGrDRukamy4M6Ad/8xx+r05xEmJ5Q6IDZ+akGvnuYm9O
         pwg7kHPzgv5cQ7DNriYbf/2cjB3Mt6GUfLLZh0LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.10 140/154] drm/nouveau: use drm_dev_unplug() during device removal
Date:   Wed, 24 Nov 2021 12:58:56 +0100
Message-Id: <20211124115707.018380102@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Cline <jcline@redhat.com>

commit aff2299e0d81b26304ccc6a1ec0170e437f38efc upstream.

Nouveau does not currently support hot-unplugging, but it still makes
sense to switch from drm_dev_unregister() to drm_dev_unplug().
drm_dev_unplug() calls drm_dev_unregister() after marking the device as
unplugged, but only after any device critical sections are finished.

Since nouveau isn't using drm_dev_enter() and drm_dev_exit(), there are
no critical sections so this is nearly functionally equivalent. However,
the DRM layer does check to see if the device is unplugged, and if it is
returns appropriate error codes.

In the future nouveau can add critical sections in order to truly
support hot-unplugging.

Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Jeremy Cline <jcline@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Tested-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201125202648.5220-2-jcline@redhat.com
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/14
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -794,7 +794,7 @@ nouveau_drm_device_remove(struct drm_dev
 	struct nvkm_client *client;
 	struct nvkm_device *device;
 
-	drm_dev_unregister(dev);
+	drm_dev_unplug(dev);
 
 	dev->irq_enabled = false;
 	client = nvxx_client(&drm->client.base);


