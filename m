Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822951673C6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733308AbgBUIPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733038AbgBUIPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBD32467B;
        Fri, 21 Feb 2020 08:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272923;
        bh=8oWWFICifQz6wo/aYwrUzW2cWKlMoWhyaLIk7Z/s6FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tj09y110/+TBoUFUN+M4nropZvyC2sme1UNJvh1TXh8pm2TxkLS2IA73afQOvzx6+
         DxKsvtFbDmLWUe9yyu2P/+pZuSbkOfId8OSafIySmwypfxlirKGoSEwZQ9H062qkXB
         FTogzzWXVz/pysnZMCDj1bZQ0To5W5tXAuO29I3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 325/344] irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when building INVALL
Date:   Fri, 21 Feb 2020 08:42:04 +0100
Message-Id: <20200221072419.738798013@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 107945227ac5d4c37911c7841b27c64b489ce9a9 ]

It looks like an obvious mistake to use its_mapc_cmd descriptor when
building the INVALL command block. It so far worked by luck because
both its_mapc_cmd.col and its_invall_cmd.col sit at the same offset of
the ITS command descriptor, but we should not rely on it.

Fixes: cc2d3216f53c ("irqchip: GICv3: ITS command queue")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20191202071021.1251-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 787e8eec9a7f1..11f3b50dcdcb8 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -571,7 +571,7 @@ static struct its_collection *its_build_invall_cmd(struct its_node *its,
 						   struct its_cmd_desc *desc)
 {
 	its_encode_cmd(cmd, GITS_CMD_INVALL);
-	its_encode_collection(cmd, desc->its_mapc_cmd.col->col_id);
+	its_encode_collection(cmd, desc->its_invall_cmd.col->col_id);
 
 	its_fixup_cmd(cmd);
 
-- 
2.20.1



