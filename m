Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5267A3C4989
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhGLGpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238958AbhGLGob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9896610CC;
        Mon, 12 Jul 2021 06:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072030;
        bh=Norb7IlOk35PWp24tVSLNV3ZuTQpAbU8Ohm1mZUsxRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtZCRwB/ThE/oZScTdJKODcioVdMeJUfY4+YksdGIET0RJYW7thJu3upLXH2cAmlT
         rgKPQf/EEmOHRHaBA9SiqCnlusEa7tz+Au+Hj3FftouT6emfi/GvDtL2dwK5B6HR3k
         8rN2CjgqTM/JFi2vC6WNuz3DBUhdRhtzXT6txb0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/593] RDMA/rtrs: Do not reset hb_missed_max after re-connection
Date:   Mon, 12 Jul 2021 08:08:03 +0200
Message-Id: <20210712060921.184530762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index d13aff0aa816..4629bb758126 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -373,7 +373,6 @@ void rtrs_stop_hb(struct rtrs_sess *sess)
 {
 	cancel_delayed_work_sync(&sess->hb_dwork);
 	sess->hb_missed_cnt = 0;
-	sess->hb_missed_max = 0;
 }
 EXPORT_SYMBOL_GPL(rtrs_stop_hb);
 
-- 
2.30.2



