Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8013C8C96F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfHNCjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbfHNCLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CD8D2085A;
        Wed, 14 Aug 2019 02:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748701;
        bh=xqS3v1YUYs6IjprirBY5jzrqWlbFrwFG1Nf3A+/Fu00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR11nE1+S/gZZ4sFfETfdqftVJtpv1v66MT5rNRr/jl+1DSJXCt79ofCaIlEtV5Cc
         AdY1sI89RMWZJg1FmUhc+lzrPyuZg7CoCTabhC4dtKuRrkKAxcvRGHEcOUrspBLiXW
         kugYLO/xT+CpXHrPrE2AtHQXFYpryGUMTxo/2BhM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 029/123] ASoC: dapm: fix a memory leak bug
Date:   Tue, 13 Aug 2019 22:09:13 -0400
Message-Id: <20190814021047.14828-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 45004d66f2a28d78f543fb2ffbc133e31dc2d162 ]

In snd_soc_dapm_new_control_unlocked(), a kernel buffer is allocated in
dapm_cnew_widget() to hold the new dapm widget. Then, different actions are
taken according to the id of the widget, i.e., 'w->id'. If any failure
occurs during this process, snd_soc_dapm_new_control_unlocked() should be
terminated by going to the 'request_failed' label. However, the allocated
kernel buffer is not freed on this code path, leading to a memory leak bug.

To fix the above issue, free the buffer before returning from
snd_soc_dapm_new_control_unlocked() through the 'request_failed' label.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Link: https://lore.kernel.org/r/1563803864-2809-1-git-send-email-wang6495@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 835ce1ff188d9..f40adb604c25b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3705,6 +3705,8 @@ snd_soc_dapm_new_control_unlocked(struct snd_soc_dapm_context *dapm,
 		dev_err(dapm->dev, "ASoC: Failed to request %s: %d\n",
 			w->name, ret);
 
+	kfree_const(w->sname);
+	kfree(w);
 	return ERR_PTR(ret);
 }
 
-- 
2.20.1

