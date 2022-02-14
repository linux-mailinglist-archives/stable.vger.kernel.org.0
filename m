Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F160A4B4A53
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344085AbiBNJ7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:59:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344232AbiBNJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:58:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDE56A3BE;
        Mon, 14 Feb 2022 01:46:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7EE61200;
        Mon, 14 Feb 2022 09:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3E5C340E9;
        Mon, 14 Feb 2022 09:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831965;
        bh=mJFAQ4XWlIEWfk9/Ehgip/K6Kmf/6NuP5AUZM7Gisx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCPhn4gQNQGxRLNxXK8l9znxtI/QZYMKQWCKEpK0GRMXmJ/5GwxFecstC5GuJ3plI
         lwOFGlEqTRY8OBm6zZtJo+tisLgBz4Q90aM0ClyEiCawP+YLo7Rd8NklynB2EzY411
         IUut0OhIQw43wnikXPOJYd1n+Qfmswc8GTnyM3d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/172] x86/perf: Avoid warning for Arch LBR without XSAVE
Date:   Mon, 14 Feb 2022 10:24:55 +0100
Message-Id: <20220214092507.682504271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index 9e6d6eaeb4cb6..f455dd93f9219 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1734,6 +1734,9 @@ static bool is_arch_lbr_xsave_available(void)
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



