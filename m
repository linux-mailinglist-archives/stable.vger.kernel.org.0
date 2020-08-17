Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BCA2476BA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgHQTlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgHQPZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E472310F;
        Mon, 17 Aug 2020 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677912;
        bh=jWqRiW4I0WKBGrfTOQRfUOvpMlfAxLk4XnkZZTMCiq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osKzxK9f9+2fVk5QsDNDUGB4DquqZzgFu9IVIlPdoV43hw3mW1ZhSXnQrQb7PBqsD
         teuUI3fenVILkOc+rrqYhPRhHSswOAmB8Uw1zCREVeGWNBNxynfbT1WOnnzjTwCJ8C
         uI+T29wf1hFv6VeamSokLqxTERl6VjuPqJR4n6YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 123/464] gpu: host1x: debug: Fix multiple channels emitting messages simultaneously
Date:   Mon, 17 Aug 2020 17:11:16 +0200
Message-Id: <20200817143839.704870535@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 35681862808472a0a4b9a8817ae2789c0b5b3edc ]

Once channel's job is hung, it dumps the channel's state into KMSG before
tearing down the offending job. If multiple channels hang at once, then
they dump messages simultaneously, making the debug info unreadable, and
thus, useless. This patch adds mutex which allows only one channel to emit
debug messages at a time.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
index c0392672a8421..1b4997bda1c79 100644
--- a/drivers/gpu/host1x/debug.c
+++ b/drivers/gpu/host1x/debug.c
@@ -16,6 +16,8 @@
 #include "debug.h"
 #include "channel.h"
 
+static DEFINE_MUTEX(debug_lock);
+
 unsigned int host1x_debug_trace_cmdbuf;
 
 static pid_t host1x_debug_force_timeout_pid;
@@ -52,12 +54,14 @@ static int show_channel(struct host1x_channel *ch, void *data, bool show_fifo)
 	struct output *o = data;
 
 	mutex_lock(&ch->cdma.lock);
+	mutex_lock(&debug_lock);
 
 	if (show_fifo)
 		host1x_hw_show_channel_fifo(m, ch, o);
 
 	host1x_hw_show_channel_cdma(m, ch, o);
 
+	mutex_unlock(&debug_lock);
 	mutex_unlock(&ch->cdma.lock);
 
 	return 0;
-- 
2.25.1



