Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1EF627F89
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbiKNNAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237638AbiKNNAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B527FD1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C4B9B80EC0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7150EC433D6;
        Mon, 14 Nov 2022 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430818;
        bh=QzDoCeRUTCwNPJcyLxwgsBADC45GJK/Z22LEz49Wp6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cILkgi2zvCnasaFVGBjH/boSCuUDPIxRC5BdD+LREOCQ9JKsbnmpnRNN//YlusfXJ
         b8awqbdDwP8Y5B3hKbwX3ik6r7oKtdLv6LwdAwx8nyjUb/Acl+WbYpLysfiaz8Zk8I
         ZRGNTdASGcB9RZw8RgfTbfnyruY5U8Oq7xLDhMJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anders Roxell <anders.roxell@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 129/131] marvell: octeontx2: build error: unknown type name u64
Date:   Mon, 14 Nov 2022 13:46:38 +0100
Message-Id: <20221114124454.157191211@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Anders Roxell <anders.roxell@linaro.org>

commit 6312d52838b21f5c4a5afa1269a00df4364fd354 upstream.

Building an allmodconfig kernel arm64 kernel, the following build error
shows up:

In file included from drivers/crypto/marvell/octeontx2/cn10k_cpt.c:4:
include/linux/soc/marvell/octeontx2/asm.h:38:15: error: unknown type name 'u64'
   38 | static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
      |               ^~~

Include linux/types.h in asm.h so the compiler knows what the type
'u64' are.

Fixes: af3826db74d1 ("octeontx2-pf: Use hardware register for CQE count")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/r/20211013135743.3826594-1-anders.roxell@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/soc/marvell/octeontx2/asm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -5,6 +5,7 @@
 #ifndef __SOC_OTX2_ASM_H
 #define __SOC_OTX2_ASM_H
 
+#include <linux/types.h>
 #if defined(CONFIG_ARM64)
 /*
  * otx2_lmt_flush is used for LMT store operation.


