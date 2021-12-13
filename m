Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432614724F0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhLMJjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:39:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33556 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhLMJiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:38:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2772ECE0E95;
        Mon, 13 Dec 2021 09:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C874BC341C8;
        Mon, 13 Dec 2021 09:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388291;
        bh=w6F+ty0ZxFSujMTStnXobz0I1cwsN2IrtuDJVFPJQZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofsZrZykbtcSaYfsIE7jlItacjBwPxzkvRxwAnQXjAES7zw0Cue3niyfLgrmsQATa
         JQ2sfWLNjvXPY9vrsydPs+2z60LHOb+imIp0O4ju7P9GtRUOz6BhjjfEkBcRGh2z32
         44JEBmsQemfv4N+a4xUBvdwN1Az7dqgQMGvtiLlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wudi Wang <wangwudi@hisilicon.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.14 52/53] irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL
Date:   Mon, 13 Dec 2021 10:30:31 +0100
Message-Id: <20211213092930.091021199@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wudi Wang <wangwudi@hisilicon.com>

commit b383a42ca523ce54bcbd63f7c8f3cf974abc9b9a upstream.

INVALL CMD specifies that the ITS must ensure any caching associated with
the interrupt collection defined by ICID is consistent with the LPI
configuration tables held in memory for all Redistributors. SYNC is
required to ensure that INVALL is executed.

Currently, LPI configuration data may be inconsistent with that in the
memory within a short period of time after the INVALL command is executed.

Signed-off-by: Wudi Wang <wangwudi@hisilicon.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: cc2d3216f53c ("irqchip: GICv3: ITS command queue")
Link: https://lore.kernel.org/r/20211208015429.5007-1-zhangshaokun@hisilicon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -531,7 +531,7 @@ static struct its_collection *its_build_
 
 	its_fixup_cmd(cmd);
 
-	return NULL;
+	return desc->its_invall_cmd.col;
 }
 
 static struct its_vpe *its_build_vinvall_cmd(struct its_cmd_block *cmd,


