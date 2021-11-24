Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EB045C352
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352724AbhKXNhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352293AbhKXNfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:35:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 247F561B46;
        Wed, 24 Nov 2021 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758478;
        bh=dxMeMWzvD+r0AC7RHCy7M+JSL7yW8kzN/l+dsq7v6Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2ej0GnL3ySgszBP5Rz4SesgYDi+rBhu9HKDM7WdEjQts1C4XzNo8qVpclHf9GJQZ
         rSNUPvxCd7yS0ubhnS1b9Jo6TIy4WkR06PSeKDHW2E3eB6MOk47op9jiBDQgtwfbpG
         3U6LWktBU0n5OwFch2JBaVw2y0zVNwQdccAyW6xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/154] iavf: prevent accidental free of filter structure
Date:   Wed, 24 Nov 2021 12:58:00 +0100
Message-Id: <20211124115705.032668327@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index b0fe5aafd1b26..90a9379b4e467 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3027,11 +3027,11 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
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



