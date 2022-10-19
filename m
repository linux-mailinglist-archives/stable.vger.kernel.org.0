Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFEE6041B8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiJSKrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiJSKqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:46:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C08311A94B;
        Wed, 19 Oct 2022 03:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1C25B822E7;
        Wed, 19 Oct 2022 08:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFB9C433C1;
        Wed, 19 Oct 2022 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169280;
        bh=e+Vd7JvFc0fcUes11UDUpyQCNraPicOwdsaoFGchMI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iF42qtVC6DvH4BKvQfmRFFrA8te46MQxqmBe0VXi4l8guCHruQGa5/gkU3yn1vqkb
         AhK63lvEOC6x14198wvQq415Y3xpKLbZ/WmKgZtAC74EQ0I18A8CHKWm7gIivIm0Ns
         PYF+AeSElwXyg3LNij+MEERasKE3S8k/Pkt4CnRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huisong Li <lihuisong@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 219/862] ACPI: PCC: Fix Tx acknowledge in the PCC address space handler
Date:   Wed, 19 Oct 2022 10:25:06 +0200
Message-Id: <20221019083259.705947570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 18729106c26fb97d4c9ae63ba7aba9889a058dc4 ]

Currently, mbox_client_txdone() is called from the PCC address space
handler and that expects the user the Tx state machine to be controlled
by the client which is not the case and the below warning is thrown:

  | PCCT: Client can't run the TX ticker

Let the controller run the state machine and the end of Tx can be
acknowledge by calling mbox_chan_txdone() instead.

Fixes: 77e2a04745ff ("ACPI: PCC: Implement OperationRegion handler for the PCC Type 3 subtype")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 16ba875e3293..ee4ce5ba1fb2 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -121,7 +121,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 		}
 	}
 
-	mbox_client_txdone(data->pcc_chan->mchan, ret);
+	mbox_chan_txdone(data->pcc_chan->mchan, ret);
 
 	memcpy_fromio(value, data->pcc_comm_addr, data->ctx.length);
 
-- 
2.35.1



