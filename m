Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C8D4BE6E6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbiBUJOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348135AbiBUJLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:11:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E4201A4;
        Mon, 21 Feb 2022 01:02:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78B1FB80EB6;
        Mon, 21 Feb 2022 09:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B5BC340F3;
        Mon, 21 Feb 2022 09:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434172;
        bh=I2o1dGfDTstkhrDwebLcoM7tN/dHqAwLAIWTVj7CiB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE1oaBqspTYHKjuENuJNo20Wyatd2KRpOs0C3egCZVWJUBHt/iT/Yg5t8iZH3zV0m
         JprNtLfDZjV815BI0oA1B5NeQKO1H8i88j7dVj3aztsWUco23TYyTL5iqzP88+YFXt
         cS+w/nm+v3b8gCw5dxNlUA5W7xELbtOQ6lk2AzX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/121] nvme-tcp: fix possible use-after-free in transport error_recovery work
Date:   Mon, 21 Feb 2022 09:48:50 +0100
Message-Id: <20220221084922.479783397@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit ff9fc7ebf5c06de1ef72a69f9b1ab40af8b07f9e ]

While nvme_tcp_submit_async_event_work is checking the ctrl and queue
state before preparing the AER command and scheduling io_work, in order
to fully prevent a race where this check is not reliable the error
recovery work must flush async_event_work before continuing to destroy
the admin queue after setting the ctrl state to RESETTING such that
there is no race .submit_async_event and the error recovery handler
itself changing the ctrl state.

Tested-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 662028d7a1c6a..6105894a218a5 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2077,6 +2077,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
 
 	nvme_stop_keep_alive(ctrl);
+	flush_work(&ctrl->async_event_work);
 	nvme_tcp_teardown_io_queues(ctrl, false);
 	/* unquiesce to fail fast pending requests */
 	nvme_start_queues(ctrl);
-- 
2.34.1



