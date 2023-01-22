Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12AE676ECF
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjAVPOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjAVPOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921F922005
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 311F860C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FB0C433D2;
        Sun, 22 Jan 2023 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400474;
        bh=8w7Wb+lHTqgyJ3RKg0d9TmlDcR8VFVsphUBvP+js0Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HTs2anTGV6mLHW2MvTdb8hGCrWnYax3WuDcdzaXP9BlG29n1/EyDVTbqO5lojSaB
         xkBu9y4jcTeAOPTaVI8sR2MLH7EY7+F4qX/SgjV+HbmzwUgCAd45QRKx1LLApUkgcy
         N4Zk5eXpqhYoW14WicbaMxi1H1zsU60spKPXL20U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 89/98] powerpc/vmlinux.lds: Dont discard .comment
Date:   Sun, 22 Jan 2023 16:04:45 +0100
Message-Id: <20230122150233.184132518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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
@@ -379,7 +379,7 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .comment)
+		*(.glink .iplt .plt)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)


