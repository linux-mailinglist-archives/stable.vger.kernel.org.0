Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5197E6B45CB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjCJOhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbjCJOhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:37:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B1D11CBE2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7F816195C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E690BC4339C;
        Fri, 10 Mar 2023 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459004;
        bh=18b0VtJeatDWdr6Sssa89b09xyzb0PdeDS8EuZt3M4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zz6fC0I3o58GO86pACNbdmXhDwPv0nYI4IcrW/ksZdFR6nK7hXtWBhBT3QG8DP2dQ
         KJRSHx2xytoMXGYgqVk231BRVUbS7f3ZBhuNwp73kWgCcS4tBAt/A8qysZLHysrIks
         us9oqmzwTn0v6vDkVvtm/+MI1mbt7vqwulBu/g94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 215/357] s390: discard .interp section
Date:   Fri, 10 Mar 2023 14:38:24 +0100
Message-Id: <20230310133744.193393738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit e9c9cb90e76ffaabcc7ca8f275d9e82195fd6367 upstream.

When debugging vmlinux with QEMU + GDB, the following GDB error may
occur:

    (gdb) c
    Continuing.
    Warning:
    Cannot insert breakpoint -1.
    Cannot access memory at address 0xffffffffffff95c0

    Command aborted.
    (gdb)

The reason is that, when .interp section is present, GDB tries to
locate the file specified in it in memory and put a number of
breakpoints there (see enable_break() function in gdb/solib-svr4.c).
Sometimes GDB finds a bogus location that matches its heuristics,
fails to set a breakpoint and stops. This makes further debugging
impossible.

The .interp section contains misleading information anyway (vmlinux
does not need ld.so), so fix by discarding it.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -189,5 +189,6 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(.eh_frame)
+		*(.interp)
 	}
 }


