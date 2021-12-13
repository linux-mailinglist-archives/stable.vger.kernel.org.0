Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99A4472424
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhLMJeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbhLMJdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:33:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01A8C0698CE;
        Mon, 13 Dec 2021 01:33:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBE24B80E17;
        Mon, 13 Dec 2021 09:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E660C341C5;
        Mon, 13 Dec 2021 09:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388032;
        bh=wkxb4IER6WP7MxNqEpaJIXsI5XtSIHnRc7ei7EB40G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nsu69mZQwUHuiR8li92g0D105HH76w3oTGPTyd1cEXZYw7+pBUwVpVlMauIwpMZ/o
         G4ghnPjOP+xyqn6+Sywv88IZ5QylQB2APBnYa8PrKs9EgYvs59H2ratUjS5rOndvVN
         wrPBEHkdm5W9WXyewD0nynWiFiGsxmYyxbDsa2aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wudi Wang <wangwudi@hisilicon.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.4 36/37] irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL
Date:   Mon, 13 Dec 2021 10:30:14 +0100
Message-Id: <20211213092926.560909720@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
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
@@ -356,7 +356,7 @@ static struct its_collection *its_build_
 
 	its_fixup_cmd(cmd);
 
-	return NULL;
+	return desc->its_invall_cmd.col;
 }
 
 static u64 its_cmd_ptr_to_offset(struct its_node *its,


