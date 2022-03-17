Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5CC4DC68C
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiCQMzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiCQMwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C9A1F1D11;
        Thu, 17 Mar 2022 05:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99783614AF;
        Thu, 17 Mar 2022 12:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41B0C340ED;
        Thu, 17 Mar 2022 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521413;
        bh=Q7TxT+Qahmke/4FB6D+uOUHQd94SguoBT2wBn7Wh2p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHO0693l4ZBE8yX4v5vFuV9HWVeePeYhwXHmP+uhiYlJz15RHbBP2jleC+f7RIr4f
         ym2uFCMqw7ySNRRuCOBnwmSXXeDF0WuUDqohnMLAiuwtvYdLYJRW27X/lk9BsME9U1
         zgUcHmtTddAh1zR/S6zLSckya+MR2ss8frFqnYEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 23/23] arm64: kvm: Fix copy-and-paste error in bhb templates for v5.10 stable
Date:   Thu, 17 Mar 2022 13:46:04 +0100
Message-Id: <20220317124526.627536148@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
References: <20220317124525.955110315@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

KVM's infrastructure for spectre mitigations in the vectors in v5.10 and
earlier is different, it uses templates which are used to build a set of
vectors at runtime.

There are two copy-and-paste errors in the templates: __spectre_bhb_loop_k24
should loop 24 times and __spectre_bhb_loop_k32 32.

Fix these.

Reported-by: Pavel Machek <pavel@denx.de>
Link: https://lore.kernel.org/all/20220310234858.GB16308@amd/
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/smccc_wa.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/smccc_wa.S
+++ b/arch/arm64/kvm/hyp/smccc_wa.S
@@ -68,7 +68,7 @@ SYM_DATA_START(__spectre_bhb_loop_k24)
 	esb
 	sub	sp, sp, #(8 * 2)
 	stp	x0, x1, [sp, #(8 * 0)]
-	mov	x0, #8
+	mov	x0, #24
 2:	b	. + 4
 	subs	x0, x0, #1
 	b.ne	2b
@@ -85,7 +85,7 @@ SYM_DATA_START(__spectre_bhb_loop_k32)
 	esb
 	sub	sp, sp, #(8 * 2)
 	stp	x0, x1, [sp, #(8 * 0)]
-	mov	x0, #8
+	mov	x0, #32
 2:	b	. + 4
 	subs	x0, x0, #1
 	b.ne	2b


