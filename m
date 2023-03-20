Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524856C18D0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjCTP1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjCTP1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018A336FF6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4933B6158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F43C433D2;
        Mon, 20 Mar 2023 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325627;
        bh=AY/Ig6/D6B8kAit4w8uSAEvPz3sYAX7+kRJBXfUowsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJuPtsha97xyZZDiB+cLpGh3bS6Y7g3SEgnKQAL5bCL7DmE3d1aHcfTsWxqKEX58x
         tCS0UiCeCVMb2rpeK7d/LqziymSGfKaAKcSyW93sU0m0piLVPyfmWC3pmVK9sp5N9r
         +JOUcv9pVSVEjQuMlzrxrXzg2Svs7T4j+m1lugFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 6.1 113/198] sh: intc: Avoid spurious sizeof-pointer-div warning
Date:   Mon, 20 Mar 2023 15:54:11 +0100
Message-Id: <20230320145512.305140220@linuxfoundation.org>
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

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 250870824c1cf199b032b1ef889c8e8d69d9123a ]

GCC warns about the pattern sizeof(void*)/sizeof(void), as it looks like
the abuse of a pattern to calculate the array size. This pattern appears
in the unevaluated part of the ternary operator in _INTC_ARRAY if the
parameter is NULL.

The replacement uses an alternate approach to return 0 in case of NULL
which does not generate the pattern sizeof(void*)/sizeof(void), but still
emits the warning if _INTC_ARRAY is called with a nonarray parameter.

This patch is required for successful compilation with -Werror enabled.

The idea to use _Generic for type distinction is taken from Comment #7
in https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108483 by Jakub Jelinek

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://lore.kernel.org/r/619fa552-c988-35e5-b1d7-fe256c46a272@mkarcher.dialup.fu-berlin.de
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sh_intc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/sh_intc.h b/include/linux/sh_intc.h
index c255273b02810..37ad81058d6ae 100644
--- a/include/linux/sh_intc.h
+++ b/include/linux/sh_intc.h
@@ -97,7 +97,10 @@ struct intc_hw_desc {
 	unsigned int nr_subgroups;
 };
 
-#define _INTC_ARRAY(a) a, __same_type(a, NULL) ? 0 : sizeof(a)/sizeof(*a)
+#define _INTC_SIZEOF_OR_ZERO(a) (_Generic(a,                 \
+                                 typeof(NULL):  0,           \
+                                 default:       sizeof(a)))
+#define _INTC_ARRAY(a) a, _INTC_SIZEOF_OR_ZERO(a)/sizeof(*a)
 
 #define INTC_HW_DESC(vectors, groups, mask_regs,	\
 		     prio_regs,	sense_regs, ack_regs)	\
-- 
2.39.2



