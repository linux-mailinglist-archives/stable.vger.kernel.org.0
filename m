Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DA659458F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347335AbiHOWDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350391AbiHOWCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70211EACE;
        Mon, 15 Aug 2022 12:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22B1FB80EAB;
        Mon, 15 Aug 2022 19:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6481DC433C1;
        Mon, 15 Aug 2022 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592183;
        bh=AG+Uiec8voQAxe4xbm6dYZ5iaa1ZLFeWAYPNJDAg5og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/6j2ZfME7lG4oTi3d4kIqDYysxhZ36+NDFj/SFAIqSdKNFQg9r68HBoh2pzPLpZI
         rTAgHzmMYAMNVWh3Xw0/A6SEqeNhepW+UGJlrt07MdUo4KcKjpWdt7kWvxdgy/3KgM
         fFRGtTHgVOVJ2cOkAKrg3IOaSfo0KvYRqzsRVFQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 0071/1157] RISC-V: cpu_ops_spinwait.c should include head.h
Date:   Mon, 15 Aug 2022 19:50:27 +0200
Message-Id: <20220815180442.354897045@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@sifive.com>

commit e4aa991c05aedc3ead92d1352af86db74090dc3c upstream.

Running sparse shows cpu_ops_spinwait.c is missing two definitions
found in head.h, so include it to stop the following warnings:

arch/riscv/kernel/cpu_ops_spinwait.c:15:6: warning: symbol '__cpu_spinwait_stack_pointer' was not declared. Should it be static?
arch/riscv/kernel/cpu_ops_spinwait.c:16:6: warning: symbol '__cpu_spinwait_task_pointer' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Link: https://lore.kernel.org/r/20220713215306.94675-1-ben.dooks@sifive.com
Fixes: c78f94f35cf6 ("RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cpu_ops_spinwait.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kernel/cpu_ops_spinwait.c
+++ b/arch/riscv/kernel/cpu_ops_spinwait.c
@@ -11,6 +11,8 @@
 #include <asm/sbi.h>
 #include <asm/smp.h>
 
+#include "head.h"
+
 const struct cpu_operations cpu_ops_spinwait;
 void *__cpu_spinwait_stack_pointer[NR_CPUS] __section(".data");
 void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");


