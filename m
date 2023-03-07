Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C09B6AEC30
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjCGRxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjCGRwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D52A54EC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C32ECB819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0DCC433EF;
        Tue,  7 Mar 2023 17:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211228;
        bh=PvVmhNWcGfmoX70Q35VETDXUPrnkRGlJ9jQ2jhJFUeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEaignZq520mqRCdrAf9RoLbD47gto1Xee1rFioqMPb4Un0aV5UYhdJvPZUfJjSun
         BdL1sVCbEw7a7TmrYpKttgpwIH3jAiJkx8DKvyhpXfI+/62uoWO9KtW8iPk2H1X4+s
         YgmMGrK4ZqxmQ7LXkYeG/YWunz1E9CNZTuIwGyPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.2 0764/1001] s390: discard .interp section
Date:   Tue,  7 Mar 2023 17:58:56 +0100
Message-Id: <20230307170054.916804129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -228,5 +228,6 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(.eh_frame)
+		*(.interp)
 	}
 }


