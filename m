Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED3C1CAB96
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgEHMpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729255AbgEHMpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7478321473;
        Fri,  8 May 2020 12:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941899;
        bh=3zx6t6ksHsLerlaxE/RXly0ozGNWWQAB+vLwy+3XEFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W46uS15TE6z9xtxX+MqGchqkDa8rqm4eViF+cm4bfnD9xg+283i43doJ7XliGc1+0
         V55tFHccHmsrfq9kWaI1aFBsoWKTbxfCzm43PtW4PWBqqCu7CkczU7UsZKEBKa1Ql7
         Hr5hpsLJMgKI2jtmW5hxQa6vKlSIf0A/sPljdh5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 216/312] net/mlx4_core: Fix the resource-type enum in res tracker to conform to FW spec
Date:   Fri,  8 May 2020 14:33:27 +0200
Message-Id: <20200508123139.629407998@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit aa0c08feae8161b945520ada753d0dfe62b14fe7 upstream.

The resource type enum in the resource tracker was incorrect.
RES_EQ was put in the position of RES_NPORT_ID (a FC resource).

Since the remaining resources maintain their current values,
and RES_EQ is not passed from slaves to the hypervisor in any
FW command, this change affects only the hypervisor.
Therefore, there is no backwards-compatibility issue.

Fixes: 623ed84b1f95 ("mlx4_core: initial header-file changes for SRIOV support")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -143,9 +143,10 @@ enum mlx4_resource {
 	RES_MTT,
 	RES_MAC,
 	RES_VLAN,
-	RES_EQ,
+	RES_NPORT_ID,
 	RES_COUNTER,
 	RES_FS_RULE,
+	RES_EQ,
 	MLX4_NUM_OF_RESOURCE_TYPE
 };
 


