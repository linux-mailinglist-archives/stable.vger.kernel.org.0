Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708756C1884
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjCTPZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjCTPYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:24:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75CB31E1A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D912161582
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DBDC433EF;
        Mon, 20 Mar 2023 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325463;
        bh=xIzhPFcVShWQTkBc4XoUjnwew0fc/NhxrqBb4ZXy1O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvt5MFvw0klrEhfRIPap9eJ9tswXR/kNI3B5lhf6T75/0OBOsTdvxmXNxTrvOUAFt
         +ZSz0XfwmARYIM28xZMZmdLjEhKUQbUfWvjBdFi+V51WRSxlP/buCd2W7pv3E5NwvK
         Bl5fDUKRDzwCN1D0oF3esQ5rVvmDUlRbXib3v82w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, stable@kernel.org
Subject: [PATCH 5.15 107/115] x86/mm: Fix use of uninitialized buffer in sme_enable()
Date:   Mon, 20 Mar 2023 15:55:19 +0100
Message-Id: <20230320145453.928706800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit cbebd68f59f03633469f3ecf9bea99cd6cce3854 upstream.

cmdline_find_option() may fail before doing any initialization of
the buffer array. This may lead to unpredictable results when the same
buffer is used later in calls to strncmp() function.  Fix the issue by
returning early if cmdline_find_option() returns an error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: aca20d546214 ("x86/mm: Add support to make use of Secure Memory Encryption")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230306160656.14844-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/mem_encrypt_identity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -585,7 +585,8 @@ void __init sme_enable(struct boot_param
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer));
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
+		return;
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;


