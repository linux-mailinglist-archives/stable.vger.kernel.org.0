Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72220241012
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgHJT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgHJTL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:11:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A4422B4B;
        Mon, 10 Aug 2020 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086688;
        bh=jWqRiW4I0WKBGrfTOQRfUOvpMlfAxLk4XnkZZTMCiq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO8menNCQpuFZgPzo/ircOB0HGmMyOVhvhJJxD/Y5oxJ32lrXj7D601va8ZkUNNDt
         mqNnCwv6wOXdNqWAmFRGrUUJMmB9dah2QHu939KRrd1QmKAVlObhILNLwzmttWLxWV
         vpbxWbssgyeKsJ7FCUIKTqWLtLA7JCCCIGU1zd1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 43/60] gpu: host1x: debug: Fix multiple channels emitting messages simultaneously
Date:   Mon, 10 Aug 2020 15:10:11 -0400
Message-Id: <20200810191028.3793884-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

