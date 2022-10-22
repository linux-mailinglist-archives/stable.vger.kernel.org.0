Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11707608BF0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJVKuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJVKuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:50:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0039F10041D;
        Sat, 22 Oct 2022 03:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEE85B82DE2;
        Sat, 22 Oct 2022 07:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56577C433D6;
        Sat, 22 Oct 2022 07:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424557;
        bh=njhw0LwRXIffYEP5C+Wa5eEtx0qNIV98IVTRB8jz/4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIS7pPwbSIna8eki4KRjbhI5p4TrC8LX4ZKI4LIu5OmYHz1WlV6ltT8/vjiFIkDWQ
         GL4MoGGi6eDZTfAiKh4ovISDz/lmN8xIpdqvOLtRIoUabSE0ILqUr55D+YbYuJMXXg
         LoeHndGkFnJ1tb15hRqur9uAP60CaG/MMt2f1a6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 190/717] ACPI: PCC: Release resources on address space setup failure path
Date:   Sat, 22 Oct 2022 09:21:09 +0200
Message-Id: <20221022072449.227831824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
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



