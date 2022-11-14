Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5730627F45
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiKNM5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237582AbiKNM5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7E827DFB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC13961189
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2E2C433C1;
        Mon, 14 Nov 2022 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430623;
        bh=0XbZ2eQOQIp0yEgiU2t01QB0J2GFacoTVVNNwcRIC5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2K5aq0P6yDb8v+0ENcCy2GLPYxr38pdr/Vlqt5077PeGT8nD1cGWJA5HfCwkYk+t
         n8Z9ILdFckw5lJZHuNKwk7e+OO4v16ZjwNTYVYtVl4pnnFZvAKrp52QoqkKRXB4aPB
         Rw+l+wiwPSpYkIK9w2I0AaKDkphvIp/OakB6ndr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 083/131] MIPS: jump_label: Fix compat branch range check
Date:   Mon, 14 Nov 2022 13:45:52 +0100
Message-Id: <20221114124452.223932336@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 64ac0befe75bdfaffc396c2b4a0ed5ae6920eeee upstream.

Cast upper bound of branch range to long to do signed compare,
avoid negative offset trigger this warning.

Fixes: 9b6584e35f40 ("MIPS: jump_label: Use compact branches for >= r6")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/jump_label.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -56,7 +56,7 @@ void arch_jump_label_transform(struct ju
 			 * The branch offset must fit in the instruction's 26
 			 * bit field.
 			 */
-			WARN_ON((offset >= BIT(25)) ||
+			WARN_ON((offset >= (long)BIT(25)) ||
 				(offset < -(long)BIT(25)));
 
 			insn.j_format.opcode = bc6_op;


