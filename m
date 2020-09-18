Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B534926EDF1
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIRCYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbgIRCQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1848D23718;
        Fri, 18 Sep 2020 02:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395387;
        bh=YBtr1W8K5aODUAYWKFY6BuNG3LLxlaIYNmpyj7AhO+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03KgnMhu4GBfNX3x8xnEDv0rNj7geXrBhzJhvxXpuEiIQobgiHaYQ3yuhomp9Rsiv
         pFvGPSnuIzlxDrSRMXBzjYI+e/+3B6j6nety8m7ugLxsR607IOjUcAzFiNA9VeZ9Nb
         6nVFS288LFPtCYZ6kC8okImHnfLBCzLmTdQVAMU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shreyas Joshi <shreyas.joshi@biamp.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 78/90] printk: handle blank console arguments passed in.
Date:   Thu, 17 Sep 2020 22:14:43 -0400
Message-Id: <20200918021455.2067301-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyas Joshi <shreyas.joshi@biamp.com>

[ Upstream commit 48021f98130880dd74286459a1ef48b5e9bc374f ]

If uboot passes a blank string to console_setup then it results in
a trashed memory. Ultimately, the kernel crashes during freeing up
the memory.

This fix checks if there is a blank parameter being
passed to console_setup from uboot. In case it detects that
the console parameter is blank then it doesn't setup the serial
device and it gracefully exits.

Link: https://lore.kernel.org/r/20200522065306.83-1-shreyas.joshi@biamp.com
Signed-off-by: Shreyas Joshi <shreyas.joshi@biamp.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
[pmladek@suse.com: Better format the commit message and code, remove unnecessary brackets.]
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c1873d325ebda..7acae2f2478d9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2035,6 +2035,9 @@ static int __init console_setup(char *str)
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
+	if (str[0] == 0)
+		return 1;
+
 	if (_braille_console_setup(&str, &brl_options))
 		return 1;
 
-- 
2.25.1

