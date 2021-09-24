Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A04173F6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbhIXNBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344249AbhIXM7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F9E613D1;
        Fri, 24 Sep 2021 12:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487997;
        bh=Bf/aeYIkEm1YHA3Aw9sMLTbcN04JZS2bgcX2uMOo5R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+XZfpUF4eP5y7BWeF76kE+qzWBLyaAXgKqR9EPC/w2oLZdWD5PBGy38b6fSvKhiD
         ToBzqgs84j3YtvCmxDsEi1Tw1OGDjhOlmv1oZc4KPuOFk/61SPnHXtwtSZro6Shphk
         FaFJ1gcIQzBeSuA/As57MxWkOC72dACb15KKFHJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 044/100] dma-buf: DMABUF_MOVE_NOTIFY should depend on DMA_SHARED_BUFFER
Date:   Fri, 24 Sep 2021 14:43:53 +0200
Message-Id: <20210924124342.927019465@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit c4f3a3460a5daebc772d9263500e4099b11e7300 ]

Move notify between drivers is an option of DMA-BUF.  Enabling
DMABUF_MOVE_NOTIFY without DMA_SHARED_BUFFER does not have any impact,
as drivers/dma-buf/ is not entered during the build when
DMA_SHARED_BUFFER is disabled.

Fixes: bb42df4662a44765 ("dma-buf: add dynamic DMA-buf handling v15")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210902124913.2698760-2-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 4e16c71c24b7..6e13cc941cd2 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -42,6 +42,7 @@ config UDMABUF
 config DMABUF_MOVE_NOTIFY
 	bool "Move notify between drivers (EXPERIMENTAL)"
 	default n
+	depends on DMA_SHARED_BUFFER
 	help
 	  Don't pin buffers if the dynamic DMA-buf interface is available on
 	  both the exporter as well as the importer. This fixes a security
-- 
2.33.0



