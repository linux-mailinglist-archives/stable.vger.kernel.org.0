Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ED91BCB8A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgD1S3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbgD1S3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56CA320730;
        Tue, 28 Apr 2020 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098587;
        bh=Pe1L8dVLg6dmSyWSMeTXLXMbj9DUZKD2yKCpIrM+C3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcYkrD21zUK2toNTCOG1rZsSuTiKuH8SkrRlE0nCUl2jgUmlmIQQQNpljkqXDpNDc
         +whYlpOyL9Nh8Db5yZDccJr87qpjCAygDVy4Y2brHacLj0L7HpUpYeTtX+SRFPa4H/
         1gRGQZjrtxrLEYRUpgbuzHRepNjkDP2vBJner4j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH 5.6 045/167] cxgb4: fix adapter crash due to wrong MC size
Date:   Tue, 28 Apr 2020 20:23:41 +0200
Message-Id: <20200428182230.753937826@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -1049,9 +1049,9 @@ static void cudbg_t4_fwcache(struct cudb
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
@@ -1060,15 +1060,23 @@ static unsigned long cudbg_mem_region_si
 
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
@@ -1076,7 +1084,12 @@ static int cudbg_collect_mem_region(stru
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


