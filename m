Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9B3106C13
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfKVKti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbfKVKth (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:49:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E5220656;
        Fri, 22 Nov 2019 10:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419777;
        bh=7jmaLZ+hrUZZxUmiRO0qSUqbgKSq96bs8xMAOPC8FKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdTi89NqkiiSO05QW91383OXPpk9LOW7ltU+54j8NSbmeP22y5FzDIwFQ0cjbnXbL
         7KxGq7rYMHB8rICze2/qgy+Y9qbCBbD1p+BsT5m8pXa7tCCuBCl7D/LdIbG1bXE1Gu
         A70kdfAg/8YBsfDyzaLk4+Ioo4kU1eXfn/ULGaNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 218/222] misc: cxl: Fix possible null pointer dereference
Date:   Fri, 22 Nov 2019 11:29:18 +0100
Message-Id: <20191122100918.319643938@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit 3dac3583bf1a61db6aaf31dfd752c677a4400afd ]

It is not safe to dereference an object before a null test. It is
not needed and just remove them. Ftrace can be used instead.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/guest.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index 3e102cd6ed914..d08509cd978a4 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -1026,8 +1026,6 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 
 void cxl_guest_remove_afu(struct cxl_afu *afu)
 {
-	pr_devel("in %s - AFU(%d)\n", __func__, afu->slice);
-
 	if (!afu)
 		return;
 
-- 
2.20.1



