Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0B459DFAE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352407AbiHWKSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354172AbiHWKQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:16:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ECE80488;
        Tue, 23 Aug 2022 02:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AE48B81C3E;
        Tue, 23 Aug 2022 09:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9862C433D6;
        Tue, 23 Aug 2022 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245267;
        bh=caxG/N7lNzYUw+2MPvNor1nmIpLnj2mHmK0+k+JAUL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJFSZPcoOKXcTN9OLBbFCGFLUJ/KCxqzv3VE2ovSsUdwTXhQAJ6FQz9qb/Dt+2dHT
         l/zMhQEUdilNCUqMa3jnRB+7SJBJC7zH6mYsU8Q8OF0Iv6XCV5yyoK1HO7PvfAfwPn
         ZPoiL5Zac7DHXovXXm1dsZJDh38aG+pz36o+M+4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 024/287] bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
Date:   Tue, 23 Aug 2022 10:23:13 +0200
Message-Id: <20220823080101.093989044@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ovidiu Panait <ovidiu.panait@windriver.com>

From: John Fastabend <john.fastabend@gmail.com>

commit 294f2fc6da27620a506e6c050241655459ccd6bd upstream.

Currently, for all op verification we call __red_deduce_bounds() and
__red_bound_offset() but we only call __update_reg_bounds() in bitwise
ops. However, we could benefit from calling __update_reg_bounds() in
BPF_ADD, BPF_SUB, and BPF_MUL cases as well.

For example, a register with state 'R1_w=invP0' when we subtract from
it,

 w1 -= 2

Before coerce we will now have an smin_value=S64_MIN, smax_value=U64_MAX
and unsigned bounds umin_value=0, umax_value=U64_MAX. These will then
be clamped to S32_MIN, U32_MAX values by coerce in the case of alu32 op
as done in above example. However tnum will be a constant because the
ALU op is done on a constant.

Without update_reg_bounds() we have a scenario where tnum is a const
but our unsigned bounds do not reflect this. By calling update_reg_bounds
after coerce to 32bit we further refine the umin_value to U64_MAX in the
alu64 case or U32_MAX in the alu32 case above.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158507151689.15666.566796274289413203.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3496,6 +3496,7 @@ static int adjust_scalar_min_max_vals(st
 		coerce_reg_to_size(dst_reg, 4);
 	}
 
+	__update_reg_bounds(dst_reg);
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 	return 0;


