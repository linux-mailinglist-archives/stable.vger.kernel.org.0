Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D6043F3C
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFMPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbfFMIvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBBB421743;
        Thu, 13 Jun 2019 08:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415903;
        bh=4rzwWjMWaDAodybALEky2I9+FJ7Gp9NqTbx/hvV9UUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0KGmjdHu134zB6yJILgsoe+0pyUZHcoCC8imVzBl2hM/7Vll91HMQhciT7TntEEs
         kP3HU2hPMw/y6gbh0V2q9CQb37+PWjkw51y16ToKKFhr9cSbFTHpMhZftWFwASi6z9
         n+1TfOMeMg+7ayCBpMkwA0TdWyOPurB/cdXWQcHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 148/155] soc: renesas: Identify R-Car M3-W ES1.3
Date:   Thu, 13 Jun 2019 10:34:20 +0200
Message-Id: <20190613075701.179730093@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 15160f6de0bba712fcea078c5ac7571fe33fcd5d ]

The Product Register of R-Car M3-W ES1.3 incorrectly identifies the SoC
revision as ES2.1. Add a workaround to fix this.

Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/renesas-soc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/renesas/renesas-soc.c b/drivers/soc/renesas/renesas-soc.c
index 4af96e668a2f..3299cf5365f3 100644
--- a/drivers/soc/renesas/renesas-soc.c
+++ b/drivers/soc/renesas/renesas-soc.c
@@ -335,6 +335,9 @@ static int __init renesas_soc_init(void)
 		/* R-Car M3-W ES1.1 incorrectly identifies as ES2.0 */
 		if ((product & 0x7fff) == 0x5210)
 			product ^= 0x11;
+		/* R-Car M3-W ES1.3 incorrectly identifies as ES2.1 */
+		if ((product & 0x7fff) == 0x5211)
+			product ^= 0x12;
 		if (soc->id && ((product >> 8) & 0xff) != soc->id) {
 			pr_warn("SoC mismatch (product = 0x%x)\n", product);
 			return -ENODEV;
-- 
2.20.1



