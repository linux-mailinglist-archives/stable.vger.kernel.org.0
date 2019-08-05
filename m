Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D537811A1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHEFca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:32:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60589 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFca (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:32:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AA80320EF7;
        Mon,  5 Aug 2019 01:32:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=klcguv
        dIqqvSQ5Yk+8qgMNMlxKrLn/rOEJI5byhGtmA=; b=p/+zT5RUOkLMu7q1EPGP/j
        fhoBCQc+Zk1E3mg2/FAAWOcIkEBXwM03iJhEJFcyNh5ns4WhXg2BLZ/QVVNhdSGU
        YVIB4b/Z7gBy1beTZLiuq0eNzZca/9KwLy+rAdpECd63XG28akUknTML3om95Vvs
        zmULM1V8Rm9P/w7Y92uR3yg8S+7R3HcQr2p0r/ux+uAQK+HSsd9DUOJa0X4An6tq
        AZi6gCsu8R4ckWau41kV89QwX3SWp10G+EWXF8DprmjR2DImUPTWz8l+q7jL7ZqL
        ScxqFJOJPpt7pvkcB5IpnIw0OJbk3y+9pbVlfDGFbwTJuHSg+ODiJo8dK+EE1vVg
        ==
X-ME-Sender: <xms:bb9HXUKAVrkSAd4f5QQItxmeUIsYPe5sG_M2UZoPI_y-OMiwtlRSig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:bb9HXclCq2Jy9CSkLOs5pYthyl1NbjIWNvtfPQ9b1jDHDUKCNJ1ayQ>
    <xmx:bb9HXVJ1JaRkWXvLWzOo2KWz59gnaDnssu4Xf9pmGd1blmM7py2_dQ>
    <xmx:bb9HXR5vaDX02BT6KLCJjwD8sawD3RLKqFcDDINOIo-Fi1PQn7CrSA>
    <xmx:bb9HXe9gS_CU474B9T0sMJlODqkq7UrkbHlUQzR3hRtjdr4ORI7d6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 26F108005B;
        Mon,  5 Aug 2019 01:32:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: compat: Allow single-byte watchpoints on all addresses" failed to apply to 4.4-stable tree
To:     will@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:32:26 +0200
Message-ID: <1564983146189130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

