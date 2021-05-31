Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1DB39607C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhEaO1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhEaOZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29CC961A1D;
        Mon, 31 May 2021 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468789;
        bh=szfQwQ6TG9bJQID2vn9M14Gfw/Jx1GOvFCQrvjG7zrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+/U3heVf/r56z3tltmqu/UA2cSB7OzKpi9zdavi4Pi4CbB8HKIUDw4tYmtCmBZ5/
         csL+JC7LFVDWAAFZtluiB2h5h/zJzLGb13BtzV8sY0XGzvRLRLxnjATcYo4sxHZmIW
         UsY7SWLkJilS7KJNhgOJFHCSvTocXW0SpWszusGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 084/177] i2c: sh_mobile: Use new clock calculation formulas for RZ/G2E
Date:   Mon, 31 May 2021 15:14:01 +0200
Message-Id: <20210531130650.806796465@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c4740e293c93c747e65d53d9aacc2ba8521d1489 upstream.

When switching the Gen3 SoCs to the new clock calculation formulas, the
match entry for RZ/G2E added in commit 51243b73455f2d12 ("i2c:
sh_mobile: Add support for r8a774c0 (RZ/G2E)") was forgotten.

Fixes: e8a27567509b2439 ("i2c: sh_mobile: use new clock calculation formulas for Gen3")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-sh_mobile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -813,7 +813,7 @@ static const struct sh_mobile_dt_config
 static const struct of_device_id sh_mobile_i2c_dt_ids[] = {
 	{ .compatible = "renesas,iic-r8a73a4", .data = &fast_clock_dt_config },
 	{ .compatible = "renesas,iic-r8a7740", .data = &r8a7740_dt_config },
-	{ .compatible = "renesas,iic-r8a774c0", .data = &fast_clock_dt_config },
+	{ .compatible = "renesas,iic-r8a774c0", .data = &v2_freq_calc_dt_config },
 	{ .compatible = "renesas,iic-r8a7790", .data = &v2_freq_calc_dt_config },
 	{ .compatible = "renesas,iic-r8a7791", .data = &v2_freq_calc_dt_config },
 	{ .compatible = "renesas,iic-r8a7792", .data = &v2_freq_calc_dt_config },


