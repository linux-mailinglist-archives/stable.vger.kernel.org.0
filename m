Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ABD593569
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiHOSYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240177AbiHOSXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4A02E9F4;
        Mon, 15 Aug 2022 11:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EACBB81072;
        Mon, 15 Aug 2022 18:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84E2C433D6;
        Mon, 15 Aug 2022 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587466;
        bh=7pMGTLfm7+yf402Et0WC41HMCYeZJIfscGaDIL9XAwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwWhYpjHB3LDlJoPW1OYwI5XnRHRy0PUymWYKjw8pgTDETVLpgH0jeY8HdthP+9U5
         77l4F9nrj3c/3w0xEmeudY3ktGOtN+gbEqC4MvJc6pHRo+Y5vwggmDmVrMNrxl3K3v
         J+DtTquH6xw5MMW9IutKJN+tf1jJuKswx5BYVQeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 052/779] parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode
Date:   Mon, 15 Aug 2022 19:54:56 +0200
Message-Id: <20220815180339.493755603@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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


