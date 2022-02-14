Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4190E4B4B25
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbiBNKVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:21:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346674AbiBNKUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:20:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD45490260;
        Mon, 14 Feb 2022 01:55:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31BC4B80DBF;
        Mon, 14 Feb 2022 09:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5F3C340E9;
        Mon, 14 Feb 2022 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832504;
        bh=PKFm0sE3iMB94aMb4kUoSynBy19rolL5hhSmfs8lpww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDjqzjivdrZt/JYoklXM7mllmvVDUjbNsI4g3uJp+rTV9mtKfsY6NQo7A7VnH9kUn
         OBI9ChLr/dziXmCFNZwcEEJva/0JztBkvMFUyBl6MvQLYcutRoIsw+pH+ql5nSwMpI
         ZIJaTi/kD2eX66ZHhjWI1Lh+NM3wPUBP1FKRqgXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 034/203] x86/perf: Avoid warning for Arch LBR without XSAVE
Date:   Mon, 14 Feb 2022 10:24:38 +0100
Message-Id: <20220214092511.361960856@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 8c16dc047b5dd8f7b3bf4584fa75733ea0dde7dc ]

Some hypervisors support Arch LBR, but without the LBR XSAVE support.
The current Arch LBR init code prints a warning when the xsave size (0) is
unexpected. Avoid printing the warning for the "no LBR XSAVE" case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211215204029.150686-1-ak@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 8043213b75a52..fa947c4fbd1f8 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1726,6 +1726,9 @@ static bool is_arch_lbr_xsave_available(void)
 	 * Check the LBR state with the corresponding software structure.
 	 * Disable LBR XSAVES support if the size doesn't match.
 	 */
+	if (xfeature_size(XFEATURE_LBR) == 0)
+		return false;
+
 	if (WARN_ON(xfeature_size(XFEATURE_LBR) != get_lbr_state_size()))
 		return false;
 
-- 
2.34.1



