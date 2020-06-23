Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3D8206384
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390129AbgFWU0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390654AbgFWU03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:26:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A96B20702;
        Tue, 23 Jun 2020 20:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943989;
        bh=9YmC30CBs5fIMIMnajxNVucl7OFNhF85IfK4dlpZ0J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw2eXpN5TojHhmtEqqSm/tGd0P1u7A3Lj+f2eyRaeUVKybUmLHQv3hdwn5K7SJtR/
         u1Tu5MgYkAARBwMt5QTYhilepm0zMn082BHcw96UgvNo13SeWumq9qhCV468aUH8rM
         hEEh8ZOYDnNckqrsKIqVFdkB2cbNZdbJKKYfKepU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/314] staging: gasket: Fix mapping refcnt leak when register/store fails
Date:   Tue, 23 Jun 2020 21:54:53 +0200
Message-Id: <20200623195343.533198356@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit e3436ce60cf5f5eaedda2b8c622f69feb97595e2 ]

gasket_sysfs_register_store() invokes get_mapping(), which returns a
reference of the specified gasket_sysfs_mapping object to "mapping" with
increased refcnt.

When gasket_sysfs_register_store() returns, local variable "mapping"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The reference counting issue happens in one exception handling path of
gasket_sysfs_register_store(). When gasket_dev is NULL, the function
forgets to decrease the refcnt increased by get_mapping(), causing a
refcnt leak.

Fix this issue by calling put_mapping() when gasket_dev is NULL.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Link: https://lore.kernel.org/r/1587618941-13718-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gasket/gasket_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gasket/gasket_sysfs.c b/drivers/staging/gasket/gasket_sysfs.c
index ad852ea1d4a92..af26bc9f184a5 100644
--- a/drivers/staging/gasket/gasket_sysfs.c
+++ b/drivers/staging/gasket/gasket_sysfs.c
@@ -373,6 +373,7 @@ ssize_t gasket_sysfs_register_store(struct device *device,
 	gasket_dev = mapping->gasket_dev;
 	if (!gasket_dev) {
 		dev_err(device, "Device driver may have been removed\n");
+		put_mapping(mapping);
 		return 0;
 	}
 
-- 
2.25.1



