Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE62535BFE
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349993AbiE0Iwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350133AbiE0IwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C634A917;
        Fri, 27 May 2022 01:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B333B61D3D;
        Fri, 27 May 2022 08:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7EFC385A9;
        Fri, 27 May 2022 08:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641522;
        bh=IPrm7l7Y4DEnj3K/unR0h1dsLN/bo46PUM9Qs6lbRoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3WCZrSLijQU24wvrqfa1XiiTSTV2OXjivwTZiyluNYmlZwys5Vj04JLPH22Z1nqt
         2PK9nNsO+UBOeFXKDjJ+pNwKmsIFhx7eZNM0lqiS9MK4yTsX1uN1GwDJ5CXCo5zAMG
         hKe8IcZlTBC7ANymBQfQVBBkEPapHjR6GIJvSzwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 05/47] ia64: define get_cycles macro for arch-override
Date:   Fri, 27 May 2022 10:49:45 +0200
Message-Id: <20220527084801.950246641@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 57c0900b91d8891ab43f0e6b464d059fda51d102 upstream.

Itanium defines a get_cycles() function, but it does not do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined. While the
get_cycles() ifdef is not currently used, the following timekeeping
patch in this series will depend on the macro existing (or not existing)
when defining random_get_entropy().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/include/asm/timex.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/ia64/include/asm/timex.h
+++ b/arch/ia64/include/asm/timex.h
@@ -39,6 +39,7 @@ get_cycles (void)
 	ret = ia64_getreg(_IA64_REG_AR_ITC);
 	return ret;
 }
+#define get_cycles get_cycles
 
 extern void ia64_cpu_local_tick (void);
 extern unsigned long long ia64_native_sched_clock (void);


