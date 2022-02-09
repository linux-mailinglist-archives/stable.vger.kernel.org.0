Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39B34AFB88
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbiBISr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241271AbiBISqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:46:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56562C033259;
        Wed,  9 Feb 2022 10:43:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA902B82380;
        Wed,  9 Feb 2022 18:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EDBC340E9;
        Wed,  9 Feb 2022 18:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432230;
        bh=NF7bdpEtaimpaeLESco45AbjdDq6hHf0+u3NDa3F2lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxn7pHNRoELDApvPska0m3txiJVXoAo3mGYwanxt3sF5rxxVBIN3g5kmj0geek1K4
         oA3HM6DoqwVHUfIMi4IsM8nKg5YFvbVKXViMZWclJSYbQbCpMoZNnF4XyYOVvC6sUf
         tvHCWA5MSUz/zdyx1WSQ7X0zqu8qGe03BobQE6Co/TgT71Rmbt4B7kzfZPrZL53nZQ
         Qrz4lV1ZgUjsP7eugS0HJfcbkrEh5obj8ZAcbaSjxkrSJj4tayn5lTzs8drj08pGur
         +BN9dEuSFCvjRP8HDiIldd2t2iNSTi0FvUh5Q9gumGRdYj2uTy3BZ2xUg8TRaVzTdI
         1jmlhaedcm2qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Chris Leech <cleech@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 12/15] nvme-tcp: fix possible use-after-free in transport error_recovery work
Date:   Wed,  9 Feb 2022 13:42:58 -0500
Message-Id: <20220209184305.47983-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184305.47983-1-sashal@kernel.org>
References: <20220209184305.47983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ff0d06e8ebb53..284d5e756bd6d 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1947,6 +1947,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
 
 	nvme_stop_keep_alive(ctrl);
+	flush_work(&ctrl->async_event_work);
 	nvme_tcp_teardown_io_queues(ctrl, false);
 	/* unquiesce to fail fast pending requests */
 	nvme_start_queues(ctrl);
-- 
2.34.1

