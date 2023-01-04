Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B43B65D871
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbjADQOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbjADQO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:14:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037893FA31
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FEE1617A7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8163BC433EF;
        Wed,  4 Jan 2023 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848840;
        bh=/SGjc/bqFrhn/0ujg6yy2wv+klspnHA1uquejMVB/zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuwqvQLqlyvaXuvebntftqObpZfXru15s2v4r6WYJqRC75h93Fgx5aXk0Kcn7RPMO
         4XHKiqrDiyJq9MF6ena3el5LeLkZ0XlYJHqG2x0nol1wOo8rBIF4KDceeAsryUxafT
         jHgmgbFa9GQb8vaeg05q5cMfRbdcDCkfA6IGFcfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.0 023/177] x86/fpu/xstate: Fix XSTATE_WARN_ON() to emit relevant diagnostics
Date:   Wed,  4 Jan 2023 17:05:14 +0100
Message-Id: <20230104160508.365931371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 48280042f2c6e3ac2cfb1d8b752ab4a7e0baea24 upstream.

"XSAVE consistency problem" has been reported under Xen, but that's the extent
of my divination skills.

Modify XSTATE_WARN_ON() to force the caller to provide relevant diagnostic
information, and modify each caller suitably.

For check_xstate_against_struct(), this removes a double WARN() where one will
do perfectly fine.

CC stable as this has been wonky debugging for 7 years and it is good to
have there too.

Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220810221909.12768-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -440,8 +440,8 @@ static void __init __xstate_dump_leaves(
 	}
 }
 
-#define XSTATE_WARN_ON(x) do {							\
-	if (WARN_ONCE(x, "XSAVE consistency problem, dumping leaves")) {	\
+#define XSTATE_WARN_ON(x, fmt, ...) do {					\
+	if (WARN_ONCE(x, "XSAVE consistency problem: " fmt, ##__VA_ARGS__)) {	\
 		__xstate_dump_leaves();						\
 	}									\
 } while (0)
@@ -554,8 +554,7 @@ static bool __init check_xstate_against_
 	    (nr >= XFEATURE_MAX) ||
 	    (nr == XFEATURE_PT_UNIMPLEMENTED_SO_FAR) ||
 	    ((nr >= XFEATURE_RSRVD_COMP_11) && (nr <= XFEATURE_RSRVD_COMP_16))) {
-		WARN_ONCE(1, "no structure for xstate: %d\n", nr);
-		XSTATE_WARN_ON(1);
+		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
 		return false;
 	}
 	return true;
@@ -598,12 +597,13 @@ static bool __init paranoid_xstate_size_
 		 * XSAVES.
 		 */
 		if (!xsaves && xfeature_is_supervisor(i)) {
-			XSTATE_WARN_ON(1);
+			XSTATE_WARN_ON(1, "Got supervisor feature %d, but XSAVES not advertised\n", i);
 			return false;
 		}
 	}
 	size = xstate_calculate_size(fpu_kernel_cfg.max_features, compacted);
-	XSTATE_WARN_ON(size != kernel_size);
+	XSTATE_WARN_ON(size != kernel_size,
+		       "size %u != kernel_size %u\n", size, kernel_size);
 	return size == kernel_size;
 }
 


