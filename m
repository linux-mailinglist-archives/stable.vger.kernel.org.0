Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A292B66AB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgKQOGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbgKQNIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894422468F;
        Tue, 17 Nov 2020 13:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618511;
        bh=DxkkgTtrPZbYCopD7O4N1V/qXoIssIfiTtsLiiIsIoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtpHXBtfnjUY3gbeY2ZbNMt1lDwC6PwBIrkqVxFPPe92lFPEsUvNom2zVLJiCeo3T
         mip0LzIv/G4eQKr7NbH6hdaMrk0JXwlL6EuST2bW7jM4UwdPOnH4qh91jV529vzzVF
         xDfm2r/5VbxhRRC6cRhRlwyleIlHRoDsqf7BWqgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        =?UTF-8?q?Jan=20 Yenya =20Kasprzak?= <kas@fi.muni.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/64] cosa: Add missing kfree in error path of cosa_write
Date:   Tue, 17 Nov 2020 14:04:53 +0100
Message-Id: <20201117122107.631309139@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
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
index 848ea6a399f23..cbda69e58e084 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -903,6 +903,7 @@ static ssize_t cosa_write(struct file *file,
 			chan->tx_status = 1;
 			spin_unlock_irqrestore(&cosa->lock, flags);
 			up(&chan->wsem);
+			kfree(kbuf);
 			return -ERESTARTSYS;
 		}
 	}
-- 
2.27.0



