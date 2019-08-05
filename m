Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5EA8119E
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfHEFc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:32:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53675 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbfHEFc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:32:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 87F9920FE3;
        Mon,  5 Aug 2019 01:32:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7F19uy
        dRzvI8nU5DFM7i/VZ6AUAl1uV26o2vRprvek8=; b=0bW2fDU3BJoy7+jxltBJXX
        hMWmZ4WLzoE0p6zLru95UwaNoxv2Jq9CLW7N0tQmCN6TxmpTO4GkjRtoYHVSXY0i
        vijfvzYVTl7V3FQX6z9HjybX1pDEJy9iQiTy9/c3ZTOu9eT4+AzJb3HoWdrKnIp5
        CLSt0lhwEzh4oWzmWFMDuMw7c+3XnKT2kmOMV0j9Y1GVkXV1rNSc27heyTB8l6sL
        f8aR7Q0QI7WZW3zF6l9n4gn/o47o6SNfLRuo8mgb7i9oPVV3IXK+JwPDjaQ4U0RI
        cdxnkpcXg7pAUcoozaqHQcGxu7IresDQQBu45FobbdhQ2REqDb8LQiNqRkNQ9SUg
        ==
X-ME-Sender: <xms:ar9HXW27bCCVBWzlKQne-49_saw3iWbQ1C9ELk027z2SR-hh8T8HsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:ar9HXesky_mm3Bqrd9HFZ7kiZa9o0RgzaUYa1BNlWhmm-adKDF08aw>
    <xmx:ar9HXW-PJecKdJnfj8LYr28S3iSPbZ9zFdEJsehaiVz3icAkdeijzA>
    <xmx:ar9HXQinf_SRcntqDqqynwBEWwdhY9dzhzTCKkaM71xX5tBp0gcvKw>
    <xmx:ar9HXSxIdJNAHUlKIjAr3tLHVFoN_zExmCnmpBwBcNbcqrfVvHkwfQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2A9980059;
        Mon,  5 Aug 2019 01:32:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: compat: Allow single-byte watchpoints on all addresses" failed to apply to 4.14-stable tree
To:     will@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:32:24 +0200
Message-ID: <1564983144193131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

