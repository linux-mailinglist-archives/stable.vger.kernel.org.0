Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07F2B636C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbgKQNiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731634AbgKQNiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E463207BC;
        Tue, 17 Nov 2020 13:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620281;
        bh=44psANdJZ6eKFGyNAl909sTOVlCBmeks5lqbgUd6buI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hX/F+/Oz640gchItvNXghkSawbvaqOMLNYNHN28HWUXGKs4xdHITVefnXgzD+1fTZ
         xiSdHWBpZjC5K2HmUzNLCUf05lNTgsc+pD0p0UaLTH+lmA2uAI7bAP+r3RCtiqjxPP
         XvGHS4tEnXlOlZkay9MTAbeDXzTnH5IuQy4mXF7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        =?UTF-8?q?Jan=20 Yenya =20Kasprzak?= <kas@fi.muni.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 167/255] cosa: Add missing kfree in error path of cosa_write
Date:   Tue, 17 Nov 2020 14:05:07 +0100
Message-Id: <20201117122147.064949702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 52755b66ddcef2e897778fac5656df18817b59ab ]

If memory allocation for 'kbuf' succeed, cosa_write() doesn't have a
corresponding kfree() in exception handling. Thus add kfree() for this
function implementation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Link: https://lore.kernel.org/r/20201110144614.43194-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/cosa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index f8aed0696d775..2369ca250cd65 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -889,6 +889,7 @@ static ssize_t cosa_write(struct file *file,
 			chan->tx_status = 1;
 			spin_unlock_irqrestore(&cosa->lock, flags);
 			up(&chan->wsem);
+			kfree(kbuf);
 			return -ERESTARTSYS;
 		}
 	}
-- 
2.27.0



