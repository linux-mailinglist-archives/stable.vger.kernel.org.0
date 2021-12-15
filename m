Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7F475E8B
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245360AbhLORW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245329AbhLORWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C68BC06173E;
        Wed, 15 Dec 2021 09:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC12BB8202A;
        Wed, 15 Dec 2021 17:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4093DC36AE3;
        Wed, 15 Dec 2021 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588967;
        bh=A4maENeQCVMABzfmMhrIFnEwNlJO7mpXz/s5LUCYSgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxCYu8owBpwaLpGNHvNMkkY2qK0KSDE+sQIwwpudLbyYdVBazYXIYNHJJhDfmiMXf
         VO2hJjRx33AXY4ATlGY8PyrjyU5dAXX0rN0e8lIVwCbz/+tVDXnksNHHMS1/8pSkFh
         HbNM/5HTiUulkhYQUATMeGlMObFGyfpLRR0QpKaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/42] RDMA: Fix use-after-free in rxe_queue_cleanup
Date:   Wed, 15 Dec 2021 18:20:44 +0100
Message-Id: <20211215172026.757832323@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 84b01721e8042cdd1e8ffeb648844a09cd4213e0 ]

On error handling path in rxe_qp_from_init() qp->sq.queue is freed and
then rxe_create_qp() will drop last reference to this object. qp clean up
function will try to free this queue one time and it causes UAF bug.

Fix it by zeroing queue pointer after freeing queue in rxe_qp_from_init().

Fixes: 514aee660df4 ("RDMA: Globally allocate and release QP memory")
Link: https://lore.kernel.org/r/20211121202239.3129-1-paskripkin@gmail.com
Reported-by: syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 1ab6af7ddb254..ed326d82725cd 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -367,6 +367,7 @@ int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp *qp, struct rxe_pd *pd,
 
 err2:
 	rxe_queue_cleanup(qp->sq.queue);
+	qp->sq.queue = NULL;
 err1:
 	qp->pd = NULL;
 	qp->rcq = NULL;
-- 
2.33.0



