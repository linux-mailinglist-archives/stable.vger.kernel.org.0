Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAC829B846
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799961AbgJ0PeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799957AbgJ0PeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083FD2225E;
        Tue, 27 Oct 2020 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812860;
        bh=IlmMQPUl3NAQ4hpgJ5ham64MFJLiMFF5AA3MqQoe3QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjSEkcgfvnmWMbhjJNVDbhdf5e0SE6uDyBDvOhcC6FK0feGQhEMFmzAQqMqLBjhTZ
         PmPqYS7Sv1xZ5AFfDG9X3LHu5lv5S0GusAhlWRygRhriPQ/XMlokaDw2y06JUzi4uU
         A/L3+EGHfbXl2iTRih8hvuA2FYEKPzvzs4Ur3znw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 356/757] mfd: sm501: Fix leaks in probe()
Date:   Tue, 27 Oct 2020 14:50:06 +0100
Message-Id: <20201027135507.271049905@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8ce24f8967df2836b4557a23e74dc4bb098249f1 ]

This code should clean up if sm501_init_dev() fails.

Fixes: b6d6454fdb66 ("[PATCH] mfd: SM501 core driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index ccd62b9639528..6d2f4a0a901dc 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1415,8 +1415,14 @@ static int sm501_plat_probe(struct platform_device *dev)
 		goto err_claim;
 	}
 
-	return sm501_init_dev(sm);
+	ret = sm501_init_dev(sm);
+	if (ret)
+		goto err_unmap;
+
+	return 0;
 
+ err_unmap:
+	iounmap(sm->regs);
  err_claim:
 	release_mem_region(sm->io_res->start, 0x100);
  err_res:
-- 
2.25.1



