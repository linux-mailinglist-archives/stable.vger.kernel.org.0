Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A16B4218
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjCJN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjCJN7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:59:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99E1115DE3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:59:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8C360D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F964C4339B;
        Fri, 10 Mar 2023 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456769;
        bh=bUIzCqwq+n2+tYcPNfaXq7TtMeamf3nTUQAXN31hIgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfhIRDNy4NbrVyrOIbVA6rb5cxqlLI/W6eob/TrmzqwFMNv2t716JvpznBBP745Zl
         oj2/ZxSOONTlopdhz+a+cV/I8J7g9fqDNL3TjGFd4Hmo9u+AO1rjPT/c5TrnJGG5Ce
         80jlZpynaK+uMsJ+EZwWBYDytOBdLS1cRxT5Bv/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akinobu Mita <akinobu.mita@gmail.com>,
        Martin Belanger <martin.belanger@dell.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 118/211] nvme-tcp: dont access released socket during error recovery
Date:   Fri, 10 Mar 2023 14:38:18 +0100
Message-Id: <20230310133722.326065888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 76d54bf20cdcc1ed7569a89885e09636e9a8d71d ]

While the error recovery work is temporarily failing reconnect attempts,
running the 'nvme list' command causes a kernel NULL pointer dereference
by calling getsockname() with a released socket.

During error recovery work, the nvme tcp socket is released and a new one
created, so it is not safe to access the socket without proper check.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Fixes: 02c57a82c008 ("nvme-tcp: print actual source IP address through sysfs "address" attr")
Reviewed-by: Martin Belanger <martin.belanger@dell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8cedc1ef496c7..1ca52ac163c2f 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2486,6 +2486,10 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 
 	len = nvmf_get_address(ctrl, buf, size);
 
+	mutex_lock(&queue->queue_lock);
+
+	if (!test_bit(NVME_TCP_Q_LIVE, &queue->flags))
+		goto done;
 	ret = kernel_getsockname(queue->sock, (struct sockaddr *)&src_addr);
 	if (ret > 0) {
 		if (len > 0)
@@ -2493,6 +2497,8 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 		len += scnprintf(buf + len, size - len, "%ssrc_addr=%pISc\n",
 				(len) ? "," : "", &src_addr);
 	}
+done:
+	mutex_unlock(&queue->queue_lock);
 
 	return len;
 }
-- 
2.39.2



