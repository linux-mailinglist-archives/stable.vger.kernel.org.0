Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3B171F8D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbgB0N6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:58:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732501AbgB0N6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:58:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEF1F21D7E;
        Thu, 27 Feb 2020 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811920;
        bh=i9i7Wl759lILGhGaXlNqPkHgaImx6U0G3qiL2XcD3Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhemI9VKPFJFB/ma9YitejuXEOQdD931L9Q9TARUw2S9GMTohpUk9eD6X1JpTlbN3
         yfqdeTDgqG26+ViUL6XJgIRNfVZn6GaEnlkk7AKL8B1ZZM6csDGUnyMzUulFJpZ++p
         SkP14DYmEbhmfGvOzRQCxwa1phz2qFtNRRXv5trE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/237] drm/nouveau/disp/nv50-: prevent oops when no channel method map provided
Date:   Thu, 27 Feb 2020 14:36:05 +0100
Message-Id: <20200227132307.691942451@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0c0310498afdb..cd9666583d4bd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
@@ -73,6 +73,8 @@ nv50_disp_chan_mthd(struct nv50_disp_chan *chan, int debug)
 
 	if (debug > subdev->debug)
 		return;
+	if (!mthd)
+		return;
 
 	for (i = 0; (list = mthd->data[i].mthd) != NULL; i++) {
 		u32 base = chan->head * mthd->addr;
-- 
2.20.1



