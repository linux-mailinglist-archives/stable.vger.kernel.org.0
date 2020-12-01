Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994C42C9DC9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389220AbgLAJ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgLAJCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBEB2221FF;
        Tue,  1 Dec 2020 09:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813319;
        bh=UzTn/NNmFjhHKkHKM2VNwetkheoiIRnjbGe6sTcV5U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CzlfpYh6s/pdfaVyivQINCY5PqAc90Utv35ubYHojwzLxzgye5ButDH0K7HVex3t
         +H9JVMYDnW8gh46jIuxHgjpyUiNOoxJo+sbbc9Z9DdkkiNxHiQxx0ANytURaKuJRrG
         fgWnlM+4RKIJMDLLNeIbTtPmTYhHBUr2WRSNvRV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/57] batman-adv: set .owner to THIS_MODULE
Date:   Tue,  1 Dec 2020 09:53:34 +0100
Message-Id: <20201201084650.581630418@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 14a2e551faea53d45bc11629a9dac88f88950ca7 ]

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/log.c b/net/batman-adv/log.c
index 853773e45f792..837f67c9fad35 100644
--- a/net/batman-adv/log.c
+++ b/net/batman-adv/log.c
@@ -205,6 +205,7 @@ static const struct file_operations batadv_log_fops = {
 	.read           = batadv_log_read,
 	.poll           = batadv_log_poll,
 	.llseek         = no_llseek,
+	.owner          = THIS_MODULE,
 };
 
 /**
-- 
2.27.0



