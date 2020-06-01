Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14491EAEA4
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgFASAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729704AbgFASAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CCCD2065C;
        Mon,  1 Jun 2020 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034447;
        bh=WBCdEH8GKHz5nCd+RlGwF13pOXtU5+lvt/v8NAxJiKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yxqj3K/tAhTokUjES7rbUs4jaMoKWfIwzDxfeHkQ8as057hc0vNIqIPhGIj5oYlks
         9K7sq6F3RexjDofGGL1VR+dHdRKi6jj/ELrNwuAc89mTOYOcNzX+gfRo6jTFzrTDja
         tRAQp4t8EmjlQnrAZ7k77UsnhORDhm8edKrpaWmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/77] gpio: exar: Fix bad handling for ida_simple_get error path
Date:   Mon,  1 Jun 2020 19:53:41 +0200
Message-Id: <20200601174023.003429263@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 333830aa149a87cabeb5d30fbcf12eecc8040d2c ]

The commit 7ecced0934e5 ("gpio: exar: add a check for the return value
of ida_simple_get fails") added a goto jump to the common error
handler for ida_simple_get() error, but this is wrong in two ways:
it doesn't set the proper return code and, more badly, it invokes
ida_simple_remove() with a negative index that shall lead to a kernel
panic via BUG_ON().

This patch addresses those two issues.

Fixes: 7ecced0934e5 ("gpio: exar: add a check for the return value of ida_simple_get fails")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-exar.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-exar.c b/drivers/gpio/gpio-exar.c
index a09d2f9ebacc..695c19901eff 100644
--- a/drivers/gpio/gpio-exar.c
+++ b/drivers/gpio/gpio-exar.c
@@ -148,8 +148,10 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	mutex_init(&exar_gpio->lock);
 
 	index = ida_simple_get(&ida_index, 0, 0, GFP_KERNEL);
-	if (index < 0)
-		goto err_destroy;
+	if (index < 0) {
+		ret = index;
+		goto err_mutex_destroy;
+	}
 
 	sprintf(exar_gpio->name, "exar_gpio%d", index);
 	exar_gpio->gpio_chip.label = exar_gpio->name;
@@ -176,6 +178,7 @@ static int gpio_exar_probe(struct platform_device *pdev)
 
 err_destroy:
 	ida_simple_remove(&ida_index, index);
+err_mutex_destroy:
 	mutex_destroy(&exar_gpio->lock);
 	return ret;
 }
-- 
2.25.1



