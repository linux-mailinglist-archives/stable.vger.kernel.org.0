Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13843608680
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiJVHuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiJVHtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7EF1BB55A;
        Sat, 22 Oct 2022 00:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 519A060B09;
        Sat, 22 Oct 2022 07:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6561AC433D6;
        Sat, 22 Oct 2022 07:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424565;
        bh=e+Vd7JvFc0fcUes11UDUpyQCNraPicOwdsaoFGchMI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPXCAPaIiCP/lWC5vgyydlhydVYeNZZdUUGSP4ERgbLTD5kd43UlH8hZ5q3e8jmB7
         q/ATEQdkLNYwoOEnU1n7sk0w8KuDt5zz5LQdoDGu1oAqr3p7bMVkUeNYo9j/7zbcER
         ZINwJ8GGPh72NdpB6hY9oGuWT2sNbAsrQZNCCWI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huisong Li <lihuisong@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 192/717] ACPI: PCC: Fix Tx acknowledge in the PCC address space handler
Date:   Sat, 22 Oct 2022 09:21:11 +0200
Message-Id: <20221022072449.554503446@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



