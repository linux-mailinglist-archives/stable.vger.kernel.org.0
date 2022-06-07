Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5E1537DB9
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiE3Nld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiE3NkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:40:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C2312;
        Mon, 30 May 2022 06:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3225760F38;
        Mon, 30 May 2022 13:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5347C385B8;
        Mon, 30 May 2022 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917491;
        bh=jAuNF6M+3PV9HonytzGTV1kYObV5ikBT2owp1pOQg1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WP++i7pt4OSU5WVvZmSIcwmke03bwa+ElZfq5iBkvXTrTILWoYZ4LB03q5EWGG8I+
         mt7d9fslyZ1rI9k2/g4Zv6RJTaVLe78hNgf1FpfINEbYjedjBaRuSTaDuSrbiRqi+H
         72IZVAX78D31a07XlfcnsZ4sxph26+178hiv791+gEwsUWdeAJTE5wI1qKeJoupnNb
         dQr1ZIRqc42fVgvdD10PzrQFSogrmsvwwoLHK86++pxn+f9ArRvsYQnBMv3p6wXR5N
         gGOImlaiQw48Im1yhZIPo7t0OGWvXTEpov7IOHpIRXQ54KGBrJclVbxhLetmopMY9K
         Uo5bPzcbuJKGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        akpm@linux-foundation.org
Subject: [PATCH AUTOSEL 5.18 159/159] linux/types.h: reinstate "__bitwise__" macro for user space use
Date:   Mon, 30 May 2022 09:24:24 -0400
Message-Id: <20220530132425.1929512-159-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit caa28984163cb63ea0be4cb8dbf05defdc7303f9 ]

Commit c724c866bb70 ("linux/types.h: remove unnecessary __bitwise__")
was right that there are no users of __bitwise__ in the kernel, but it
turns out there are user space users of it that do expect it.

It is, after all, in the uapi directory, so user space usage is to be
expected.

Instead of reverting the commit completely, let's just clarify the
situation so that it doesn't happen again, and have some in-code
explanations for why that "__bitwise__" still exists.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Link: https://lore.kernel.org/all/b5c0a68d-8387-4909-beea-f70ab9e6e3d5@kernel.org/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/types.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index c4dc597f3dcf..308433be33c2 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -26,6 +26,9 @@
 #define __bitwise
 #endif
 
+/* The kernel doesn't use this legacy form, but user space does */
+#define __bitwise__ __bitwise
+
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
 typedef __u32 __bitwise __le32;
-- 
2.35.1

