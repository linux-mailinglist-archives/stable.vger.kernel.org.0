Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9239328F5F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241987AbhCATua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241209AbhCATlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:41:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 705B864EE8;
        Mon,  1 Mar 2021 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618811;
        bh=dHE4I/i4bvyOJ+qeRR6QKBP7TfSyNQjeJrUno7D2LDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNbFdSpPkSmU0Qt/c6ynwl2Q6wgyDc054oU796D2rJXj/N0J9LN0swe3olKmQc0sY
         RcaOzJZ+Sf/I5qkVQCT5U85/AklaSvUHegVtxa4I22s5xjb/O1rnjqtpdDjw7IZwH/
         UuAFCL4vk8FBdrfwqtoag8edtuT+aqBE9DKKFBRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Hui Wang <hui.wang@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/663] ASoC: SOF: debug: Fix a potential issue on string buffer termination
Date:   Mon,  1 Mar 2021 17:07:52 +0100
Message-Id: <20210301161152.882444302@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 9037c3bde65d339017ef41d81cb58069ffc321d4 ]

The function simple_write_to_buffer() doesn't add string termination
at the end of buf, we need to handle it on our own. This change refers
to the function tokenize_input() in debug.c and the function
sof_dfsentry_trace_filter_write() in trace.c.

Fixes: 091c12e1f50c ("ASoC: SOF: debug: add new debugfs entries for IPC flood test")
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210208103857.75705-1-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index 9419a99bab536..3ef51b2210237 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -350,7 +350,7 @@ static ssize_t sof_dfsentry_write(struct file *file, const char __user *buffer,
 	char *string;
 	int ret;
 
-	string = kzalloc(count, GFP_KERNEL);
+	string = kzalloc(count+1, GFP_KERNEL);
 	if (!string)
 		return -ENOMEM;
 
-- 
2.27.0



