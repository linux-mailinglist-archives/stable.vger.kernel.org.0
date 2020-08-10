Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D813E2409E5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgHJP1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbgHJP1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E2AF22B47;
        Mon, 10 Aug 2020 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073229;
        bh=P00ThBgQLNlRPDK/22PRWiBmRKyKzX5ABwnqAtmOvHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjdNvqzsijnmthjP2OeytCBsH271RVXGSYwyHZgL/XH3NcR8FF4hXbh+TNnvq9VOt
         DTU+fYnWcDl0FIeCI1jASsO7KUyDPJ3isC8nBPgWMqa/pJLnn9TmWLQ0I+ecZZzQP2
         WILw5jm8N9/7/GebWxkv2COknqxgjJNTuepxPZFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/67] drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason
Date:   Mon, 10 Aug 2020 17:21:19 +0200
Message-Id: <20200810151811.014203848@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 498595abf5bd51f0ae074cec565d888778ea558f ]

Stale pointer was tripping up the unload path.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index f439f0a5b43a5..141cc89981240 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -592,6 +592,7 @@ fini:
 	drm_fb_helper_fini(&fbcon->helper);
 free:
 	kfree(fbcon);
+	drm->fbcon = NULL;
 	return ret;
 }
 
-- 
2.25.1



