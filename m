Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4324B3CA750
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbhGOSxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239776AbhGOSwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECBF613CF;
        Thu, 15 Jul 2021 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374987;
        bh=umTpPidblLEoLIcldFS+oYQrpZPqv5PsjC7OHkD8deQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyHvItQkPMHGMUBUoi55MW/CCBGcAUpLz4135jDn1I3mkgiT5ASlKiPCX7hvTjdb2
         Z+jtK1y+4ZrxYXO9PEjostZ5KHy9AJ8jjOq7/LUiePGYfQ7VASJS8mB9T6fTVI/P06
         VDYDHro0Y0pSuXwH2Yr52s7sl1HjUYzwUsNRANts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/215] IB/isert: Align target max I/O size to initiator size
Date:   Thu, 15 Jul 2021 20:38:04 +0200
Message-Id: <20210715182619.339869374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index e653c83f8a35..edea37da8a5b 100644
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



