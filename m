Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42838EE38
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhEXPrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhEXPpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:45:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94A7561463;
        Mon, 24 May 2021 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870582;
        bh=Tvcey3jxS/iqDj/iX3YD00heADzTC6XZUsFCwqVpdh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCr0Rp9zhtZYJ+hG4UHzvwG3OlJJFO4F9q3H49NTYL3kXhxM+8jthJIyckBifOAow
         sPvBinc0QwXtRUXg6nIUb7l0cVluGklasxtEV+/plgv+ZxTQwCfVWr9PLBT79vXKnU
         rn3xcnR8s6kpZNDnISVxoNSyDGJbS9LrxK4zrjE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/71] RDMA/uverbs: Fix a NULL vs IS_ERR() bug
Date:   Mon, 24 May 2021 17:25:18 +0200
Message-Id: <20210524152326.858385902@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 463a3f66473b58d71428a1c3ce69ea52c05440e5 ]

The uapi_get_object() function returns error pointers, it never returns
NULL.

Fixes: 149d3845f4a5 ("RDMA/uverbs: Add a method to introspect handles in a context")
Link: https://lore.kernel.org/r/YJ6Got+U7lz+3n9a@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 2a3f2f01028d..fd351bdec3f6 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -110,8 +110,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_INFO_HANDLES)(
 		return ret;
 
 	uapi_object = uapi_get_object(attrs->ufile->device->uapi, object_id);
-	if (!uapi_object)
-		return -EINVAL;
+	if (IS_ERR(uapi_object))
+		return PTR_ERR(uapi_object);
 
 	handles = gather_objects_handle(attrs->ufile, uapi_object, attrs,
 					out_len, &total);
-- 
2.30.2



