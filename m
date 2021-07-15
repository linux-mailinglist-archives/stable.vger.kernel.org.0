Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53C03CA901
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbhGOTFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242931AbhGOTC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:02:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4387A613D3;
        Thu, 15 Jul 2021 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375536;
        bh=OLYz9Fhx4UCce3belqp6thG8WF8rjYVJA9ABbB28Ka4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpvVvgZqhrX4HzSP3hfMTjBgtmWyIs3RQpomcFHFkIt3au7RrBbYi8/nzVWEc9qXp
         RA5EIhr7liw3ES+sylzKnfxhRB03Tx2QpkWuxA7yUljbFPgHK6w/nPkt4nTsSLE2l/
         wy9ulesRZ9uvbO2m2QTsselskZDg9GGI3OzlIm0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 130/242] IB/isert: Align target max I/O size to initiator size
Date:   Thu, 15 Jul 2021 20:38:12 +0200
Message-Id: <20210715182615.917276119@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit 109d19a5eb3ddbdb87c43bfd4bcf644f4569da64 ]

Since the Linux iser initiator default max I/O size set to 512KB and since
there is no handshake procedure for this size in iser protocol, set the
default max IO size of the target to 512KB as well.

For changing the default values, there is a module parameter for both
drivers.

Link: https://lore.kernel.org/r/20210524085215.29005-1-mgurtovoy@nvidia.com
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 4 ++--
 drivers/infiniband/ulp/isert/ib_isert.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 18266f07c58d..de3fc05fd2e8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -35,10 +35,10 @@ static const struct kernel_param_ops sg_tablesize_ops = {
 	.get = param_get_int,
 };
 
-static int isert_sg_tablesize = ISCSI_ISER_DEF_SG_TABLESIZE;
+static int isert_sg_tablesize = ISCSI_ISER_MIN_SG_TABLESIZE;
 module_param_cb(sg_tablesize, &sg_tablesize_ops, &isert_sg_tablesize, 0644);
 MODULE_PARM_DESC(sg_tablesize,
-		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 256, max: 4096)");
+		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 128, max: 4096)");
 
 static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 6c5af13db4e0..ca8cfebe26ca 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -65,9 +65,6 @@
  */
 #define ISER_RX_SIZE		(ISCSI_DEF_MAX_RECV_SEG_LEN + 1024)
 
-/* Default I/O size is 1MB */
-#define ISCSI_ISER_DEF_SG_TABLESIZE 256
-
 /* Minimum I/O size is 512KB */
 #define ISCSI_ISER_MIN_SG_TABLESIZE 128
 
-- 
2.30.2



