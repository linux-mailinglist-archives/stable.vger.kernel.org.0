Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90245117B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbhKOTJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237897AbhKOTFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:05:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B96AB633E1;
        Mon, 15 Nov 2021 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000186;
        bh=kT+YnfsjxFciu5opeqssVT8tP8KjIQg9Tu3kSaqZ9nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rIFaRzBd7Lt5H+RpRQEA27iLnz4FUbPTWutKbJFxu/W6j/kE5tIFbZyQbYWxKkoo
         bnNt9/CVBbVrL1iv1pH8x3wIxTHYAQb1jrcEJV1jc2tAg8FtduIemXNZhYqyut5B7n
         xpdkGAVvRzuUwzSjZPWkI3hhY3gqLmZQvlsjpEhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Jeffery <andrew@aj.id.au>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 535/849] ipmi: kcs_bmc: Fix a memory leak in the error handling path of kcs_bmc_serio_add_device()
Date:   Mon, 15 Nov 2021 18:00:18 +0100
Message-Id: <20211115165438.364471052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f281d010b87454e72475b668ad66e34961f744e0 ]

In the unlikely event where 'devm_kzalloc()' fails and 'kzalloc()'
succeeds, 'port' would be leaking.

Test each allocation separately to avoid the leak.

Fixes: 3a3d2f6a4c64 ("ipmi: kcs_bmc: Add serio adaptor")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <ecbfa15e94e64f4b878ecab1541ea46c74807670.1631048724.git.christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/kcs_bmc_serio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/kcs_bmc_serio.c b/drivers/char/ipmi/kcs_bmc_serio.c
index 7948cabde50b4..7e2067628a6ce 100644
--- a/drivers/char/ipmi/kcs_bmc_serio.c
+++ b/drivers/char/ipmi/kcs_bmc_serio.c
@@ -73,10 +73,12 @@ static int kcs_bmc_serio_add_device(struct kcs_bmc_device *kcs_bmc)
 	struct serio *port;
 
 	priv = devm_kzalloc(kcs_bmc->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
 	/* Use kzalloc() as the allocation is cleaned up with kfree() via serio_unregister_port() */
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
-	if (!(priv && port))
+	if (!port)
 		return -ENOMEM;
 
 	port->id.type = SERIO_8042;
-- 
2.33.0



