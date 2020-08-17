Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D528924742A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbgHQTGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgHQPoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:44:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4991322BF3;
        Mon, 17 Aug 2020 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679061;
        bh=1hXMIq9stTbl5HQ93bMflX6VAP6HvLtvNWyOgYwnH5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/3cMIwLQRgQTycHU4g9cuTdzhUNFpZuZsacaGXp0M9ZHfHfEc9Cr6E2lSmELIhDk
         MAKlrgWnuC/+p9Ykx/RTs7nTQEAcen0ZhmMh0RkU1TvwofRz04TJP0ZghpWXDRuvnB
         4c+YS5sb8MfEsS75fRSOSHBP+5O+psM7PVApzcjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 082/393] drm/nouveau: fix reference count leak in nouveau_debugfs_strap_peek
Date:   Mon, 17 Aug 2020 17:12:12 +0200
Message-Id: <20200817143823.607134536@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 8f29432417b11039ef960ab18987c7d61b2b5396 ]

nouveau_debugfs_strap_peek() calls pm_runtime_get_sync() that
increments the reference count. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index 15a3d40edf029..3e15a9d5e8faa 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -54,8 +54,10 @@ nouveau_debugfs_strap_peek(struct seq_file *m, void *data)
 	int ret;
 
 	ret = pm_runtime_get_sync(drm->dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(drm->dev->dev);
 		return ret;
+	}
 
 	seq_printf(m, "0x%08x\n",
 		   nvif_rd32(&drm->client.device.object, 0x101000));
-- 
2.25.1



