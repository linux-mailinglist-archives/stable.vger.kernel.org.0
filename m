Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9D744131
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733086AbfFMQLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfFMInT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:43:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ED9F20851;
        Thu, 13 Jun 2019 08:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415398;
        bh=9tJ+brvphG5FqZPXRCL6Jx/bGVwLJgT8YJU7aFRnTVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jM3gDyvVzdXW0ylSwh8wOagnSQjQb+HPDMzM/05vLLF1omIAyn0kcmjc65f+TbW5n
         kc5pUNtTqNFFoXe4Jitx2cKKj4mitnslnJbdTWe307uK8d1OugCcFh3FKlmU5gWRMc
         v4heU+KD8r2AKCVELTZGSqgX55a0Tr4Qxs0UVPIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/118] soc: renesas: Identify R-Car M3-W ES1.3
Date:   Thu, 13 Jun 2019 10:34:09 +0200
Message-Id: <20190613075650.703857246@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
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
index d44d0e687ab8..2a43d6e99962 100644
--- a/drivers/soc/renesas/renesas-soc.c
+++ b/drivers/soc/renesas/renesas-soc.c
@@ -285,6 +285,9 @@ static int __init renesas_soc_init(void)
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



