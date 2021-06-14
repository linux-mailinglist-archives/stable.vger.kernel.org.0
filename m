Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4ED3A6213
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhFNKzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234570AbhFNKxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:53:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B65126140B;
        Mon, 14 Jun 2021 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667193;
        bh=DyPufrIQO7Oz9T/tZb14Y2MiwNFdBpCWs46Swdsf2ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IH1SCQ+fA52SFvcoGM0bxwk60gcSTbJ0payx43tHronofHXcIi8vTbqRs51zkXiWR
         SI8Rr9D2LhFEQqFpMV8gGKd92H0ys4nDMj/bf+2EDlnSvaF9Q88S+DkGiqtONcnq4+
         yB42iCHbnRDBHyxf3URpqvH8Smm/dPa8YTu1EJbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/84] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Date:   Mon, 14 Jun 2021 12:27:07 +0200
Message-Id: <20210614102647.353180639@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 65161c35554f7135e6656b3df1ce2c500ca0bdcf ]

Eliminate the follow smatch warning:

drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1227
bnx2x_iov_init_one() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 5097a44686b3..cf39623b828b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1245,8 +1245,10 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
 		goto failed;
 
 	/* SR-IOV capability was enabled but there are no VFs*/
-	if (iov->total == 0)
+	if (iov->total == 0) {
+		err = -EINVAL;
 		goto failed;
+	}
 
 	iov->nr_virtfn = min_t(u16, iov->total, num_vfs_param);
 
-- 
2.30.2



