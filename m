Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D24676F4B
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjAVPTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAVPTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD8522021
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A750D60C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B876BC433EF;
        Sun, 22 Jan 2023 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400789;
        bh=Qjkq3ludEGLpc1IacEC2qWHairMaWlYWb+tUxTvba0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byn/P4Oa19hgVciwYklCdLNaqbjZEx+Wj5jg5avvrhz7Ckz/8EhK29sEfRVYix2ur
         qTEsMv30DzFRJjTTsglfRT85SDHE40+kjab69ME1jBgCbrPk55LTfXgTo0F4oGsh+W
         29pPgGz5QtYNnjIunGPLunyPnptpCFHJIu6JdmAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 110/117] powerpc/vmlinux.lds: Dont discard .comment
Date:   Sun, 22 Jan 2023 16:05:00 +0100
Message-Id: <20230122150237.403853092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit be5f95c8779e19779dd81927c8574fec5aaba36c upstream.

Although the powerpc linker script mentions .comment in the DISCARD
section, that has never actually caused it to be discarded, because the
earlier ELF_DETAILS macro (previously STABS_DEBUG) explicitly includes
.comment.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro. With binutils < 2.36 that causes the DISCARD directives later in
the script to be applied earlier, causing .comment to actually be
discarded.

It's confusing to explicitly include and discard .comment, and even more
so if the behaviour depends on the toolchain version. So don't discard
.comment in order to maintain the existing behaviour in all cases.

Fixes: 83a092cf95f2 ("powerpc: Link warning for orphan sections")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-3-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -400,7 +400,7 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .comment)
+		*(.glink .iplt .plt)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)


