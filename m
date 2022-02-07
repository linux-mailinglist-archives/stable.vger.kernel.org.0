Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0983F4ABD15
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239982AbiBGLok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385061AbiBGLbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ED8C0354AB;
        Mon,  7 Feb 2022 03:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 686D1B811A6;
        Mon,  7 Feb 2022 11:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BADC004E1;
        Mon,  7 Feb 2022 11:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233347;
        bh=f1ORtPDAHpcxACauP0gFG5EboxWBRvFWuxzNa3VLo2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4riBLUO5ZxbwBMIaeO+6onlM2ZWK1ZtMZSE+yYOnwuIW63PStueCngwRIhM8qikb
         q5+tCI/iQtAR/1IlPgaalQFNrByvdukSrZi6HMOBYemCWfdvE63IGVMoEFwU8hvUMm
         IqtuwJU3mUCAcOD5i7HewESv5HOL9KWrYga96Jz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tristan Hume <tristan@thume.ca>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>, stable@kernel.org
Subject: [PATCH 5.15 095/110] perf/x86/intel/pt: Fix crash with stop filters in single-range mode
Date:   Mon,  7 Feb 2022 12:07:08 +0100
Message-Id: <20220207103805.612059303@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tristan Hume <tristan@thume.ca>

commit 1d9093457b243061a9bba23543c38726e864a643 upstream.

Add a check for !buf->single before calling pt_buffer_region_size in a
place where a missing check can cause a kernel crash.

Fixes a bug introduced by commit 670638477aed ("perf/x86/intel/pt:
Opportunistically use single range output mode"), which added a
support for PT single-range output mode. Since that commit if a PT
stop filter range is hit while tracing, the kernel will crash because
of a null pointer dereference in pt_handle_status due to calling
pt_buffer_region_size without a ToPA configured.

The commit which introduced single-range mode guarded almost all uses of
the ToPA buffer variables with checks of the buf->single variable, but
missed the case where tracing was stopped by the PT hardware, which
happens when execution hits a configured stop filter.

Tested that hitting a stop filter while PT recording successfully
records a trace with this patch but crashes without this patch.

Fixes: 670638477aed ("perf/x86/intel/pt: Opportunistically use single range output mode")
Signed-off-by: Tristan Hume <tristan@thume.ca>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/20220127220806.73664-1-tristan@thume.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -897,8 +897,9 @@ static void pt_handle_status(struct pt *
 		 * means we are already losing data; need to let the decoder
 		 * know.
 		 */
-		if (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries) ||
-		    buf->output_off == pt_buffer_region_size(buf)) {
+		if (!buf->single &&
+		    (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries) ||
+		     buf->output_off == pt_buffer_region_size(buf))) {
 			perf_aux_output_flag(&pt->handle,
 			                     PERF_AUX_FLAG_TRUNCATED);
 			advance++;


