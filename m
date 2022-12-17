Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D8164FA3A
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLQP2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiLQP1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:27:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFD915F0C;
        Sat, 17 Dec 2022 07:27:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C326E60C20;
        Sat, 17 Dec 2022 15:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75650C433F0;
        Sat, 17 Dec 2022 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290861;
        bh=ZkxL9EC5gdiSeuBMoXXn7hPEESSX2sCMYeJ2MoXdUBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf6c9JnBxtwHDqJhL5Yu+jJXJFx0yIDt8kEVGgYhZ6UahTVH4AbVsv34WhNvPTTRJ
         /LGL8xAS/SgNE4fUqHXbNCE1QBfrUVMYSBimsZcDv6yI66gzYZvog1swkJYAkiQ0en
         r5huC4ODvU3pNBQsg3dn07yG6QYx5YcDqUUaF0OnD37rHizVlDwQuEICfGLJ7ianRR
         zqxMUyE9S4iKLbr92qjQcP2f8/04LkN/BnmROJmyVgWp5PwQ6W0R5DvusJfoV9twQQ
         DrpgGiM70B3y+pPQBGWl55nw2wZudIBhf3gVFX4GXAC398SDoEIBvUgBt1IcrvmSiP
         7Eg8pVTbejl6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhong <floridsleeves@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 05/22] ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
Date:   Sat, 17 Dec 2022 10:27:06 -0500
Message-Id: <20221217152727.98061-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
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
index acfabfe07c4f..fc5b5b2c9e81 100644
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

