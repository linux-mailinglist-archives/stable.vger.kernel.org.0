Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A3811A0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfHEFc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:32:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42875 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:32:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 37F8520FE3;
        Mon,  5 Aug 2019 01:32:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UtC42K
        nUxWXFjX8C9HdjFOIDg1B0/wR2tKltW1dIBFo=; b=k3hMPgjfM87Jvqckul8hnu
        YEsxpGpPw4YIiO4Bsg2eaKJqrKUpuv/PnFQvYMo/k7iEtsF/YmSjsst+1rNIHekN
        mKZ1wBiivz/RGX7yM+sDDNMeHU6Rf8cO8uvS1ZzA4OeVF9WIxm/CyQwdTDNfXBME
        Fh3WFdBxExDxLCem1bD75Y4D+Alo+FKm8x6p3qXXTZV0zuayySotdxccq7nmH53j
        sRCKzzNP+Fz+9k7ASHjXTvWD+F59t1fCaznQMuFBZ11em+mgV6/x8q4SQ/qfopZl
        HQoWFMKr8r3qeTxBuqFfimvZNdVMtRXbJkhZ6qWM8pF/8jLop4IHrC52LR7h1UMQ
        ==
X-ME-Sender: <xms:bL9HXUWWpWiSm7KUbcC1rQuEjvk3ERQiHpQ0SJ7ND86URA0xVAq3XQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:bL9HXdmWRPfCUpQKIujtrutVSB7t_mccAhAe_y8ILz23NyhR7nNHpw>
    <xmx:bL9HXZT3M0HXywC4B6mXErjLr1480tDu4Ua5qYfF_EqKrlDWY16-dQ>
    <xmx:bL9HXZGlvdyYyXVQsSaytZVTKgQvB2oPZEf5DaLGTl1WfUeIeAHhnw>
    <xmx:bL9HXZWQqOR9kptolYRWolH9NWw60wuO2LnL5IMJs440g5qiqH-eXA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABDC8380074;
        Mon,  5 Aug 2019 01:32:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: compat: Allow single-byte watchpoints on all addresses" failed to apply to 4.9-stable tree
To:     will@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:32:25 +0200
Message-ID: <156498314513144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 849adec41203ac5837c40c2d7e08490ffdef3c2c Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Mon, 29 Jul 2019 11:06:17 +0100
Subject: [PATCH] arm64: compat: Allow single-byte watchpoints on all addresses

Commit d968d2b801d8 ("ARM: 7497/1: hw_breakpoint: allow single-byte
watchpoints on all addresses") changed the validation requirements for
hardware watchpoints on arch/arm/. Update our compat layer to implement
the same relaxation.

Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index dceb84520948..67b3bae50b92 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -536,13 +536,14 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
 			/* Aligned */
 			break;
 		case 1:
-			/* Allow single byte watchpoint. */
-			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
-				break;
 		case 2:
 			/* Allow halfword watchpoints and breakpoints. */
 			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
 				break;
+		case 3:
+			/* Allow single byte watchpoint. */
+			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
+				break;
 		default:
 			return -EINVAL;
 		}

