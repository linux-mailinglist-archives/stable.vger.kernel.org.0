Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F4826F014
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgIRCkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgIRCLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530432311C;
        Fri, 18 Sep 2020 02:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395093;
        bh=CViT9YanrobkeCxJtGqa5HogF32VB1HzO7rKTYXvse4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOZ0Fvjx/jRbb7NN/HEnc8YTO8UEcI2GTgq1lJct5GDkyR2KrqYWjuwDh2wAtqW86
         pyiQsEwk8EJrwaSgMGCaiu/Q5MVw1VqrKi2+iovMONcRoKf0uRR7Yg4/HuH48QDLBg
         8Z8SZFsanqs0gz/XCHX6lkVFVRlldS7onTjKW2so=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shreyas Joshi <shreyas.joshi@biamp.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 174/206] printk: handle blank console arguments passed in.
Date:   Thu, 17 Sep 2020 22:07:30 -0400
Message-Id: <20200918020802.2065198-174-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
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
index 3cb0e5b479ff3..cf272aba362be 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2148,6 +2148,9 @@ static int __init console_setup(char *str)
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
+	if (str[0] == 0)
+		return 1;
+
 	if (_braille_console_setup(&str, &brl_options))
 		return 1;
 
-- 
2.25.1

