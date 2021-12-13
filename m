Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C22472A15
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239140AbhLMKaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240257AbhLMK2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:28:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F3DC01DF34;
        Mon, 13 Dec 2021 02:02:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 808F8CE0F6A;
        Mon, 13 Dec 2021 10:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374DAC34601;
        Mon, 13 Dec 2021 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389730;
        bh=oQj3SUKigFeUAZUTdmV3Gl6iVyTKg7mJ40nGDz3Ji1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKGHdbNXw6BELwda3rUVrEUiatC+4Vjw3vgX7dKgYjJ+LUqY8miP6GOf9DmRvYE8L
         zNqf2A8/fAPqwYsvyPsDSBWSVsmoqN/22RFTdecu7vgnuU8ModX0LLt9IFGMAI3V72
         yAKihkk3XtdABoQSIoyZ4pmk5BraU6i4CvDJ0Kzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wudi Wang <wangwudi@hisilicon.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 167/171] irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL
Date:   Mon, 13 Dec 2021 10:31:22 +0100
Message-Id: <20211213092950.627131681@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -742,7 +742,7 @@ static struct its_collection *its_build_
 
 	its_fixup_cmd(cmd);
 
-	return NULL;
+	return desc->its_invall_cmd.col;
 }
 
 static struct its_vpe *its_build_vinvall_cmd(struct its_node *its,


