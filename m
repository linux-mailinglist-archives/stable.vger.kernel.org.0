Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01590541C02
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382506AbiFGVz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382920AbiFGVwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AC023F7F6;
        Tue,  7 Jun 2022 12:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24722B823B1;
        Tue,  7 Jun 2022 19:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AABFC385A5;
        Tue,  7 Jun 2022 19:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629000;
        bh=MUUEaXe42oEIFdsTF9pziCgPfvLKsA9Oo5uJ3FOrQY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrV7EgEi6jACndLdjFSuzYVQeKl7J9/czNtPpdNcnFkOC1HE9kwKsKQwwKVbvfTg1
         ZS4sVm2gOzc9/yc4Pmhym6Er1Rgr43XN0bOiCjr15UyboPBZQuLE+83XjqcmbV0Q/D
         z7/JTUZ6+H6I1S8zTAKnc5Tt1X9Lffj6ZKUc0pcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 532/879] media: lirc: revert removal of unused feature flags
Date:   Tue,  7 Jun 2022 19:00:50 +0200
Message-Id: <20220607165018.315716427@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit e5499dd7253c8382d03f687f19a854adcc688357 ]

Commit b2a90f4fcb14 ("media: lirc: remove unused lirc features") removed
feature flags which were never implemented, but they are still used by
the lirc daemon went built from source.

Reinstate these symbols in order not to break the lirc build.

Fixes: b2a90f4fcb14 ("media: lirc: remove unused lirc features")
Link: https://lore.kernel.org/all/a0470450-ecfd-2918-e04a-7b57c1fd7694@kernel.org/
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/lirc.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 23b0f2c8ba81..8d7ca7c6af42 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -84,6 +84,13 @@
 #define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
 #define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
 
+/*
+ * Unused features. These features were never implemented, in tree or
+ * out of tree. These definitions are here so not to break the lircd build.
+ */
+#define LIRC_CAN_SET_REC_FILTER		0
+#define LIRC_CAN_NOTIFY_DECODE		0
+
 /*** IOCTL commands for lirc driver ***/
 
 #define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
-- 
2.35.1



