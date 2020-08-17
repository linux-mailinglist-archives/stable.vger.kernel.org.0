Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B0C246B2F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgHQPua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730773AbgHQPuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C75112245C;
        Mon, 17 Aug 2020 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679398;
        bh=EGmXluOUHO25U06vCs4b8FJqku0OIik3wXzBz25SqUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMnGfXpOOgOpGwU40FzmhZR34XKatGyPj0hwZnYFX9YQzdqZea44PIcdJCQNpbCX1
         xcFWce0NFocW3pK+1jVfPTDQB/8y+hL76Zv5aTIDV7ujdqHKwMu55u54lj9R7fuZkQ
         loUMfma34vx2qGJ57Y1u4HPw8xoDeIu/3gbha9jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 198/393] drm/bridge: sil_sii8620: initialize return of sii8620_readb
Date:   Mon, 17 Aug 2020 17:14:08 +0200
Message-Id: <20200817143829.227122165@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

[ Upstream commit 02cd2d3144653e6e2a0c7ccaa73311e48e2dc686 ]

clang static analysis flags this error

sil-sii8620.c:184:2: warning: Undefined or garbage value
  returned to caller [core.uninitialized.UndefReturn]
        return ret;
        ^~~~~~~~~~

sii8620_readb calls sii8620_read_buf.
sii8620_read_buf can return without setting its output
pararmeter 'ret'.

So initialize ret.

Fixes: ce6e153f414a ("drm/bridge: add Silicon Image SiI8620 driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200712152453.27510-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sil-sii8620.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index 92acd336aa894..ca98133411aab 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -178,7 +178,7 @@ static void sii8620_read_buf(struct sii8620 *ctx, u16 addr, u8 *buf, int len)
 
 static u8 sii8620_readb(struct sii8620 *ctx, u16 addr)
 {
-	u8 ret;
+	u8 ret = 0;
 
 	sii8620_read_buf(ctx, addr, &ret, 1);
 	return ret;
-- 
2.25.1



