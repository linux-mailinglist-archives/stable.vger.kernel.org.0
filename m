Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660C238A94C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhETLAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239187AbhETK6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA5FB61CFC;
        Thu, 20 May 2021 10:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504952;
        bh=2BCJQ+VUR7iOEqZ1PQf3CXIRJpkqowem3R3r7vfhMas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLoaPvfRSzmjsymSX+Xs4S9C66wh5+QRn9orswSgtyDIy3OZKstAcwACveWdXb6++
         n/cnXSmnV76dZIrG8TiZiWCvFgMFozBzU6aRw3PM+8rOMEOpvnTcbej5jNtIJM+IdH
         ODPBx6agj8zzQCoejoMzIe8DwskLzCf5HfDKa+cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 156/240] i2c: sh7760: fix IRQ error path
Date:   Thu, 20 May 2021 11:22:28 +0200
Message-Id: <20210520092113.887125343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 92dfb27240fea2776f61c5422472cb6defca7767 ]

While adding the invalid IRQ check after calling platform_get_irq(),
I managed to overlook that the driver has a complex error path in its
probe() method, thus a simple *return* couldn't be used.  Use a proper
*goto* instead!

Fixes: e5b2e3e74201 ("i2c: sh7760: add IRQ check")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-sh7760.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index c79c9f542c5a..319d1fa617c8 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -473,7 +473,7 @@ static int sh7760_i2c_probe(struct platform_device *pdev)
 
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
-		return ret;
+		goto out3;
 	id->irq = ret;
 
 	id->adap.nr = pdev->id;
-- 
2.30.2



