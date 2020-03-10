Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A67517F97A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgCJM5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbgCJM5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940EB20674;
        Tue, 10 Mar 2020 12:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845031;
        bh=kFPwuE5ZqLxEVxKWnapOEi+Fe0RnV174k4NEdaYdxBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHPgumxJ67P/wMOwASwa4Je3KOqEHN6VvfiM1Q3M9d8MwHU2V41Z6pqf9y0uIU9fS
         fXbqiSFS3b9h3SmZGK7faUUPNJvQCbGlJRvGoMjn4cQEfGTDrlaBkfDZe6D+XL6TRf
         u70JM8prJVfR4FivNdt+SB9CDQnIvwY5VMfKHvoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 008/189] RDMA/core: Fix use of logical OR in get_new_pps
Date:   Tue, 10 Mar 2020 13:37:25 +0100
Message-Id: <20200310123640.402771499@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 4ca501d6aaf21de31541deac35128bbea8427aa6 ]

Clang warns:

../drivers/infiniband/core/security.c:351:41: warning: converting the
enum constant to a boolean [-Wint-in-bool-context]
        if (!(qp_attr_mask & (IB_QP_PKEY_INDEX || IB_QP_PORT)) && qp_pps) {
                                               ^
1 warning generated.

A bitwise OR should have been used instead.

Fixes: 1dd017882e01 ("RDMA/core: Fix protection fault in get_pkey_idx_qp_list")
Link: https://lore.kernel.org/r/20200217204318.13609-1-natechancellor@gmail.com
Link: https://github.com/ClangBuiltLinux/linux/issues/889
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 9e27ca18d3270..2d5608315dc80 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -352,7 +352,7 @@ static struct ib_ports_pkeys *get_new_pps(const struct ib_qp *qp,
 	if ((qp_attr_mask & IB_QP_PKEY_INDEX) && (qp_attr_mask & IB_QP_PORT))
 		new_pps->main.state = IB_PORT_PKEY_VALID;
 
-	if (!(qp_attr_mask & (IB_QP_PKEY_INDEX || IB_QP_PORT)) && qp_pps) {
+	if (!(qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) && qp_pps) {
 		new_pps->main.port_num = qp_pps->main.port_num;
 		new_pps->main.pkey_index = qp_pps->main.pkey_index;
 		if (qp_pps->main.state != IB_PORT_PKEY_NOT_VALID)
-- 
2.20.1



