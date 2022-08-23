Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185659DD08
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357549AbiHWLjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357715AbiHWLiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:38:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1C21054A;
        Tue, 23 Aug 2022 02:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A6CB81C85;
        Tue, 23 Aug 2022 09:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D203CC433C1;
        Tue, 23 Aug 2022 09:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246899;
        bh=SQXOfBhhjusfyQ7h7S2cvioqr/p4Hpbw5vz6sQzz1Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkI16JYsi2c/l5fDN6rzH6CtbkpHXhOObXBf3CgXXIdfB0qLIUFQv6GmEm9gkQr+R
         EjEpnQTCGEBjWxN8xv5Pwxhu0y8NG60YC0vxIeKgV2LdZ6acwRwZyX5I+raIEQPpb1
         j1sX/UXGKgmM7KBxWjjF/DB4GFTXaDBfKxlITTM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, WANG Xuerui <git@xen0n.name>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 255/389] tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH
Date:   Tue, 23 Aug 2022 10:25:33 +0200
Message-Id: <20220823080126.253203932@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit bed4593645366ad7362a3aa7bc0d100d8d8236a8 upstream.

If DEBUG_SECTION_MISMATCH enabled, __calc_tpm2_event_size() will not be
inlined, this cause section mismatch like this:

WARNING: modpost: vmlinux.o(.text.unlikely+0xe30c): Section mismatch in reference from the variable L0 to the function .init.text:early_ioremap()
The function L0() references
the function __init early_memremap().
This is often because L0 lacks a __init
annotation or the annotation of early_ioremap is wrong.

Fix it by using __always_inline instead of inline for the called-once
function __calc_tpm2_event_size().

Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
Cc: stable@vger.kernel.org # v5.3
Reported-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tpm_eventlog.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -157,7 +157,7 @@ struct tcg_algorithm_info {
  * Return: size of the event on success, 0 on failure
  */
 
-static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
+static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 					 struct tcg_pcr_event *event_header,
 					 bool do_mapping)
 {


