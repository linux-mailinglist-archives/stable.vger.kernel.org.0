Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647E7106F5E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfKVKwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730134AbfKVKwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:52:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B797920718;
        Fri, 22 Nov 2019 10:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419921;
        bh=xyYFUAWcAMDdHO/jt3hyfRiVpGawHPkon/VldhbRt6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMxhCbRWQTNy6deNPTXIFaE5zKTu44BRPqJF39EewGkFMGH5uDp1oiEsnhF/5Sl2j
         YDOGFOHa0V6eHNYi8xr2yBm/W+owVhfGVX54FNEzk5ssnzDesvJQQ8RyEmRcxpsxM/
         Vq9SljgXU8QL/iKracwRxAR5pcJZlbyBfg1v145Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 054/122] IB/mlx4: Avoid implicit enumerated type conversion
Date:   Fri, 22 Nov 2019 11:28:27 +0100
Message-Id: <20191122100759.371285941@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b56511c15713ba6c7572e77a41f7ddba9c1053ec ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/infiniband/hw/mlx4/mad.c:1811:41: warning: implicit conversion
from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
type 'enum ib_qp_create_flags' [-Wenum-conversion]
                qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_TUNNEL_QP;
                                                    ~ ^~~~~~~~~~~~~~~~~~~~~~~

drivers/infiniband/hw/mlx4/mad.c:1819:41: warning: implicit conversion
from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
type 'enum ib_qp_create_flags' [-Wenum-conversion]
                qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_SQP;
                                                    ~ ^~~~~~~~~~~~~~~~~

The type mlx4_ib_qp_flags explicitly provides supplemental values to the
type ib_qp_create_flags. Make that clear to Clang by changing the
create_flags type to u32.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4a43193319894..73cc5cfb72e02 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1120,7 +1120,7 @@ struct ib_qp_init_attr {
 	struct ib_qp_cap	cap;
 	enum ib_sig_type	sq_sig_type;
 	enum ib_qp_type		qp_type;
-	enum ib_qp_create_flags	create_flags;
+	u32			create_flags;
 
 	/*
 	 * Only needed for special QP types, or when using the RW API.
-- 
2.20.1



