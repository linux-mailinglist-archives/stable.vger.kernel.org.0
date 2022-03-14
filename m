Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1A4D832F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiCNMNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241138AbiCNMIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D6E496B9;
        Mon, 14 Mar 2022 05:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ADA761251;
        Mon, 14 Mar 2022 12:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AEFC340EC;
        Mon, 14 Mar 2022 12:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259475;
        bh=o1eyfosOZlTJ+hUZYylS3B8wCxvivTOqYdjwqWdX3ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bmk2QGRyQQwROGvk/dwR/uBMV/+Rxavne0u9MM5MNB9JrRrl/1ZBH++vKUMrhICoO
         CbESbLvUHkUqOIVojZZuE/Fmcx1F9Xz2SX/kFeLjVNX4vKf5ESowHBVfE5IG2BDms/
         gj4xakaa/m+MWH0tg6xIS31ZNSZh4DzKZQN7flp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/110] vhost: fix hung thread due to erroneous iotlb entries
Date:   Mon, 14 Mar 2022 12:53:17 +0100
Message-Id: <20220314112743.460512435@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]

In vhost_iotlb_add_range_ctx(), range size can overflow to 0 when
start is 0 and last is ULONG_MAX. One instance where it can happen
is when userspace sends an IOTLB message with iova=size=uaddr=0
(vhost_process_iotlb_msg). So, an entry with size = 0, start = 0,
last = ULONG_MAX ends up in the iotlb. Next time a packet is sent,
iotlb_access_ok() loops indefinitely due to that erroneous entry.

	Call Trace:
	 <TASK>
	 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
	 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
	 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
	 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
	 kthread+0x2e9/0x3a0 kernel/kthread.c:377
	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
	 </TASK>

Reported by syzbot at:
	https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87

To fix this, do two things:

1. Return -EINVAL in vhost_chr_write_iter() when userspace asks to map
   a range with size 0.
2. Fix vhost_iotlb_add_range_ctx() to handle the range [0, ULONG_MAX]
   by splitting it into two entries.

Fixes: 0bbe30668d89e ("vhost: factor out IOTLB")
Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20220305095525.5145-1-mail@anirudhrb.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/iotlb.c | 11 +++++++++++
 drivers/vhost/vhost.c |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 670d56c879e5..40b098320b2a 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -57,6 +57,17 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 	if (last < start)
 		return -EFAULT;
 
+	/* If the range being mapped is [0, ULONG_MAX], split it into two entries
+	 * otherwise its size would overflow u64.
+	 */
+	if (start == 0 && last == ULONG_MAX) {
+		u64 mid = last / 2;
+
+		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
+		addr += mid + 1;
+		start = mid + 1;
+	}
+
 	if (iotlb->limit &&
 	    iotlb->nmaps == iotlb->limit &&
 	    iotlb->flags & VHOST_IOTLB_FLAG_RETIRE) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..55475fd59fb7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1170,6 +1170,11 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
+	if (msg.size == 0) {
+		ret = -EINVAL;
+		goto done;
+	}
+
 	if (dev->msg_handler)
 		ret = dev->msg_handler(dev, &msg);
 	else
-- 
2.34.1



