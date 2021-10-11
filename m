Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639A7429097
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243275AbhJKOK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239583AbhJKOIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52AE46121F;
        Mon, 11 Oct 2021 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960874;
        bh=1Sy+0MgxnGDSvIHsYSiKCPa0b6lBtukwlyW7lDzbHto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdNt1f/6vFobIo9qDmSK5UgZIhg2dg0/3hrouxI7weAOGTOFW7WU2I5uzyH8njLT8
         IxHn7eeAEalXDxXUmC+lGHDAZ8RL+z0p0C6qp5ExvW5KRY9if5iF5vi7SzOkZVPS1w
         REN5l8yed3CYf0uqGytur2/hFs3xrnzk4gjdMp88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 100/151] drm/nouveau/fifo/ga102: initialise chid on return from channel creation
Date:   Mon, 11 Oct 2021 15:46:12 +0200
Message-Id: <20211011134521.053274713@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 0689ea432a85ad1a108f47c3d90b6feae322c7f9 ]

Turns out caller isn't zero-initialised after-all.

Fixes: 49b2dfc08182 ("drm/nouveau/ga102-: support ttm buffer moves via copy engine")
Reported-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210921090735.247236-1-skeggsb@gmail.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c
index f897bef13acf..c630dbd2911a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c
@@ -179,6 +179,9 @@ ga102_chan_new(struct nvkm_device *device,
 		return -ENODEV;
 
 	chan->ctrl.chan = nvkm_rd32(device, chan->ctrl.runl + 0x004) & 0xfffffff0;
+
+	args->chid = 0;
+	args->inst = 0;
 	args->token = nvkm_rd32(device, chan->ctrl.runl + 0x008) & 0xffff0000;
 
 	ret = nvkm_memory_new(device, NVKM_MEM_TARGET_INST, 0x1000, 0x1000, true, &chan->mthd);
-- 
2.33.0



