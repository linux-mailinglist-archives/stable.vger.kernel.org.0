Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3C64D847A
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiCNMYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243961AbiCNMVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D0913D47;
        Mon, 14 Mar 2022 05:19:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C5BB80DF6;
        Mon, 14 Mar 2022 12:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079C5C340E9;
        Mon, 14 Mar 2022 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260375;
        bh=yMZ/o/Z9AaWrbnYeggMSBdhryGgzxhbFKPYHZNO4BFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OysTmPC+Ug+zusT7EeBgUdlLdkcDrwXYzRQlCV89Tx84ho9pSSunaKYaviu6IYhbV
         bJ4duC7Qw/71u25vxCsLQ7iASpHriOQzldNApRGTf8yhLmjz9PkR3eNuPeBU+mrOd5
         bwdncXKyMlnfvpIcBPv9bP4no6KSDnPfLVSwvusU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Philipson <ross.philipson@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 5.16 114/121] x86/boot: Add setup_indirect support in early_memremap_is_setup_data()
Date:   Mon, 14 Mar 2022 12:54:57 +0100
Message-Id: <20220314112747.289569251@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Philipson <ross.philipson@oracle.com>

commit 445c1470b6ef96440e7cfc42dfc160f5004fd149 upstream.

The x86 boot documentation describes the setup_indirect structures and
how they are used. Only one of the two functions in ioremap.c that needed
to be modified to be aware of the introduction of setup_indirect
functionality was updated. Adds comparable support to the other function
where it was missing.

Fixes: b3c72fc9a78e ("x86/boot: Introduce setup_indirect")
Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1645668456-22036-3-git-send-email-ross.philipson@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/ioremap.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -676,22 +676,51 @@ static bool memremap_is_setup_data(resou
 static bool __init early_memremap_is_setup_data(resource_size_t phys_addr,
 						unsigned long size)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
 	u64 paddr, paddr_next;
 
 	paddr = boot_params.hdr.setup_data;
 	while (paddr) {
-		unsigned int len;
+		unsigned int len, size;
 
 		if (phys_addr == paddr)
 			return true;
 
 		data = early_memremap_decrypted(paddr, sizeof(*data));
+		if (!data) {
+			pr_warn("failed to early memremap setup_data entry\n");
+			return false;
+		}
+
+		size = sizeof(*data);
 
 		paddr_next = data->next;
 		len = data->len;
 
-		early_memunmap(data, sizeof(*data));
+		if ((phys_addr > paddr) && (phys_addr < (paddr + len))) {
+			early_memunmap(data, sizeof(*data));
+			return true;
+		}
+
+		if (data->type == SETUP_INDIRECT) {
+			size += len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap_decrypted(paddr, size);
+			if (!data) {
+				pr_warn("failed to early memremap indirect setup_data\n");
+				return false;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				paddr = indirect->addr;
+				len = indirect->len;
+			}
+		}
+
+		early_memunmap(data, size);
 
 		if ((phys_addr > paddr) && (phys_addr < (paddr + len)))
 			return true;


