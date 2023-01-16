Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4061F66C93D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbjAPQrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbjAPQqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD4129E11
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:34:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02FFCB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDBFC433EF;
        Mon, 16 Jan 2023 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886875;
        bh=A86dMdas0c3t8ilFHX1j6HsOWI4koY7VPms9YkKUxno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ajT0uvrWngZZeGqb7ZVP0gIGFMF0yENPkX1MTh6Ybzu1AdCaGM5cvjGCOaFD8pAa
         opTEYNL4jCL9gttVjQa+JdpVtdpwHs8vvImTu6m4VXDk9HegP48mk30I3Ay1CyocwS
         jtx1wA+qTtSMpOWHPITYTCpSYwvJWvT+RHCQ7ch8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 578/658] RDMA/uverbs: Silence shiftTooManyBitsSigned warning
Date:   Mon, 16 Jan 2023 16:51:06 +0100
Message-Id: <20230116154935.947295918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 9b8d846924856570625b93f83ae0624391193bce ]

Fix reported by kbuild warning.

   drivers/infiniband/core/uverbs_cmd.c:1897:47: warning: Shifting signed 32-bit value by 31 bits is undefined behaviour [shiftTooManyBitsSigned]
    BUILD_BUG_ON(IB_USER_LAST_QP_ATTR_MASK == (1 << 31));
                                                 ^
Link: https://lore.kernel.org/r/20200720175627.1273096-3-leon@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8de8482fe573 ("RDMA/mlx5: Fix validation of max_rd_atomic caps for DC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d413dafb9211..39cbb853f913 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1952,7 +1952,7 @@ static int ib_uverbs_ex_modify_qp(struct uverbs_attr_bundle *attrs)
 	 * Last bit is reserved for extending the attr_mask by
 	 * using another field.
 	 */
-	BUILD_BUG_ON(IB_USER_LAST_QP_ATTR_MASK == (1 << 31));
+	BUILD_BUG_ON(IB_USER_LAST_QP_ATTR_MASK == (1ULL << 31));
 
 	if (cmd.base.attr_mask &
 	    ~((IB_USER_LAST_QP_ATTR_MASK << 1) - 1))
-- 
2.35.1



