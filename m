Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA26920629F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388835AbgFWVFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391840AbgFWUg4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:36:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E74F2085B;
        Tue, 23 Jun 2020 20:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944616;
        bh=z0SmxGV1pqsUgPF9FXoSEQO2G7CZWOSKbwK9/UajNNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5Ou0PtgVaeP9EAmElqeWrcUdPHJ+IpewctGxbboctzuNkPF6k3HfVlNMfDauVvib
         0y4lBglu0eueVXK/ne+xqWJgAKu8IBLk23AwkGGxCyC+bC/J0XO/TLbKRpniPq+LZ6
         527N53aArqWqruBFRNW8zfOWC8jVnZt32ZnHBwmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/206] staging: gasket: Fix mapping refcnt leak when put attribute fails
Date:   Tue, 23 Jun 2020 21:56:25 +0200
Message-Id: <20200623195319.781016698@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 57a66838e1494cd881b7f4e110ec685736e8e3ca ]

gasket_sysfs_put_attr() invokes get_mapping(), which returns a reference
of the specified gasket_sysfs_mapping object to "mapping" with increased
refcnt.

When gasket_sysfs_put_attr() returns, local variable "mapping" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one path of
gasket_sysfs_put_attr(). When mapping attribute is unknown, the function
forgets to decrease the refcnt increased by get_mapping(), causing a
refcnt leak.

Fix this issue by calling put_mapping() when put attribute fails due to
unknown attribute.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Link: https://lore.kernel.org/r/1587618895-13660-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gasket/gasket_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gasket/gasket_sysfs.c b/drivers/staging/gasket/gasket_sysfs.c
index fc45f0d13e87d..9c982f1c0881d 100644
--- a/drivers/staging/gasket/gasket_sysfs.c
+++ b/drivers/staging/gasket/gasket_sysfs.c
@@ -343,6 +343,7 @@ void gasket_sysfs_put_attr(struct device *device,
 
 	dev_err(device, "Unable to put unknown attribute: %s\n",
 		attr->attr.attr.name);
+	put_mapping(mapping);
 }
 EXPORT_SYMBOL(gasket_sysfs_put_attr);
 
-- 
2.25.1



