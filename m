Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E5E1D83AC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbgERSGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733213AbgERSGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14F7420671;
        Mon, 18 May 2020 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825204;
        bh=0nWpkoZTFnZDxmQRiTmW17jXBn2XQVwmaW26jKfT8Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=At/QbhYqvXAuv5kplCt66WatnzLVUkk8x5SelSJAsF+boCwaDEY/N7QhtvpzJKHXD
         6a/t5HanlfXVvI8Ml4HJJbHpoNABwmtUkMaTnEHYZl+fGg7tet8nb3ighkNKiF0Esh
         KF9WqFLdvWJ1iH4ALYRQ50VeQqqyTM205MElihso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>
Subject: [PATCH 5.6 172/194] clk: Unlink clock if failed to prepare or enable
Date:   Mon, 18 May 2020 19:37:42 +0200
Message-Id: <20200518173546.018721426@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 018d4671b9bbd4a5c55cf6eab3e1dbc70a50b66e upstream.

On failing to prepare or enable a clock, remove the core structure
from the list it has been inserted as it is about to be freed.

This otherwise leads to random crashes when subsequent clocks get
registered, during which parsing of the clock tree becomes adventurous.

Observed with QEMU's RPi-3 emulation.

Fixes: 12ead77432f2 ("clk: Don't try to enable critical clocks if prepare failed")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Link: https://lkml.kernel.org/r/20200505140953.409430-1-maz@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3512,6 +3512,9 @@ static int __clk_core_init(struct clk_co
 out:
 	clk_pm_runtime_put(core);
 unlock:
+	if (ret)
+		hlist_del_init(&core->child_node);
+
 	clk_prepare_unlock();
 
 	if (!ret)


