Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7423E4124BA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353101AbhITShI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380896AbhITSfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58EA063311;
        Mon, 20 Sep 2021 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158939;
        bh=IXZIPmogRXfq9EqsOwfePQHSv7qJQzlfsXqwOOkqn7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Goy05qD2FGFsJmT3QLjRmS1k2yH56guKR8PHb7jR+rVtpXXT2ADwqtJTNIrcVilHt
         x6EQEuhPyCjzny0R0eVHv4VTLTtNc1B4bseyEVi/e2OLRcg5qNaF96Z2VD/ylNIoV0
         NerxDFJv9aA6sYltAnBnTFXdBKiReiwIn275zpUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/122] gpio: mpc8xxx: Fix a resources leak in the error handling path of mpc8xxx_probe()
Date:   Mon, 20 Sep 2021 18:44:31 +0200
Message-Id: <20210920163919.032848290@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 555bda42b0c1a5ffb72d3227c043e8afde778f1f ]

Commit 698b8eeaed72 ("gpio/mpc8xxx: change irq handler from chained to normal")
has introduced a new 'goto err;' at the very end of the function, but has
not updated the error handling path accordingly.

Add the now missing 'irq_domain_remove()' call which balances a previous
'irq_domain_create_linear() call.

Fixes: 698b8eeaed72 ("gpio/mpc8xxx: change irq handler from chained to normal")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 3c2fa44d9279..5b2a919a6644 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -406,6 +406,8 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 
 	return 0;
 err:
+	if (mpc8xxx_gc->irq)
+		irq_domain_remove(mpc8xxx_gc->irq);
 	iounmap(mpc8xxx_gc->regs);
 	return ret;
 }
-- 
2.30.2



