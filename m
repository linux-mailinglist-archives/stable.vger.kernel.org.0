Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C614328C29
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhCASq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234718AbhCASjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACDE865057;
        Mon,  1 Mar 2021 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619282;
        bh=SXwRkkWMscxW1zS486YfdL6JbMjdQZidxAyHEx17ZiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnO7uOZTP5ptn8dnPl80Tmkw/FpgcnxynBX8iGGoUF8rOvdfN9Ru14L+2eq9AQ6Wa
         yl5Jw2UbMDsZn96qgNM46/7wZsP8ZT1rrHQYa0vh23pTpVZxXoP9XWCFb63c6gYGzC
         bUVVufYToAcdi0zFJ00Uu/14ZznKEwniPg5RWh/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Kotthoff <metalhead@metalhead.ws>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/663] sparc: fix led.c driver when PROC_FS is not enabled
Date:   Mon,  1 Mar 2021 17:10:39 +0100
Message-Id: <20210301161201.209095372@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b3554aa2470b5db1222c31e08ec9c29ab33eabc7 ]

Fix Sparc build when CONFIG_PROC_FS is not enabled.

Fixes this build error:
arch/sparc/kernel/led.c:107:30: error: 'led_proc_ops' defined but not used [-Werror=unused-const-variable=]
     107 | static const struct proc_ops led_proc_ops = {
         |                              ^~~~~~~~~~~~
   cc1: all warnings being treated as errors

Fixes: 97a32539b956 ("proc: convert everything to "struct proc_ops"")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lars Kotthoff <metalhead@metalhead.ws>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/led.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
index bd48575172c32..3a66e62eb2a0e 100644
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -50,6 +50,7 @@ static void led_blink(struct timer_list *unused)
 	add_timer(&led_blink_timer);
 }
 
+#ifdef CONFIG_PROC_FS
 static int led_proc_show(struct seq_file *m, void *v)
 {
 	if (get_auxio() & AUXIO_LED)
@@ -111,6 +112,7 @@ static const struct proc_ops led_proc_ops = {
 	.proc_release	= single_release,
 	.proc_write	= led_proc_write,
 };
+#endif
 
 static struct proc_dir_entry *led;
 
-- 
2.27.0



