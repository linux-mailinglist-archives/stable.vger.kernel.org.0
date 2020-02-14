Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C41815DD8F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388586AbgBNP73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388015AbgBNP70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80330222C4;
        Fri, 14 Feb 2020 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695966;
        bh=J82JkTofHDDCykmw5UKeVbFfNcfQzl+TMlBOTvHz5nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMOp6lKuD+1QT6tWM8mn4FfAFvV/Vqp43Eworx3qTm/0pAiDhTem/wsJnCe1B5GW/
         /kIrFs+998Cum4NqrtjBmdGo9StU51OmvRwWxCJF6Ni1szqVqMofTAlH8pjzII6LXE
         hVES5TrDIYCjdJLR5CRyMYG3oqVBytkSQ/e7fisg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 494/542] drm/nouveau/disp/nv50-: prevent oops when no channel method map provided
Date:   Fri, 14 Feb 2020 10:48:06 -0500
Message-Id: <20200214154854.6746-494-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 0e6176c6d286316e9431b4f695940cfac4ffe6c2 ]

The implementations for most channel types contains a map of methods to
priv registers in order to provide debugging info when a disp exception
has been raised.

This info is missing from the implementation of PIO channels as they're
rather simplistic already, however, if an exception is raised by one of
them, we'd end up triggering a NULL-pointer deref.  Not ideal...

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206299
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
index bcf32d92ee5a9..50e3539f33d22 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
@@ -74,6 +74,8 @@ nv50_disp_chan_mthd(struct nv50_disp_chan *chan, int debug)
 
 	if (debug > subdev->debug)
 		return;
+	if (!mthd)
+		return;
 
 	for (i = 0; (list = mthd->data[i].mthd) != NULL; i++) {
 		u32 base = chan->head * mthd->addr;
-- 
2.20.1

