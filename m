Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467B62FA288
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbhAROGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:06:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390660AbhARLpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A6322CA2;
        Mon, 18 Jan 2021 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970288;
        bh=Y0yl+/mMXxsoV6jBI2zrHlYdDRhLCLoGY9XJ8nSm8w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTGW7vrW+9fw7eoOt0TQW+i/Pdaojz8RprArBNne35U/Jb8UI/S3wN7R3UCunnjLZ
         D/tr5ywuQzJlOD962RBQht/2OxlXGW1RkpCs55vu3KbfvFimlk3qk5z1/rx2P2l2e1
         Cw7j24pRR29klEcL65yIEiWUwPGiN7lA0Lm00O0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 117/152] nvmet-rdma: Fix NULL deref when setting pi_enable and traddr INADDR_ANY
Date:   Mon, 18 Jan 2021 12:34:52 +0100
Message-Id: <20210118113358.338814671@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

commit 7a84665619bb5da8c8b6517157875a1fd7632014 upstream.

When setting port traddr to INADDR_ANY, the listening cm_id->device
is NULL. The associate IB device is known only when a connect request
event arrives, so checking T10-PI device capability should be done
at this stage.

Fixes: b09160c3996c ("nvmet-rdma: add metadata/T10-PI support")
Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/target/rdma.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1220,6 +1220,14 @@ nvmet_rdma_find_get_device(struct rdma_c
 	}
 	ndev->inline_data_size = nport->inline_data_size;
 	ndev->inline_page_count = inline_page_count;
+
+	if (nport->pi_enable && !(cm_id->device->attrs.device_cap_flags &
+				  IB_DEVICE_INTEGRITY_HANDOVER)) {
+		pr_warn("T10-PI is not supported by device %s. Disabling it\n",
+			cm_id->device->name);
+		nport->pi_enable = false;
+	}
+
 	ndev->device = cm_id->device;
 	kref_init(&ndev->ref);
 
@@ -1855,14 +1863,6 @@ static int nvmet_rdma_enable_port(struct
 		goto out_destroy_id;
 	}
 
-	if (port->nport->pi_enable &&
-	    !(cm_id->device->attrs.device_cap_flags &
-	      IB_DEVICE_INTEGRITY_HANDOVER)) {
-		pr_err("T10-PI is not supported for %pISpcs\n", addr);
-		ret = -EINVAL;
-		goto out_destroy_id;
-	}
-
 	port->cm_id = cm_id;
 	return 0;
 


