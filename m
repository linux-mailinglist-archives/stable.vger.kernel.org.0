Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A7F6C1996
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjCTPfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjCTPev (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C232536FE3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D93760C19
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F18DC433D2;
        Mon, 20 Mar 2023 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326049;
        bh=W/PJz5z66yHvD0e16L23WRHM+Ko77EDQFxHzVagYpEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBInJ7Q9Icy4V918sW9btQhepQDdxyLXhiaPoWwZaLqO3RBlO6V8vp57MgsM3Vb8d
         4Q1l0Ijjvr4YUU1Dq8iMQQk4Orl5oQBk9guoiZT9kkheyR4vQu8gYhpxolYlMYnUJa
         6CoFiCYullDjvwpL+Ej7PiYGg8D3sO9JV4REK4Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.1 191/198] virt/coco/sev-guest: Check SEV_SNP attribute at probe time
Date:   Mon, 20 Mar 2023 15:55:29 +0100
Message-Id: <20230320145515.474548348@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov (AMD) <bp@alien8.de>

commit d6fd48eff7506bb866a54e40369df8899f2078a9 upstream.

No need to check it on every ioctl. And yes, this is a common SEV driver
but it does only SNP-specific operations currently. This can be
revisited later, when more use cases appear.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230307192449.24732-3-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c                   |    3 ---
 drivers/virt/coco/sev-guest/sev-guest.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2183,9 +2183,6 @@ int snp_issue_guest_request(u64 exit_cod
 	struct ghcb *ghcb;
 	int ret;
 
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		return -ENODEV;
-
 	if (!fw_err)
 		return -EINVAL;
 
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -705,6 +705,9 @@ static int __init sev_guest_probe(struct
 	void __iomem *mapping;
 	int ret;
 
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return -ENODEV;
+
 	if (!dev->platform_data)
 		return -ENODEV;
 


