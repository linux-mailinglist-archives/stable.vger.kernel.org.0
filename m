Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE5F59D57D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243286AbiHWI1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243328AbiHWIY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684AB1836B;
        Tue, 23 Aug 2022 01:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9AB361324;
        Tue, 23 Aug 2022 08:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22B0C433C1;
        Tue, 23 Aug 2022 08:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242382;
        bh=198MJV5Vfc/FGWCXHEV8mqffz6z2Dlc0B5J2AMGuxB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzAox7Vvg2s3HR7LbJhj0OMtp/ITaM78a42faJLH+8RfabHB7twnEz9OzwenVmwWr
         EAbLD1TJpV9PGMEJ9RBOpLSox4HD3G9CXhEt7TYBSCDavcoiS2cIroC95jdOvqTBKx
         tvqZ3i8KSa0ajnl8tNFriTh2VoKf5WaRG9fyZ58Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 063/101] nios2: time: Read timer in get_cycles only if initialized
Date:   Tue, 23 Aug 2022 10:03:36 +0200
Message-Id: <20220823080036.986294626@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

commit 65d1e3ddeae117f6a224535e10a09145f0f96508 upstream.

Mainline crashes as follows when running nios2 images.

On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat c8408fa0, node_mem_map c8726000
  Normal zone: 512 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 65536 pages, LIFO batch:15
Unable to handle kernel NULL pointer dereference at virtual address 00000000
ea = c8003cb0, ra = c81cbf40, cause = 15
Kernel panic - not syncing: Oops

Problem is seen because get_cycles() is called before the timer it depends
on is initialized. Returning 0 in that situation fixes the problem.

Fixes: 33d72f3822d7 ("init/main.c: extract early boot entropy from the ..")
Cc: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/time.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/nios2/kernel/time.c
+++ b/arch/nios2/kernel/time.c
@@ -107,7 +107,10 @@ static struct nios2_clocksource nios2_cs
 
 cycles_t get_cycles(void)
 {
-	return nios2_timer_read(&nios2_cs.cs);
+	/* Only read timer if it has been initialized */
+	if (nios2_cs.timer.base)
+		return nios2_timer_read(&nios2_cs.cs);
+	return 0;
 }
 EXPORT_SYMBOL(get_cycles);
 


