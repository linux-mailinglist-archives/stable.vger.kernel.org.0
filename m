Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9A328B8DD
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbgJLNzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389652AbgJLNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563C822264;
        Mon, 12 Oct 2020 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510259;
        bh=43pJc85teSld/oMk5esnfNwkGoTJ2luiiuKOBOYXS6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E48XvjKvmf1VU5FbXerHKAExqT317dwQiSeIyXqy8JpsVVjZlj4bCWyhv5IbDdhcT
         0JE9peWZlvWWftjqh1YLpJW+HuXn3yiGvkY+/vQNhbFiAcqjLlF6xzX6LSG4HLsFD4
         unR9J/96KRGSYQhKGe4Oo2UpylzpqxN9rv8UXAGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        dann frazier <dann.frazier@canonical.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 5.8 009/124] drm/nouveau/device: return error for unknown chipsets
Date:   Mon, 12 Oct 2020 15:30:13 +0200
Message-Id: <20201012133147.302175389@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit c3e0276c31ca8c7b8615da890727481260d4676f upstream.

Previously the code relied on device->pri to be NULL and to fail probing
later. We really should just return an error inside nvkm_device_ctor for
unsupported GPUs.

Fixes: 24d5ff40a732 ("drm/nouveau/device: rework mmio mapping code to get rid of second map")

Signed-off-by: Karol Herbst <kherbst@redhat.com>
Cc: dann frazier <dann.frazier@canonical.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jeremy Cline <jcline@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201006220528.13925-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -3149,6 +3149,7 @@ nvkm_device_ctor(const struct nvkm_devic
 		case 0x168: device->chip = &nv168_chipset; break;
 		default:
 			nvdev_error(device, "unknown chipset (%08x)\n", boot0);
+			ret = -ENODEV;
 			goto done;
 		}
 


