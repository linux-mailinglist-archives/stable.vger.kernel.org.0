Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6096E548645
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386437AbiFMOpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385642AbiFMOni (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:43:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00B6B2E8A;
        Mon, 13 Jun 2022 04:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7782FB80EE6;
        Mon, 13 Jun 2022 11:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C871CC341C6;
        Mon, 13 Jun 2022 11:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121045;
        bh=O1BECb1BwhYEIW1CUebpdzDbEJQLtGkgaLnnWW6lRNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m86mfXN9srmtNV2v94lh/z1MWclq3obJTDDr4PtXMPp/9NLceiziPR8uJ1KGpyVU4
         95kk+v2+FgnAMwQL4ITLei0/QRETZ9WRwaL5ROpAKnakJCxcNNHu1z3tGyCuQqnk27
         WcaI/h+TywEMyxoCCPn2vBIfO2WpExHbDFzh/uhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 252/298] vringh: Fix loop descriptors check in the indirect cases
Date:   Mon, 13 Jun 2022 12:12:26 +0200
Message-Id: <20220613094932.724487421@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit dbd29e0752286af74243cf891accf472b2f3edd8 ]

We should use size of descriptor chain to test loop condition
in the indirect case. And another statistical count is also introduced
for indirect descriptors to avoid conflict with the statistical count
of direct descriptors.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
Message-Id: <20220505100910.137-1-xieyongji@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 14e2043d7685..eab55accf381 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	     int (*copy)(const struct vringh *vrh,
 			 void *dst, const void *src, size_t len))
 {
-	int err, count = 0, up_next, desc_max;
+	int err, count = 0, indirect_count = 0, up_next, desc_max;
 	struct vring_desc desc, *descs;
 	struct vringh_range range = { -1ULL, 0 }, slowrange;
 	bool slow = false;
@@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (count++ == vrh->vring.num) {
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
 			vringh_bad("Descriptor loop in %p", descs);
 			err = -ELOOP;
 			goto fail;
@@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 				i = return_from_indirect(vrh, &up_next,
 							 &descs, &desc_max);
 				slow = false;
+				indirect_count = 0;
 			} else
 				break;
 		}
-- 
2.35.1



