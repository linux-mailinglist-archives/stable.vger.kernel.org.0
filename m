Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5142B4D8284
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbiCNMFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiCNME3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:04:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE724BFDD;
        Mon, 14 Mar 2022 05:01:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67DDCB80DEB;
        Mon, 14 Mar 2022 12:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC164C340E9;
        Mon, 14 Mar 2022 12:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259291;
        bh=pFeiiUg9ePaABmRbaRp6jWVbhmgiaMpLguGZUGYlztE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=undPuoYLjL10Mm8kB3yOvy4PL3ezsVAvH3iJzMEjGg5mSSL147sr/tjv3BQIUwU3q
         8AjdjDgV+oiK5bufObPUFJMUB1vP2Qab/sUhNUM4TbhM0GJ4xKaMHoJ8kWOE5Md8Cb
         /k+p9BB19iZBOnjt3jdiLuGf0fiK+UrFMXHFbt3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/71] virtio-blk: Dont use MAX_DISCARD_SEGMENTS if max_discard_seg is zero
Date:   Mon, 14 Mar 2022 12:53:01 +0100
Message-Id: <20220314112738.167323732@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
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

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit dacc73ed0b88f1a787ec20385f42ca9dd9eddcd0 ]

Currently the value of max_discard_segment will be set to
MAX_DISCARD_SEGMENTS (256) with no basis in hardware if device
set 0 to max_discard_seg in configuration space. It's incorrect
since the device might not be able to handle such large descriptors.
To fix it, let's follow max_segments restrictions in this case.

Fixes: 1f23816b8eb8 ("virtio_blk: add discard and write zeroes support")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20220304100058.116-1-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 42acf9587ef3..a03390127741 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -869,9 +869,15 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 		virtio_cread(vdev, struct virtio_blk_config, max_discard_seg,
 			     &v);
+
+		/*
+		 * max_discard_seg == 0 is out of spec but we always
+		 * handled it.
+		 */
+		if (!v)
+			v = sg_elems - 2;
 		blk_queue_max_discard_segments(q,
-					       min_not_zero(v,
-							    MAX_DISCARD_SEGMENTS));
+					       min(v, MAX_DISCARD_SEGMENTS));
 
 		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 	}
-- 
2.34.1



