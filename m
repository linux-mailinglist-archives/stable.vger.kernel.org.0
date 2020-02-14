Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE5215E49E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388224AbgBNQg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405448AbgBNQYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A282477E;
        Fri, 14 Feb 2020 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697441;
        bh=ky36aMu0AdjOm6TKsHBpxgM+ZwKEDz8HePbBtRxnoUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQswy2mphfDPdD6IUvgSDC8V3hg7xUiT4wW0FTtpgsSU/kg5NLvPkxY8ZyDHLSzUw
         As1QYYRgTAxbljO0CS8sphS1/mk519PZdDdfYrcHwqDy3IcGZX6cIp5ZkmUyYW7YDv
         rf69DFCcKUz2urIXNaeUHBfCxp3KF3pEHolcpZYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 127/141] drm/nouveau/disp/nv50-: prevent oops when no channel method map provided
Date:   Fri, 14 Feb 2020 11:21:07 -0500
Message-Id: <20200214162122.19794-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
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
index 9d90d8b4b7e65..f5a8db1bb8b72 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
@@ -72,6 +72,8 @@ nv50_disp_chan_mthd(struct nv50_disp_chan *chan, int debug)
 
 	if (debug > subdev->debug)
 		return;
+	if (!mthd)
+		return;
 
 	for (i = 0; (list = mthd->data[i].mthd) != NULL; i++) {
 		u32 base = chan->head * mthd->addr;
-- 
2.20.1

