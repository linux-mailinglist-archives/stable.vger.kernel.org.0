Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1806F328EB6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbhCATfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241874AbhCAT3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EACA64FD4;
        Mon,  1 Mar 2021 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621034;
        bh=SR3jZyqv1cV5R8Tx3PhnQjTjlWlpbLWOaoVUK8u6gCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Odtz9706Q76O91ls8KZo1jkkPamuIBY8JTb8jSMVQSHXzmY0P8zrE3xtEaSLb41O2
         r06Vk3oLLJ165cXj97SF0vv+kbkSiTCpkWFRW+DzoVoqErnav2FHeK1MNq7F14oaqJ
         Gg438mNl2XBPRUgWdNPadSaEnAoeVEuObvruvB3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Lutz Pogrell <lutz.pogrell@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 339/775] RDMA/rtrs-srv: Release lock before call into close_sess
Date:   Mon,  1 Mar 2021 17:08:27 +0100
Message-Id: <20210301161218.372352851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 99f0c3807973359bba8f37d9198eea59fe38c32a ]

In this error case, we don't need hold mutex to call close_sess.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-4-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Tested-by: Lutz Pogrell <lutz.pogrell@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index ed4628f032bb6..341661f42add0 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1863,8 +1863,8 @@ reject_w_econnreset:
 	return rtrs_rdma_do_reject(cm_id, -ECONNRESET);
 
 close_and_return_err:
-	close_sess(sess);
 	mutex_unlock(&srv->paths_mutex);
+	close_sess(sess);
 
 	return err;
 }
-- 
2.27.0



