Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0FD45C55F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348264AbhKXN5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352514AbhKXNzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:55:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4679D632B2;
        Wed, 24 Nov 2021 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759187;
        bh=c8/Cp6pkyJ4nAK+6uvW1BFIj5vI1A5OfUoWOTgTYBA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCJ22wJaHmf+ukVm9YY+gxmuMS91G8gGCM25SmX7wwfOP5P4PWD5A2XqUDKYCvNUQ
         20hsI/bXg1oMqiNfNmnMnsQms2Scl1vRjC6u6UtskxOEEKn2ZKKQZcayAdUYRfWXw3
         CSZzGlN/YsB4CRc9Ob/woebsnWlE5pw6OxNgz07M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/279] iavf: prevent accidental free of filter structure
Date:   Wed, 24 Nov 2021 12:56:55 +0100
Message-Id: <20211124115723.228277293@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
index 44ea67cb3716b..43c33effd4177 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3054,11 +3054,11 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
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



