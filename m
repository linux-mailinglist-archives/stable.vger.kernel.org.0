Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C4F4E9507
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbiC1Ljw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242000AbiC1LeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC83E101C;
        Mon, 28 Mar 2022 04:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66BA8611D9;
        Mon, 28 Mar 2022 11:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F97EC34100;
        Mon, 28 Mar 2022 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466703;
        bh=BIDaCQS8ikV182C2h0L5q5M5eU6XgcfUSVMxhfSo8So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5ep32HhDyR8LLY2ch4G4Zwx/uR0DKSJEgxMk6fWnuRqTcSsNDabXVdqxilp1d4jl
         iQoGFdIViETSgz+ofPxy6jWx9i8JkH8bHN+fOj6yxyX6C35ONMWfFGODsd6J/+Mc69
         7XZip5PEDHXN4FVP5Yi+SfxUHzm43dwsijWGGMOv2VzBXGbiLUQKtRNsJGdGwvSEXu
         WGE4l8+b0OItIopgrjOpisIhE07qMySjjTYxAynzXFzasriJOUmBSMMNjIqk4fB1qP
         WuEyN8eTjYUgUNFPtzYawJ3bYvQUbYd9Eg42/n62CXfoptcxMNw5Hh9WTkw2ocfPkN
         qEfZz6Ub9s8ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 4.9 5/8] ACPICA: Avoid walking the ACPI Namespace if it is not there
Date:   Mon, 28 Mar 2022 07:24:53 -0400
Message-Id: <20220328112456.1557226-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112456.1557226-1-sashal@kernel.org>
References: <20220328112456.1557226-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 0c9992315e738e7d6e927ef36839a466b080dba6 ]

ACPICA commit b1c3656ef4950098e530be68d4b589584f06cddc

Prevent acpi_ns_walk_namespace() from crashing when called with
start_node equal to ACPI_ROOT_OBJECT if the Namespace has not been
instantiated yet and acpi_gbl_root_node is NULL.

For instance, this can happen if the kernel is run with "acpi=off"
in the command line.

Link: https://github.com/acpica/acpica/commit/b1c3656ef4950098e530be68d4b589584f06cddc
Link: https://lore.kernel.org/linux-acpi/CAJZ5v0hJWW_vZ3wwajE7xT38aWjY7cZyvqMJpXHzUL98-SiCVQ@mail.gmail.com/
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nswalk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/nswalk.c b/drivers/acpi/acpica/nswalk.c
index ebd731fe8e45..6902c2a01f6f 100644
--- a/drivers/acpi/acpica/nswalk.c
+++ b/drivers/acpi/acpica/nswalk.c
@@ -203,6 +203,9 @@ acpi_ns_walk_namespace(acpi_object_type type,
 
 	if (start_node == ACPI_ROOT_OBJECT) {
 		start_node = acpi_gbl_root_node;
+		if (!start_node) {
+			return_ACPI_STATUS(AE_NO_NAMESPACE);
+		}
 	}
 
 	/* Null child means "get first node" */
-- 
2.34.1

