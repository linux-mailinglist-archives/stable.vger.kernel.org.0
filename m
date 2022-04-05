Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13AF4F31BA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbiDEKHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344270AbiDEJTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972B22528;
        Tue,  5 Apr 2022 02:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18A7A614E4;
        Tue,  5 Apr 2022 09:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2194AC385A0;
        Tue,  5 Apr 2022 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149602;
        bh=0koZQSOLgRW2kaRazCNUDwDk9THdGrokMdcTAp4Ow68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgxgDKDORwuAkQtHyFBYhn638HBorMGuPeFuWtcVYtMHCxCR706hfMfJ39UYrer46
         iyFBen7oeaWlpmRW5nZ+S7LmVz5pTQ/fVkFn8ajjstJDNq0NVfCf4M744NDbqUVCZ0
         7CHijFQc3qiBLzOWMH2Q2T6p6h3TUVsydKlrhHlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0774/1017] ACPICA: Avoid walking the ACPI Namespace if it is not there
Date:   Tue,  5 Apr 2022 09:28:07 +0200
Message-Id: <20220405070417.234521252@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index 915c2433463d..e7c30ce06e18 100644
--- a/drivers/acpi/acpica/nswalk.c
+++ b/drivers/acpi/acpica/nswalk.c
@@ -169,6 +169,9 @@ acpi_ns_walk_namespace(acpi_object_type type,
 
 	if (start_node == ACPI_ROOT_OBJECT) {
 		start_node = acpi_gbl_root_node;
+		if (!start_node) {
+			return_ACPI_STATUS(AE_NO_NAMESPACE);
+		}
 	}
 
 	/* Null child means "get first node" */
-- 
2.34.1



