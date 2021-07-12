Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDDF3C53B9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348506AbhGLHzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350664AbhGLHvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D9D061C39;
        Mon, 12 Jul 2021 07:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076041;
        bh=RmO2ylWvqhA3ynGYBOtxDQj5emxWroMrHncYQiICBBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcNxJnYha3RYq84gJ2OtXlHiYFBcQM0CcIGKQkpivw7gs89W1gh+lseMBcTz/OVGF
         r3fhBpOY7iFLyH+FRdwT09ZZpn/nPBF7u9uUng27FmV9a1VI6khnRaG7o54s2GyxQL
         nXtGDe0zx2ZC1h/Q0zcEdLoahcfoO6WtW2mwKp98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 430/800] RDMA/rtrs: Do not reset hb_missed_max after re-connection
Date:   Mon, 12 Jul 2021 08:07:33 +0200
Message-Id: <20210712061012.825308375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 64bce1ee978491a779eb31098b21c57d4e431d6a ]

When re-connecting, it resets hb_missed_max to 0.
Before the first re-connecting, client will trigger re-connection
when it gets hb-ack more than 5 times. But after the first
re-connecting, clients will do re-connection whenever it does
not get hb-ack because hb_missed_max is 0.

There is no need to reset hb_missed_max when re-connecting.
hb_missed_max should be kept until closing the session.

Fixes: c0894b3ea69d3 ("RDMA/rtrs: core: lib functions shared between client and server modules")
Link: https://lore.kernel.org/r/20210528113018.52290-16-jinpu.wang@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index a7847282a2eb..4e602e40f623 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -376,7 +376,6 @@ void rtrs_stop_hb(struct rtrs_sess *sess)
 {
 	cancel_delayed_work_sync(&sess->hb_dwork);
 	sess->hb_missed_cnt = 0;
-	sess->hb_missed_max = 0;
 }
 EXPORT_SYMBOL_GPL(rtrs_stop_hb);
 
-- 
2.30.2



