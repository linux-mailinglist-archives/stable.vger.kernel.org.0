Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA18323D4E
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhBXNHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:07:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234414AbhBXNB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C2564F48;
        Wed, 24 Feb 2021 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171185;
        bh=SDaAoKhN4M1rL5X4X8nRSY9FAt8oFdpyzhohOMA9ZZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWJz3VtzEyfmOi9ia3zbouNmAzcRxV5CUDF/poWImnqCxVhx5NKpJ1utKoyBWmKME
         NEWBg22bxg0TK4wZ5t3HikrBqMMJN1hE6bsPf5kqmUJTBOL3MviGtfNUc0acyyqcww
         JkkazSt9ruBoYL4aYR0M/ZGeRXiwyusMYxEXEwhDjzvRX48uCAH+1p2wP6IamajiM2
         pQIIfRwzgGW2Y6W2RnDoebKUYBY8/kdBtalDF9NwNXSlvo0A6C1QDk7HDoEkjXarCE
         HYMp7lUNVJX/jz1WgOcAWvWxCI4HJiXlyE2FKDqKtSD8MP8hfY56DEp0/oaawjUxdQ
         Ix9lLlGBpRm5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 40/56] Drivers: hv: vmbus: Initialize memory to be sent to the host
Date:   Wed, 24 Feb 2021 07:51:56 -0500
Message-Id: <20210224125212.482485-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index fbdda9938039a..f9f04b5cd303f 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -548,7 +548,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 		goto error_clean_ring;
 
 	/* Create and init the channel open message */
-	open_info = kmalloc(sizeof(*open_info) +
+	open_info = kzalloc(sizeof(*open_info) +
 			   sizeof(struct vmbus_channel_open_channel),
 			   GFP_KERNEL);
 	if (!open_info) {
@@ -674,7 +674,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	unsigned long flags;
 	int ret;
 
-	info = kmalloc(sizeof(*info) +
+	info = kzalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
-- 
2.27.0

