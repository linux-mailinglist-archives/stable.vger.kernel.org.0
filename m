Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8F14506E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbgAVJng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387893AbgAVJne (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A57982468C;
        Wed, 22 Jan 2020 09:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686214;
        bh=xLEPOfmY1hDdyUmvk8BdYAOzOZw6EEXGxFfI7cSr0eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6Ihsxgp0M5e6S0uwDM/ERcpIdQpdelFKfFZ+JDAwJAzCrHVxGtvDPXXnNK+EpTNC
         svLuIATcgvjwovVV6jGgC4fgHdxmxh6Td+EOYqZ4QM1cYoa4uzS0ujNWxgzzOKuN6n
         xPYLOJBULnEhCTFfpLJe9uYBbPVoQTbZ3oBAI3AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [PATCH 4.19 089/103] drm/nouveau/bar/nv50: check bar1 vmm return value
Date:   Wed, 22 Jan 2020 10:29:45 +0100
Message-Id: <20200122092815.631753826@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 307a312df9c43fdea286ad17f748aaf777cc434a upstream.

Check bar1's new vmm creation return value for errors.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
@@ -174,6 +174,8 @@ nv50_bar_oneinit(struct nvkm_bar *base)
 
 	ret = nvkm_vmm_new(device, start, limit-- - start, NULL, 0,
 			   &bar1_lock, "bar1", &bar->bar1_vmm);
+	if (ret)
+		return ret;
 
 	atomic_inc(&bar->bar1_vmm->engref[NVKM_SUBDEV_BAR]);
 	bar->bar1_vmm->debug = bar->base.subdev.debug;


