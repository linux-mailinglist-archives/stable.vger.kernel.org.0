Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD45259D35B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiHWIM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiHWILU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148172CDFC;
        Tue, 23 Aug 2022 01:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C81FCB81C25;
        Tue, 23 Aug 2022 08:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4D4C433C1;
        Tue, 23 Aug 2022 08:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242102;
        bh=lMQfg4bXnS5R49GvVs8vjfw+34XXX8JWBNWJFGQl7e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2pSZ7pUDgjmaNNjrv+CH4q5KKFPiE1TFZCcnBAIBo00rHKyGdDP1Rzn07oNYkKDE
         2OnGnPmbURHBBPlAeNrsazCzQ/IexLHy4lqrQJKhg2dzo3wvA+v1CEjKr3FTw5als/
         CLsCNnfcMUlr7/IXJkUXG5u6gwhflmogd95uxj9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Theodore Tso" <tytso@mit.edu>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Kralevich <nnk@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH 4.9 019/101] init: move stack canary initialization after setup_arch
Date:   Tue, 23 Aug 2022 10:02:52 +0200
Message-Id: <20220823080035.308410843@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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

From: Laura Abbott <lauraa@codeaurora.org>

commit 121388a31362b0d3176dc1190ac8064b98a61b20 upstream.

Patch series "Command line randomness", v3.

A series to add the kernel command line as a source of randomness.

This patch (of 2):

Stack canary intialization involves getting a random number.  Getting this
random number may involve accessing caches or other architectural specific
features which are not available until after the architecture is setup.
Move the stack canary initialization later to accommodate this.

Link: http://lkml.kernel.org/r/20170816231458.2299-2-labbott@redhat.com
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Nick Kralevich <nnk@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -487,12 +487,6 @@ asmlinkage __visible void __init start_k
 	smp_setup_processor_id();
 	debug_objects_early_init();
 
-	/*
-	 * Set up the initial canary ASAP:
-	 */
-	add_latent_entropy();
-	boot_init_stack_canary();
-
 	cgroup_init_early();
 
 	local_irq_disable();
@@ -506,6 +500,11 @@ asmlinkage __visible void __init start_k
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
+	/*
+	 * Set up the the initial canary and entropy after arch
+	 */
+	add_latent_entropy();
+	boot_init_stack_canary();
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();


