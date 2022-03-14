Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D954D81F2
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbiCNL6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbiCNL6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:58:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5E465D7;
        Mon, 14 Mar 2022 04:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA01161251;
        Mon, 14 Mar 2022 11:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48DDC340E9;
        Mon, 14 Mar 2022 11:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259027;
        bh=IU/bSd/Up1lGH3O2Qg9A2SkcKJiyLwSWHeG6qKlMYTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxWGQz7L1JLFWj+HNXDkDtlGwa7pfbVj5+RD8fEodESw94vnRdpf7G1It2k3xsCTw
         ZuyLOrKEoWnooFDj0ckD+ZgxuhXuRFOSdivC3S1qGwpolKVCU1qIgA261TJFEssXzp
         cddWNvrh9KWga/wt+MmEuo391M/t+jIwyrIAWn8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/43] virtio-blk: Dont use MAX_DISCARD_SEGMENTS if max_discard_seg is zero
Date:   Mon, 14 Mar 2022 12:53:14 +0100
Message-Id: <20220314112734.514655046@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
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
index 816eb2db7308..4b3645e648ee 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -980,9 +980,15 @@ static int virtblk_probe(struct virtio_device *vdev)
 
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



