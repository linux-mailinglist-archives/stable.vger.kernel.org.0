Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38886145013
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbgAVJnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387911AbgAVJnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E9F2468C;
        Wed, 22 Jan 2020 09:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686219;
        bh=ajjm70ua/EuSvqMKsWtvojZA6tFpJ0zWWBomHPhyMu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPJuUDmZy2KGJns0iT2CGV4Sm/P7cRF/krV+aq6txU8uTbSFEbAYQUy5fpnfU6z8l
         2h3j00AfFVnKEqj47kmtBvqaklR2QrynmhOuNN7bkeoDjO70bVpDQa8+o4YVIf8NvS
         EUNIPwsK/0/vVFAtzkG839hTmm+fSxo/bXprE0DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [PATCH 4.19 091/103] drm/nouveau/mmu: qualify vmm during dtor
Date:   Wed, 22 Jan 2020 10:29:47 +0100
Message-Id: <20200122092815.819897902@linuxfoundation.org>
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

commit 15516bf9abaa41421a6ded79a5a2fee86f9594e5 upstream.

If the BAR initialization failed it may leave the vmm structure in an
unitialized state, leading to a null-pointer-dereference when the vmm is
dereferenced during teardown.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
@@ -1423,7 +1423,7 @@ nvkm_vmm_get(struct nvkm_vmm *vmm, u8 pa
 void
 nvkm_vmm_part(struct nvkm_vmm *vmm, struct nvkm_memory *inst)
 {
-	if (inst && vmm->func->part) {
+	if (inst && vmm && vmm->func->part) {
 		mutex_lock(&vmm->mutex);
 		vmm->func->part(vmm, inst);
 		mutex_unlock(&vmm->mutex);


