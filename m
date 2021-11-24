Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC34145C69B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351896AbhKXOKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354351AbhKXOH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EDD361242;
        Wed, 24 Nov 2021 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759575;
        bh=qga7bKfNy0GUN1l9l6rNWveOX+HjHy/FBsRGpx5ufgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frbvahRKS1R7iQrRdtaob5mXmOvWKJZnKN5oL1Zefgzgt/1StspNNzPc3XYrA0twZ
         kkjNuOYi2rM/DW5HOKZyF5pAl3IkzzyOf+FnWe5iBt0eFTgDDxupPQSzRB4gCy+gNu
         NWPz0IplomNUzrcGRioJhX7IcwYNscqwXlWb56qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 268/279] RDMA/netlink: Add __maybe_unused to static inline in C file
Date:   Wed, 24 Nov 2021 12:59:15 +0100
Message-Id: <20211124115727.954173747@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

commit 83dde7498fefeb920b1def317421262317d178e5 upstream.

Like other commits in the tree add __maybe_unused to a static inline in a
C file because some clang compilers will complain about unused code:

>> drivers/infiniband/core/nldev.c:2543:1: warning: unused function '__chk_RDMA_NL_NLDEV'
   MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_NLDEV, 5);
   ^

Fixes: e3bf14bdc17a ("rdma: Autoload netlink client modules")
Link: https://lore.kernel.org/r/4a8101919b765e01d7fde6f27fd572c958deeb4a.1636267207.git.leonro@nvidia.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/rdma/rdma_netlink.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -30,7 +30,7 @@ enum rdma_nl_flags {
  * constant as well and the compiler checks they are the same.
  */
 #define MODULE_ALIAS_RDMA_NETLINK(_index, _val)                                \
-	static inline void __chk_##_index(void)                                \
+	static inline void __maybe_unused __chk_##_index(void)                 \
 	{                                                                      \
 		BUILD_BUG_ON(_index != _val);                                  \
 	}                                                                      \


