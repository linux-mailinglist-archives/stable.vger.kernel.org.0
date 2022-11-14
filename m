Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAE2628067
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiKNNFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237790AbiKNNFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A3A2A71C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA7356116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70F9C433D6;
        Mon, 14 Nov 2022 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431141;
        bh=0XbZ2eQOQIp0yEgiU2t01QB0J2GFacoTVVNNwcRIC5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMOO2zi8DTWXL8R0sa6LLonNXUmIesV9Lfh0kC9ymeOttrqKXbstrL/Ck3Yka+rfy
         CRBPUhfkDeKTMD0CUAoXInrDJYy+rCALkHsMHkaLjSzYntDnTDtZBjrm5p0S2UWJt5
         41hjShPm6OkAfkm0G0eez9Hz7Ynx7J8txhJIVV+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.0 116/190] MIPS: jump_label: Fix compat branch range check
Date:   Mon, 14 Nov 2022 13:45:40 +0100
Message-Id: <20221114124503.774969399@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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


