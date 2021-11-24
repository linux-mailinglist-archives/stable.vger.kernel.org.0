Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C118445C18D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346615AbhKXNT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348849AbhKXNRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B1261AE2;
        Wed, 24 Nov 2021 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757920;
        bh=SChXYOXFDadWXM1Eqexk7TQnESs5DthwIXoZDiPRerg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU4ZuRkGK7fu4y9BbLyEfE6lpR6na7cfd7cLnGooZyyPwDwhiB7fYLsYH4dL3tRyV
         dOZXLJXRLE+3bCKhY55dHvzQQn0O+3l0i4RZdubJolmt+5C0j4CTVdtINP58+TMUYV
         7XXNgKEWS5PJThsLXuEKMgJzHWGcxZ+7onbuYz6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.19 320/323] RDMA/netlink: Add __maybe_unused to static inline in C file
Date:   Wed, 24 Nov 2021 12:58:30 +0100
Message-Id: <20211124115729.719654512@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -24,7 +24,7 @@ enum rdma_nl_flags {
  * constant as well and the compiler checks they are the same.
  */
 #define MODULE_ALIAS_RDMA_NETLINK(_index, _val)                                \
-	static inline void __chk_##_index(void)                                \
+	static inline void __maybe_unused __chk_##_index(void)                 \
 	{                                                                      \
 		BUILD_BUG_ON(_index != _val);                                  \
 	}                                                                      \


