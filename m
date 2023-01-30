Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AA9680F97
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbjA3NzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbjA3Nyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D7E38EB6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4CFEB8114A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29071C4339B;
        Mon, 30 Jan 2023 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086884;
        bh=YJh0KEvg139heAIAZmWjn3YqiW+d/l96WNQNoNX/zVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWGzJSB/gb05088ruwNgwxRBdCKdmZ6iyBFpWcxgYfMVjb2xqYAq2I1z3HLrF1FL9
         ZGi8UM/V9noyzi0HC1Ak4lbGk8QfrVlFoP6Ml7feUsT9biLFpphWV9zczpTn5B9WYP
         Zp46CwCbTa0fJUChMC+NfIkaLF3dppUj5yH5BpvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/313] firmware: arm_scmi: Harden shared memory access in fetch_notification
Date:   Mon, 30 Jan 2023 14:47:43 +0100
Message-Id: <20230130134337.982240592@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 9bae076cd4e3e3c3dc185cae829d80b2dddec86e ]

A misbheaving SCMI platform firmware could reply with out-of-spec
notifications, shorter than the mimimum size comprising a header.

Fixes: d5141f37c42e ("firmware: arm_scmi: Add notifications support in transport layer")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222183823.518856-4-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 135f8718000f..87b4f4d35f06 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -94,8 +94,10 @@ void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 void shmem_fetch_notification(struct scmi_shared_mem __iomem *shmem,
 			      size_t max_len, struct scmi_xfer *xfer)
 {
+	size_t len = ioread32(&shmem->length);
+
 	/* Skip only the length of header in shmem area i.e 4 bytes */
-	xfer->rx.len = min_t(size_t, max_len, ioread32(&shmem->length) - 4);
+	xfer->rx.len = min_t(size_t, max_len, len > 4 ? len - 4 : 0);
 
 	/* Take a copy to the rx buffer.. */
 	memcpy_fromio(xfer->rx.buf, shmem->msg_payload, xfer->rx.len);
-- 
2.39.0



