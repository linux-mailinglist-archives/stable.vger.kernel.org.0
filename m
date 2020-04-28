Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB831BCAE4
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbgD1SxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgD1Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9C120B1F;
        Tue, 28 Apr 2020 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098927;
        bh=oevnvzzVhtIAe0+tk50HMNaYqv+LWDbIkC5nIJcDM04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fb4WMNOkyYLIEvC0gdqixuJ9TzqRRUti5nJwyOIChRY6naS3wgKDfD/dSRSBlGuxD
         aywTU70Wu1gCGP8ZafiErcWWsc/o/Esu6Uw5wZXeJGp+4nrjKakncMiqToTIZJMufs
         gNbbWcGqSkr6tCdw9fmBwuWOQsYUprCR48hzbI7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH 4.19 053/131] cxgb4: fix adapter crash due to wrong MC size
Date:   Tue, 28 Apr 2020 20:24:25 +0200
Message-Id: <20200428182231.629366722@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit ce222748078592afb51b810dc154531aeba4f512 ]

In the absence of MC1, the size calculation function
cudbg_mem_region_size() was returing wrong MC size and
resulted in adapter crash. This patch adds new argument
to cudbg_mem_region_size() which will have actual size
and returns error to caller in the absence of MC1.

Fixes: a1c69520f785 ("cxgb4: collect MC memory dump")
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c |   27 ++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1065,9 +1065,9 @@ static void cudbg_t4_fwcache(struct cudb
 	}
 }
 
-static unsigned long cudbg_mem_region_size(struct cudbg_init *pdbg_init,
-					   struct cudbg_error *cudbg_err,
-					   u8 mem_type)
+static int cudbg_mem_region_size(struct cudbg_init *pdbg_init,
+				 struct cudbg_error *cudbg_err,
+				 u8 mem_type, unsigned long *region_size)
 {
 	struct adapter *padap = pdbg_init->adap;
 	struct cudbg_meminfo mem_info;
@@ -1076,15 +1076,23 @@ static unsigned long cudbg_mem_region_si
 
 	memset(&mem_info, 0, sizeof(struct cudbg_meminfo));
 	rc = cudbg_fill_meminfo(padap, &mem_info);
-	if (rc)
+	if (rc) {
+		cudbg_err->sys_err = rc;
 		return rc;
+	}
 
 	cudbg_t4_fwcache(pdbg_init, cudbg_err);
 	rc = cudbg_meminfo_get_mem_index(padap, &mem_info, mem_type, &mc_idx);
-	if (rc)
+	if (rc) {
+		cudbg_err->sys_err = rc;
 		return rc;
+	}
+
+	if (region_size)
+		*region_size = mem_info.avail[mc_idx].limit -
+			       mem_info.avail[mc_idx].base;
 
-	return mem_info.avail[mc_idx].limit - mem_info.avail[mc_idx].base;
+	return 0;
 }
 
 static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
@@ -1092,7 +1100,12 @@ static int cudbg_collect_mem_region(stru
 				    struct cudbg_error *cudbg_err,
 				    u8 mem_type)
 {
-	unsigned long size = cudbg_mem_region_size(pdbg_init, cudbg_err, mem_type);
+	unsigned long size = 0;
+	int rc;
+
+	rc = cudbg_mem_region_size(pdbg_init, cudbg_err, mem_type, &size);
+	if (rc)
+		return rc;
 
 	return cudbg_read_fw_mem(pdbg_init, dbg_buff, mem_type, size,
 				 cudbg_err);


