Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCBF1E2A61
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389455AbgEZSzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389451AbgEZSzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE341208C3;
        Tue, 26 May 2020 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519320;
        bh=dVy0LRePgbkEtZhtYdBgh1mFB0WuQl4IXpOliByWPYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPEp2+GsV24bx5CrEsTDFbkJh+hMWynfxGUb+hum8P/l80t9FD2IjTdpWFUkwFNre
         ZEytKS15IfFV29arns3pgYpd4xs9EZsqTeFyXNRFDIgv6+E1DZ2f1HZZR7RReFbEA6
         b617oGhBKRii6s1//+JHCCw9aOajSMoonRh38YVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 22/65] i2c: dev: use after free in detach
Date:   Tue, 26 May 2020 20:52:41 +0200
Message-Id: <20200526183914.507467866@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e6be18f6d62c1d3b331ae020b76a29c2ccf6b0bf upstream.

The call to put_i2c_dev() frees "i2c_dev" so there is a use after
free when we call cdev_del(&i2c_dev->cdev).

Fixes: d6760b14d4a1 ('i2c: dev: switch from register_chrdev to cdev API')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 382c66d5a470..e5cd307ebfc9 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -599,9 +599,9 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
 	if (!i2c_dev) /* attach_adapter must have failed */
 		return 0;
 
+	cdev_del(&i2c_dev->cdev);
 	put_i2c_dev(i2c_dev);
 	device_destroy(i2c_dev_class, MKDEV(I2C_MAJOR, adap->nr));
-	cdev_del(&i2c_dev->cdev);
 
 	pr_debug("i2c-dev: adapter [%s] unregistered\n", adap->name);
 	return 0;
-- 
2.25.1



