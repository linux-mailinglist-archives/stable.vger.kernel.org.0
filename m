Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1807B541999
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378017AbiFGVX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380307AbiFGVQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D11157E8E;
        Tue,  7 Jun 2022 11:55:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9AC77CE1D50;
        Tue,  7 Jun 2022 18:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83456C385A2;
        Tue,  7 Jun 2022 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628096;
        bh=jAuNF6M+3PV9HonytzGTV1kYObV5ikBT2owp1pOQg1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEFjN7f2Lk9jTr5hQpBd/m3Qnjo5B6WsdGlhNosW9Vp+rePVmsBtN/hH6HOpklIpg
         MVViYT/kgpGEt68Xw4FSCzpNHATWoZHoABXospJZSzZwa/lxjSc6grJI1Tdx8TFtcF
         uM6sI0OIYH3bjVFc8LLPQd8KUim3vlf3ChNMacXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 206/879] linux/types.h: reinstate "__bitwise__" macro for user space use
Date:   Tue,  7 Jun 2022 18:55:24 +0200
Message-Id: <20220607165008.829694453@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



