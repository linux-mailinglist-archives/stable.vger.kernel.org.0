Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5ED59DBAD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357121AbiHWLMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357491AbiHWLLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:11:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08F0B7EF6;
        Tue, 23 Aug 2022 02:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE3860F54;
        Tue, 23 Aug 2022 09:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36668C433C1;
        Tue, 23 Aug 2022 09:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246244;
        bh=7pMGTLfm7+yf402Et0WC41HMCYeZJIfscGaDIL9XAwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14naSlA/iCy0MwR8aVj7px/7mJ1JFIGcKveDImepEkIuMUDulyVXZWZpN6qvDSMnl
         QZm7kV8PkKesWqASe48SQAFaJ5AjRt+QFTPqerjyI06UgUWSIHVtqk6VRNEpbT4rMi
         1iV5V/1gDG9rdbiLPoa7D6bBaX1zQcFnbTDnQM7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 030/389] parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode
Date:   Tue, 23 Aug 2022 10:21:48 +0200
Message-Id: <20220823080116.947594802@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 6431e92fc827bdd2d28f79150d90415ba9ce0d21 upstream.

For all syscalls in 32-bit compat mode on 64-bit kernels the upper
32-bits of the 64-bit registers are zeroed out, so a negative 32-bit
signed value will show up as positive 64-bit signed value.

This behaviour breaks the io_pgetevents_time64() syscall which expects
signed 64-bit values for the "min_nr" and "nr" parameters.
Fix this by switching to the compat_sys_io_pgetevents_time64() syscall,
which uses "compat_long_t" types for those parameters.

Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/syscalls/syscall.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -413,7 +413,7 @@
 412	32	utimensat_time64		sys_utimensat			sys_utimensat
 413	32	pselect6_time64			sys_pselect6			compat_sys_pselect6_time64
 414	32	ppoll_time64			sys_ppoll			compat_sys_ppoll_time64
-416	32	io_pgetevents_time64		sys_io_pgetevents		sys_io_pgetevents
+416	32	io_pgetevents_time64		sys_io_pgetevents		compat_sys_io_pgetevents_time64
 417	32	recvmmsg_time64			sys_recvmmsg			compat_sys_recvmmsg_time64
 418	32	mq_timedsend_time64		sys_mq_timedsend		sys_mq_timedsend
 419	32	mq_timedreceive_time64		sys_mq_timedreceive		sys_mq_timedreceive


