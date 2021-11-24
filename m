Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA3C45C1F9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348316AbhKXNYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348795AbhKXNWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B9D61B1E;
        Wed, 24 Nov 2021 12:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758069;
        bh=xLZ9d8b+uT2ykv3DXJMHab5d2GuEU/VFya9yXeEiLkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9IBHLYFdDajrultJE9YkRQ0S4JzVEw+eN8YGBPKLAK3Fj2k5p+1BR0v0BrohGQLY
         XzmhDGWqjRAJF46GRrE8mTk8EJt3j3taVEK1ICkDCdzdjmyaCMWbgL9GJqilpDmrkl
         dWJWdFnMkvudZ5GmgxDYs4YzMY6XJGCIui065zBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/100] iavf: prevent accidental free of filter structure
Date:   Wed, 24 Nov 2021 12:58:07 +0100
Message-Id: <20211124115656.538196688@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 4f0400803818f2642f066d3eacaf013f23554cc7 ]

In iavf_config_clsflower, the filter structure could be accidentally
released at the end, if iavf_parse_cls_flower or iavf_handle_tclass ever
return a non-zero but positive value.

In this case, the function continues through to the end, and will call
kfree() on the filter structure even though it has been added to the
linked list.

This can actually happen because iavf_parse_cls_flower will return
a positive IAVF_ERR_CONFIG value instead of the traditional negative
error codes.

Fix this by ensuring that the kfree() check and error checks are
similar. Use the more idiomatic "if (err)" to catch all non-zero error
codes.

Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 43afe887cac9e..6f6cd013eef3e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3033,11 +3033,11 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	/* start out with flow type and eth type IPv4 to begin with */
 	filter->f.flow_type = VIRTCHNL_TCP_V4_FLOW;
 	err = iavf_parse_cls_flower(adapter, cls_flower, filter);
-	if (err < 0)
+	if (err)
 		goto err;
 
 	err = iavf_handle_tclass(adapter, tc, filter);
-	if (err < 0)
+	if (err)
 		goto err;
 
 	/* add filter to the list */
-- 
2.33.0



