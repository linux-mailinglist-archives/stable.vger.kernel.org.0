Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609BA23780
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbfETMuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbfETMVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:21:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE05820815;
        Mon, 20 May 2019 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354874;
        bh=tYzvmzxlgCAbu7295+HojwnrPPuXKNiISilXMntA4Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoYvNdCp/mLZXw0t22yjpBPO+H4tBlAtKWsslYVOtbSuQjXKV/tY5mtKT1OGSEPqX
         X2HCrkbP6fM7Lz2kofle1JDuPsrlvE/fWMLiA38MNEDFUwQtaSf5NnyCc+khVjdHvt
         rgZcw3F4VYiccdFI810uftTG2U5/i6L7s/4pPF5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boyang Zhou <zhouby_cn@126.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 012/105] arm64: mmap: Ensure file offset is treated as unsigned
Date:   Mon, 20 May 2019 14:13:18 +0200
Message-Id: <20190520115247.892819926@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boyang Zhou <zhouby_cn@126.com>

commit f08cae2f28db24d95be5204046b60618d8de4ddc upstream.

The file offset argument to the arm64 sys_mmap() implementation is
scaled from bytes to pages by shifting right by PAGE_SHIFT.
Unfortunately, the offset is passed in as a signed 'off_t' type and
therefore large offsets (i.e. with the top bit set) are incorrectly
sign-extended by the shift. This has been observed to cause false mmap()
failures when mapping GPU doorbells on an arm64 server part.

Change the type of the file offset argument to sys_mmap() from 'off_t'
to 'unsigned long' so that the shifting scales the value as expected.

Cc: <stable@vger.kernel.org>
Signed-off-by: Boyang Zhou <zhouby_cn@126.com>
[will: rewrote commit message]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -31,7 +31,7 @@
 
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
-		unsigned long, fd, off_t, off)
+		unsigned long, fd, unsigned long, off)
 {
 	if (offset_in_page(off) != 0)
 		return -EINVAL;


