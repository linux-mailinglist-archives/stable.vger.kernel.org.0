Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AA25A49BA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiH2L3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiH2L2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:28:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3619072EE6;
        Mon, 29 Aug 2022 04:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E64B80E4C;
        Mon, 29 Aug 2022 11:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0506C433D7;
        Mon, 29 Aug 2022 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771407;
        bh=0RcrxzIq4WhOjo87Hq+HJS6+Nz8mi0V3Oos3YAzgquo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNtY928bXkuK0ZYkAsuk+nRYQNCI2n8a8AKzjjryYsH7dfEzXNuXz2zBnWOYfw9fx
         LiQCzW7rxQ/Kdp1KU/PIC5lGXaXxsixsm4cQXcnbJpn7+RlvVIfKhSR/UgF3ANGlFk
         gdxPt/Z3nxqQmcBl+FeQc2jlKbQgCwsLf9JmkrMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 100/136] perf/x86/lbr: Enable the branch type for the Arch LBR by default
Date:   Mon, 29 Aug 2022 12:59:27 +0200
Message-Id: <20220829105808.788608261@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

commit 32ba156df1b1c8804a4e5be5339616945eafea22 upstream.

On the platform with Arch LBR, the HW raw branch type encoding may leak
to the perf tool when the SAVE_TYPE option is not set.

In the intel_pmu_store_lbr(), the HW raw branch type is stored in
lbr_entries[].type. If the SAVE_TYPE option is set, the
lbr_entries[].type will be converted into the generic PERF_BR_* type
in the intel_pmu_lbr_filter() and exposed to the user tools.
But if the SAVE_TYPE option is NOT set by the user, the current perf
kernel doesn't clear the field. The HW raw branch type leaks.

There are two solutions to fix the issue for the Arch LBR.
One is to clear the field if the SAVE_TYPE option is NOT set.
The other solution is to unconditionally convert the branch type and
expose the generic type to the user tools.

The latter is implemented here, because
- The branch type is valuable information. I don't see a case where
  you would not benefit from the branch type. (Stephane Eranian)
- Not having the branch type DOES NOT save any space in the
  branch record (Stephane Eranian)
- The Arch LBR HW can retrieve the common branch types from the
  LBR_INFO. It doesn't require the high overhead SW disassemble.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220816125612.2042397-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/lbr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1114,6 +1114,14 @@ static int intel_pmu_setup_hw_lbr_filter
 
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR)) {
 		reg->config = mask;
+
+		/*
+		 * The Arch LBR HW can retrieve the common branch types
+		 * from the LBR_INFO. It doesn't require the high overhead
+		 * SW disassemble.
+		 * Enable the branch type by default for the Arch LBR.
+		 */
+		reg->reg |= X86_BR_TYPE_SAVE;
 		return 0;
 	}
 


