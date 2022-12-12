Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB564A203
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiLLNss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiLLNsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:48:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3F426F5
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:47:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D25B4B80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38CEC433D2;
        Mon, 12 Dec 2022 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852870;
        bh=QxNAc1PgWAVXXgZf7aGU/S81aJTaX8ON1GhIJjkIpyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lW0dRxcqBA6PBgXU5scSrCcb6vhkxNdkdCmXiGAIYlksxqeYfBAZhsPws4yUK/Uu2
         dlTIVBc0Grnj+JdrS+UVgPYXDyw3lmEE87KSZItSBSd9X33TwowsILZRtXUq0KkCxi
         qStafP8k8pHZakOO101XEzUKY6jgqdWf0q7NMqEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Stefano Stabellini <sstabellini@kernel.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/49] 9p/xen: check logical size for buffer size
Date:   Mon, 12 Dec 2022 14:18:49 +0100
Message-Id: <20221212130914.239272408@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 391c18cf776eb4569ecda1f7794f360fe0a45a26 ]

trans_xen did not check the data fits into the buffer before copying
from the xen ring, but we probably should.
Add a check that just skips the request and return an error to
userspace if it did not fit

Tested-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Link: https://lkml.kernel.org/r/20221118135542.63400-1-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index ac60ddfcd88b..6459c2356ff9 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -230,6 +230,14 @@ static void p9_xen_response(struct work_struct *work)
 			continue;
 		}
 
+		if (h.size > req->rc.capacity) {
+			dev_warn(&priv->dev->dev,
+				 "requested packet size too big: %d for tag %d with capacity %zd\n",
+				 h.size, h.tag, req->rc.capacity);
+			req->status = REQ_STATUS_ERROR;
+			goto recv_error;
+		}
+
 		memcpy(&req->rc, &h, sizeof(h));
 		req->rc.offset = 0;
 
@@ -239,6 +247,7 @@ static void p9_xen_response(struct work_struct *work)
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE);
 
+recv_error:
 		virt_mb();
 		cons += h.size;
 		ring->intf->in_cons = cons;
-- 
2.35.1



