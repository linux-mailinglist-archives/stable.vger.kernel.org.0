Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4143B1D82BF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbgERR66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731953AbgERR65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A926D20715;
        Mon, 18 May 2020 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824737;
        bh=pa+G38MI220nHFy8k4su+iNcYpvxDIJDPuNMLH5TxK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6JIzJ5n3d4t973eTRh6GLa7aDvq8UCIe6JMR4eMGjXKQF3Jpye2nBJFu64ObmW4G
         fEHOn9CtddX3NpPHGa6sR39xnPkDLx2Z01ZFp/JQRftp5633pZIqyhZ0pcsnTNofxB
         BXQ/VD/FJeZt6nT+yQHh16F7G0fqJPXTxPIsXwmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>
Subject: [PATCH 5.4 132/147] clk: Unlink clock if failed to prepare or enable
Date:   Mon, 18 May 2020 19:37:35 +0200
Message-Id: <20200518173529.807007387@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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
@@ -3448,6 +3448,9 @@ static int __clk_core_init(struct clk_co
 out:
 	clk_pm_runtime_put(core);
 unlock:
+	if (ret)
+		hlist_del_init(&core->child_node);
+
 	clk_prepare_unlock();
 
 	if (!ret)


