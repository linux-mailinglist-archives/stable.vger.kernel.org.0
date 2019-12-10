Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F014119B1C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbfLJWFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbfLJWFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:05:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2692E20637;
        Tue, 10 Dec 2019 22:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015512;
        bh=HmliciBZzqsRqRN7RPFZjJ+IVzmrgEi6yiabt3TzylU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCY1FX5gHK5o9vQQQQ/U+kReQhH9WOP6YWdWuQtWXDH8WlGQWnaS3ZPibSuXI8mJ+
         emUgJeQIGb2WUHpOjrkRspqVf4iKPKQRPIpL0RmynT/y4byDFNNG+V9ol/2XPVyRdG
         EqoBsEzDvn21zeSSfs0CaqcJVJ7PUW6L0dJcvAsA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 110/130] RDMA/qib: Validate ->show()/store() callbacks before calling them
Date:   Tue, 10 Dec 2019 17:02:41 -0500
Message-Id: <20191210220301.13262-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 7ee23491b39259ae83899dd93b2a29ef0f22f0a7 ]

The permissions of the read-only or write-only sysfs files can be
changed (as root) and the user can then try to read a write-only file or
write to a read-only file which will lead to kernel crash here.

Protect against that by always validating the show/store callbacks.

Link: https://lore.kernel.org/r/d45cc26361a174ae12dbb86c994ef334d257924b.1573096807.git.viresh.kumar@linaro.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index ca2638d8f35ef..d831f3e61ae8f 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -301,6 +301,9 @@ static ssize_t qib_portattr_show(struct kobject *kobj,
 	struct qib_pportdata *ppd =
 		container_of(kobj, struct qib_pportdata, pport_kobj);
 
+	if (!pattr->show)
+		return -EIO;
+
 	return pattr->show(ppd, buf);
 }
 
@@ -312,6 +315,9 @@ static ssize_t qib_portattr_store(struct kobject *kobj,
 	struct qib_pportdata *ppd =
 		container_of(kobj, struct qib_pportdata, pport_kobj);
 
+	if (!pattr->store)
+		return -EIO;
+
 	return pattr->store(ppd, buf, len);
 }
 
-- 
2.20.1

