Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02744D82C7
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiCNMHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiCNMG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:06:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD332018A;
        Mon, 14 Mar 2022 05:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27E7FCE1265;
        Mon, 14 Mar 2022 12:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC4DC340E9;
        Mon, 14 Mar 2022 12:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259392;
        bh=KJ76qdj+9s1wslnc9jYS35+T7a9INtf5aJ7Icsm/uo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBDTF68M3p1xT5Lv7GdCbJlI45c4W5qAurJnDRvWKdQSrROJYO+0qHTYVPgGfwUgr
         lL3eYpgMZ98JiWuU4e9XSQocCyBnHl94jvQgc9QuHlmyrLgXYKbTqZ5AJAcyOlFQ4r
         /PAJD2yXPlsTFLwSh1O3TO9jV2BZoYuo8YqsYs2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Philipson <ross.philipson@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 5.10 67/71] x86/boot: Add setup_indirect support in early_memremap_is_setup_data()
Date:   Mon, 14 Mar 2022 12:54:00 +0100
Message-Id: <20220314112739.814638150@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
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
@@ -694,22 +694,51 @@ static bool memremap_is_setup_data(resou
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


