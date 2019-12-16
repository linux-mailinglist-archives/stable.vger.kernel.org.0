Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFC1216BB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfLPSbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbfLPSLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E202072D;
        Mon, 16 Dec 2019 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519901;
        bh=HacWDGMaqW5A2Weut8VIS+309yFPzbKi/eyzlpxs6sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVYPOPTbYJgqhfOB2lUQ6rN2X70vvFrE80E0/Xn4yRKj4lEvKTBDbZ7snDhxSs5Ic
         igUGzT1ggvFf1amvcekLXIAjoAm3uch3rZxDXuuG7WnoCnX+5FezunLqK956M9VdKs
         Q5AcB1z+cY+hh3+lWF+RYag+EWRi6vHB4OWuKRac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.3 113/180] pinctrl: samsung: Add of_node_put() before return in error path
Date:   Mon, 16 Dec 2019 18:49:13 +0100
Message-Id: <20191216174839.132768457@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>

commit 3d2557ab75d4c568c79eefa2e550e0d80348a6bd upstream.

Each iteration of for_each_child_of_node puts the previous node, but in
the case of a return from the middle of the loop, there is no put, thus
causing a memory leak. Hence add an of_node_put before the return of
exynos_eint_wkup_init() error path.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Fixes: 14c255d35b25 ("pinctrl: exynos: Add irq_chip instance for Exynos7 wakeup interrupts")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-exynos.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -486,8 +486,10 @@ int exynos_eint_wkup_init(struct samsung
 		if (match) {
 			irq_chip = kmemdup(match->data,
 				sizeof(*irq_chip), GFP_KERNEL);
-			if (!irq_chip)
+			if (!irq_chip) {
+				of_node_put(np);
 				return -ENOMEM;
+			}
 			wkup_np = np;
 			break;
 		}


