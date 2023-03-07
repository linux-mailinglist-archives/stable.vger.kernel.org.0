Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68DA6AEAED
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjCGRip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbjCGRiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F161E4BEA8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0975B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1385C433EF;
        Tue,  7 Mar 2023 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210452;
        bh=KbrNRuD8hH7gOnI1vOCWblkMpwXAwaBhdipgrDChGLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqcZZ9/KgN6nsB12iWACbs/5BKsJ5ZA8xRHtNCYiLVuVv+Kw7V4hgGRx8BrEFoZly
         ulgJRGNECjCC6pd8AkLJ5xX7Dwx2eu94XMDUe61x90bE2uksUdSZn1UYrMOI5e+Hjt
         JlkOV8Bkoa0xY0m39HtNQSJ2d7ZOC7YFFFEsXl68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0545/1001] RDMA/cxgb4: Fix potential null-ptr-deref in pass_establish()
Date:   Tue,  7 Mar 2023 17:55:17 +0100
Message-Id: <20230307170045.108618575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 283861a4c52c1ea4df3dd1b6fc75a50796ce3524 ]

If get_ep_from_tid() fails to lookup non-NULL value for ep, ep is
dereferenced later regardless of whether it is empty.
This patch adds a simple sanity check to fix the issue.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 944661dd97f4 ("RDMA/iw_cxgb4: atomically lookup ep and get a reference")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230202184850.29882-1-n.zhandarovich@fintech.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index ea3ddf0d24114..ced615b5ea096 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2676,6 +2676,9 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	u16 tcp_opt = ntohs(req->tcp_opt);
 
 	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
+
 	pr_debug("ep %p tid %u\n", ep, ep->hwtid);
 	ep->snd_seq = be32_to_cpu(req->snd_isn);
 	ep->rcv_seq = be32_to_cpu(req->rcv_isn);
-- 
2.39.2



