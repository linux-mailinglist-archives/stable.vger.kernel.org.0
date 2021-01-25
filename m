Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B71302AC6
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbhAYSw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbhAYSwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8C920679;
        Mon, 25 Jan 2021 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600718;
        bh=d9N9Rw7S0yFY1ZgMzq2rorDUajTElzhzdLWNWf8VZM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKEmX874eioggjYWCKsyTk0YZewood/QCogM2RpwutuwlT/3rcsCfIw35UVzYI3FX
         XtzowD/a5wSK1V16vsCH6GuA0PqhG3/Dfpn7ZuH3RAWjZKq6lhFJNuoa5ZZw4AxgrO
         N7vmWJFb7vtrU16YYv5W5/Oe2kMVbD0luXFPmFiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neta Ostrovsky <netao@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/199] RDMA/cma: Fix error flow in default_roce_mode_store
Date:   Mon, 25 Jan 2021 19:38:36 +0100
Message-Id: <20210125183220.241455008@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

[ Upstream commit 7c7b3e5d9aeed31d35c5dab0bf9c0fd4c8923206 ]

In default_roce_mode_store(), we took a reference to cma_dev, but didn't
return it with cma_dev_put in the error flow.

Fixes: 1c15b4f2a42f ("RDMA/core: Modify enum ib_gid_type and enum rdma_network_type")
Link: https://lore.kernel.org/r/20210113130214.562108-1-leon@kernel.org
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma_configfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index 7ec4af2ed87ab..35d1ec1095f9c 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -131,8 +131,10 @@ static ssize_t default_roce_mode_store(struct config_item *item,
 		return ret;
 
 	gid_type = ib_cache_gid_parse_type_str(buf);
-	if (gid_type < 0)
+	if (gid_type < 0) {
+		cma_configfs_params_put(cma_dev);
 		return -EINVAL;
+	}
 
 	ret = cma_set_default_gid_type(cma_dev, group->port_num, gid_type);
 
-- 
2.27.0



