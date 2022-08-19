Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4903D59A4B2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353912AbiHSQqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354017AbiHSQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2535212A1D7;
        Fri, 19 Aug 2022 09:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84CA5B82813;
        Fri, 19 Aug 2022 16:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFAFC433C1;
        Fri, 19 Aug 2022 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925510;
        bh=SQXOfBhhjusfyQ7h7S2cvioqr/p4Hpbw5vz6sQzz1Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFymP0oYRlPsetSxtQ9Ps0dQ7yE35DyE9teKmF4lF0ilvwRGmKl9vlsKPrJ8DY0oz
         gL4BQoze3r7lBQAf/VEBZ5KToCsgsJ+A2I0mLlj5Cf67MQC84ao3vAnr0CIIttP5g7
         k5bYDsa1X3HoJpV5N5pb093sy57TdZ5uuHwF9JHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, WANG Xuerui <git@xen0n.name>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 514/545] tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH
Date:   Fri, 19 Aug 2022 17:44:44 +0200
Message-Id: <20220819153852.507832822@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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


