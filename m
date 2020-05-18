Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE63D1D85AB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgERSUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbgERRxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9EC6207F5;
        Mon, 18 May 2020 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824388;
        bh=QdbeTQUQUgpsomOMovWEX8b7FzoAXtK92cYw6zKL88M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjLZQfmQh9Ll/CyCT4Lxr/Xx0OnVM2qVcsBtVG+h6iphddD4la0sAMhPkyq1APpfU
         NkJXFzkOF7ABcI4Hr0j0B/GW3vPmFjaTpFkbKruQDAEbdrCxZ4xJyvZ+5vLMS1/mFM
         uBRPVgcdR6gZlgcNUUx5UHxoXg03GKGOaE1VeLck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>
Subject: [PATCH 4.19 73/80] clk: Unlink clock if failed to prepare or enable
Date:   Mon, 18 May 2020 19:37:31 +0200
Message-Id: <20200518173505.193731807@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
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
@@ -3105,6 +3105,9 @@ static int __clk_core_init(struct clk_co
 out:
 	clk_pm_runtime_put(core);
 unlock:
+	if (ret)
+		hlist_del_init(&core->child_node);
+
 	clk_prepare_unlock();
 
 	if (!ret)


