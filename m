Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D65C451E9B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348125AbhKPAgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343868AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E27E36339C;
        Mon, 15 Nov 2021 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002057;
        bh=pn7LAgUSQ82DjVMjRhYDaKSUCMPvDjOGIseLSGYmEIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZD39N3n2wbnOMGxCZFUn/9MKc8nSb9wA/b0qiULR72AuroOpxnj+ZuIzcaZM546FS
         39KMb5CpZP9VIR7juIuPk07/ARpNmmvyn3xdbrTkhKgeKZJrnvIRdGeCAxwir86TS1
         oQENPt03o6htM6VmMtI5RTtKHh/JBYPYusP9GkxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 423/917] memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()
Date:   Mon, 15 Nov 2021 17:58:38 +0100
Message-Id: <20211115165443.143258988@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index f9a93b0565e15..435d4c058b20e 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -882,7 +882,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 
 	iounmap(host->addr);
 err_out_free:
-	kfree(msh);
+	memstick_free_host(msh);
 	return NULL;
 }
 
-- 
2.33.0



