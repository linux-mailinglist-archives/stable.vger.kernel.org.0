Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1829A329097
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241830AbhCAUKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241897AbhCAUA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:00:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DA665356;
        Mon,  1 Mar 2021 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621434;
        bh=/cgIGPLIHgBQ4ZU59lBjbLpdlYoq+BenV7ZiGWoqKrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZmx6yIKjHQ7sFNXav467zd7b6PMJIkae/jCYBMB3bRwCPQRGUZHX/9r3x0sdCcKL
         fyBQQYT2DWTzTurQEi/B8jH+HN/b8CYtsF7KwhZkvLrXYXeWR3K+cVk2df50sZmKJp
         T3+DRnOpId3uz01t5vfXrkp9PY+ZPtg2zAm34diA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jonathan Marek <jonathan@marek.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 514/775] misc: fastrpc: fix incorrect usage of dma_map_sgtable
Date:   Mon,  1 Mar 2021 17:11:22 +0100
Message-Id: <20210301161226.925893220@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit b212658aebda82f92967bcbd4c7380d607c3d803 ]

dma_map_sgtable() returns 0 on success, which is the opposite of what this
code was doing.

Fixes: 7cd7edb89437 ("misc: fastrpc: fix common struct sg_table related issues")
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20210208200401.31100-1-jonathan@marek.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 70eb5ed942d03..f12e909034ac0 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -520,12 +520,13 @@ fastrpc_map_dma_buf(struct dma_buf_attachment *attachment,
 {
 	struct fastrpc_dma_buf_attachment *a = attachment->priv;
 	struct sg_table *table;
+	int ret;
 
 	table = &a->sgt;
 
-	if (!dma_map_sgtable(attachment->dev, table, dir, 0))
-		return ERR_PTR(-ENOMEM);
-
+	ret = dma_map_sgtable(attachment->dev, table, dir, 0);
+	if (ret)
+		table = ERR_PTR(ret);
 	return table;
 }
 
-- 
2.27.0



