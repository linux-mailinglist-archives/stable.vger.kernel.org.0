Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD3E64FA11
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiLQPbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiLQPa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:30:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299E215F3A;
        Sat, 17 Dec 2022 07:28:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D5060C14;
        Sat, 17 Dec 2022 15:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AAAC43398;
        Sat, 17 Dec 2022 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290913;
        bh=scuxibib/wgWJbiVOJ780gC72KxWU3lhTW97mM5HxNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sP2rN0jq5z/Tdsw1IWhf3YHsOoX1c9dbOYVbZ5IZ0iF4n+cdOtS9PNbP39OLWGJzQ
         yxqsbE+ctwAiaYnDHSHXyp52UtdvpW60o78pwTNoh+RVEpLCIFbmVq5Aj1UXmg0t8+
         /+zeJ8nU7UENoLTcvCLrdsURA7+28xeIS/OH6LsD1WmJNgIKhrTYtLnngp8MH0NJcb
         GknDdQ9ii8SLiCw1760Ioctu6z+fKUKdrYRAIeipPlalQhUHP4+JTQnbcWL3sWXoyX
         2bBe2qahX3kf2aF2mfTJbNAoEnnf/8ntWJkGTeiMJt4fjorY/HH0+qSDBr4M2JDkyQ
         y/tJXNFGjPS3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhong <floridsleeves@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 05/16] ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
Date:   Sat, 17 Dec 2022 10:28:08 -0500
Message-Id: <20221217152821.98618-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152821.98618-1-sashal@kernel.org>
References: <20221217152821.98618-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhong <floridsleeves@gmail.com>

[ Upstream commit 2437513a814b3e93bd02879740a8a06e52e2cf7d ]

The return value of acpi_fetch_acpi_dev() could be NULL, which would
cause a NULL pointer dereference to occur in acpi_device_hid().

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
[ rjw: Subject and changelog edits, added empty line after if () ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 9f40917c49ef..4d1dd255c122 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1134,6 +1134,9 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	status = acpi_get_parent(handle, &pr_ahandle);
 	while (ACPI_SUCCESS(status)) {
 		d = acpi_fetch_acpi_dev(pr_ahandle);
+		if (!d)
+			break;
+
 		handle = pr_ahandle;
 
 		if (strcmp(acpi_device_hid(d), ACPI_PROCESSOR_CONTAINER_HID))
-- 
2.35.1

