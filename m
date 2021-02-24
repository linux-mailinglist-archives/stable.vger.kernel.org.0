Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E69323D18
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhBXNE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:04:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235376AbhBXMzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3EB064F26;
        Wed, 24 Feb 2021 12:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171093;
        bh=V+Mu4w/uu1b+FG/iSE/9oCAo4LbxmWpqVROZ6wuueF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcBXRBSB1MEpadNhdZhGE0gidBwcVSS9kTRpQ92c0cxMOruh6nsilnuovi71MA03I
         9/4c0I0+Sz/nTxUeBCoRnSVlTiZAyJUUM6YwwwRLyFR6bNBFeMDwUAZY4re4whSB2L
         HtJ9oYO61+p3XaSgdta4GoRPk+gLqjKWiFEb76rnxAjSpsYY7WnaQgnEyhm7nJ81Z+
         DbwqXX6en8LV1M3avzgFoAe5iOJHE4FSMNeNppxBIoqf/UWVpoPygCH+bxXHYWNQfJ
         Sxe1Gm4jbifGi9xibjssBtSPWL7BxzSWbrST4g4i926oEP76haEpx8Ri/CHmlfNC5u
         fdXU2FhLGyDEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 50/67] Drivers: hv: vmbus: Initialize memory to be sent to the host
Date:   Wed, 24 Feb 2021 07:50:08 -0500
Message-Id: <20210224125026.481804-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>

[ Upstream commit e99c4afbee07e9323e9191a20b24d74dbf815bdf ]

__vmbus_open() and vmbus_teardown_gpadl() do not inizialite the memory
for the vmbus_channel_open_channel and the vmbus_channel_gpadl_teardown
objects they allocate respectively.  These objects contain padding bytes
and fields that are left uninitialized and that are later sent to the
host, potentially leaking guest data.  Zero initialize such fields to
avoid leaking sensitive information to the host.

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20201209070827.29335-2-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 6fb0c76bfbf81..0bd202de79600 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -618,7 +618,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 		goto error_clean_ring;
 
 	/* Create and init the channel open message */
-	open_info = kmalloc(sizeof(*open_info) +
+	open_info = kzalloc(sizeof(*open_info) +
 			   sizeof(struct vmbus_channel_open_channel),
 			   GFP_KERNEL);
 	if (!open_info) {
@@ -745,7 +745,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	unsigned long flags;
 	int ret;
 
-	info = kmalloc(sizeof(*info) +
+	info = kzalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
-- 
2.27.0

