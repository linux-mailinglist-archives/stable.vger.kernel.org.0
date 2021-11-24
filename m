Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C445BBD9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbhKXMYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243934AbhKXMWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E8DE611C1;
        Wed, 24 Nov 2021 12:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755996;
        bh=Jey8LXnTxV2gww1EzOJecaYvVkiugyene7Ru5HblbCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4KsKUy2QLVDX9M88dplwZDlAbb0FSSsmMHWBh7fwoST9YnXoGYUWnd3yDU63TSPS
         CxQek9VPHF+nDl/VicgJU0eabd1tWDGg7XoZRIIMu2dDQJvLy3MqskCwtSAXyKab1O
         nkcJgtmZrk9fyBut1yh47nnyP5uuFTwv4YdyPNJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 099/207] memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()
Date:   Wed, 24 Nov 2021 12:56:10 +0100
Message-Id: <20211124115707.288273542@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit beae4a6258e64af609ad5995cc6b6056eb0d898e ]

The "msh" pointer is device managed, meaning that memstick_alloc_host()
calls device_initialize() on it.  That means that it can't be free
using kfree() but must instead be freed with memstick_free_host().
Otherwise it leads to a tiny memory leak of device resources.

Fixes: 60fdd931d577 ("memstick: add support for JMicron jmb38x MemoryStick host controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211011123912.GD15188@kili
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/host/jmb38x_ms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 08fa6400d2558..ba6cd576e9979 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -905,7 +905,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 
 	iounmap(host->addr);
 err_out_free:
-	kfree(msh);
+	memstick_free_host(msh);
 	return NULL;
 }
 
-- 
2.33.0



