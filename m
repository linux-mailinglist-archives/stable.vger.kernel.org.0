Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD26594D1E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbiHPBCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349635AbiHPA6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:58:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616481A3917;
        Mon, 15 Aug 2022 13:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2BA8B811AE;
        Mon, 15 Aug 2022 20:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9CBC433C1;
        Mon, 15 Aug 2022 20:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596597;
        bh=dg9/iLNoP90yeUEWFEyZvSjml0J6j+qZ3W5XqIRkfYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEVq3MxpbSOO9FLygwO4rD7no4JOWeF/Za1zSw4t7Cbw82LSWuqVrMEki5Am66/ng
         /L9sveX7IufrrowBiqER64PJThjL3jFR8OlhSvVvHdFBJom/n84c1xmGogE704tPtf
         w8PLKHB4XePICWlFf2naB2zBpig0AFhf2v9PAHbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, WANG Xuerui <git@xen0n.name>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1131/1157] tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH
Date:   Mon, 15 Aug 2022 20:08:07 +0200
Message-Id: <20220815180525.638574282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit bed4593645366ad7362a3aa7bc0d100d8d8236a8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tpm_eventlog.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 739ba9a03ec1..20c0ff54b7a0 100644
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
-- 
2.35.1



