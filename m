Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A52499801
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354454AbiAXVSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:18:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449726AbiAXVQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8292611C8;
        Mon, 24 Jan 2022 21:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6249AC340E4;
        Mon, 24 Jan 2022 21:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058964;
        bh=0pMuCKPO/MhYjB/3MEoZSaWEvbcXKnkvLaoassEfGl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjOgep8rP8b7XmOx/qYM4OmmuaS1mQrbTw59OP2jPYwx+H/cKKTBKwHDTS8BN0KsU
         lfr0wk0PD4wX9Gl0J3nTAvfhVUHwa9GSgxBvVXG8o1qzsAniBBZf12Wvkseri8Jucf
         77D5rNuJyI76RjUZdterFIkfDMb+zgZJPX7J9sVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Guoqing Jiang <Guoqing.Jiang@linux.dev>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0459/1039] RDMA/rtrs-clt: Fix the initial value of min_latency
Date:   Mon, 24 Jan 2022 19:37:28 +0100
Message-Id: <20220124184140.723253545@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 925cac6358677d3d64f9b25f205eeb3d31c9f7f8 ]

The type of min_latency is ktime_t, so use KTIME_MAX to initialize the
initial value.

Fixes: dc3b66a0ce70 ("RDMA/rtrs-clt: Add a minimum latency multipath policy")
Link: https://lore.kernel.org/r/20211124081040.19533-1-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Guoqing Jiang <Guoqing.Jiang@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 15c0077dd27eb..e39709dee179d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -867,7 +867,7 @@ static struct rtrs_clt_sess *get_next_path_min_latency(struct path_it *it)
 	struct rtrs_clt_sess *min_path = NULL;
 	struct rtrs_clt *clt = it->clt;
 	struct rtrs_clt_sess *sess;
-	ktime_t min_latency = INT_MAX;
+	ktime_t min_latency = KTIME_MAX;
 	ktime_t latency;
 
 	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
-- 
2.34.1



