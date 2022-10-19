Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C129603CC7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiJSIwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiJSIua (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CACB488;
        Wed, 19 Oct 2022 01:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0720C6182F;
        Wed, 19 Oct 2022 08:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F106C433D7;
        Wed, 19 Oct 2022 08:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169274;
        bh=njhw0LwRXIffYEP5C+Wa5eEtx0qNIV98IVTRB8jz/4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbqncfVIFbAi+LRSvqTDi/eC6dfAfK/fspn+hiEH54uRov+ymzxM3Pf/SlPCd3Awk
         z9nd9WqiQZ/NSfJrgwUhcoqUleNFKD/F8lcQYfX8eLZ0yfj2myH6Gv+olKmZEkltqc
         ZjW3dPCOoHJqyQ4OYIuI0DitdlXtD8fJgys3lF48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 217/862] ACPI: PCC: Release resources on address space setup failure path
Date:   Wed, 19 Oct 2022 10:25:04 +0200
Message-Id: <20221019083259.624066766@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit f890157e61b85ce8ae01a41ffa375e3b99853698 ]

The allocated memory for the pcc_data struct doesn't get freed under an
error path in pcc_mbox_request_channel() or acpi_os_ioremap(). Also, the
PCC mailbox channel doesn't get freed under an error path in
acpi_os_ioremap().

Fixes: 77e2a04745ff8 ("ACPI: PCC: Implement OperationRegion handler for the PCC Type 3 subtype")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index a12b55d81209..84f1ac416b57 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -63,6 +63,7 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 	if (IS_ERR(data->pcc_chan)) {
 		pr_err("Failed to find PCC channel for subspace %d\n",
 		       ctx->subspace_id);
+		kfree(data);
 		return AE_NOT_FOUND;
 	}
 
@@ -72,6 +73,8 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 	if (!data->pcc_comm_addr) {
 		pr_err("Failed to ioremap PCC comm region mem for %d\n",
 		       ctx->subspace_id);
+		pcc_mbox_free_channel(data->pcc_chan);
+		kfree(data);
 		return AE_NO_MEMORY;
 	}
 
-- 
2.35.1



