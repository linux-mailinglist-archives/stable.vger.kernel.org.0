Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A05528B814
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389586AbgJLNtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731930AbgJLNsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F21F2065C;
        Mon, 12 Oct 2020 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510500;
        bh=nkughcisM3Tew1sDWfUS+ImMOVIfJ4vGc+Frw2AFkWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUxYcE/vxN0DpyWO3WwyRXaoWzeR55VZx9K0M1zzcb3pYezjvjBVjPSbRjCKJcJSv
         RH2Jlnppu62/sCyRTm2BE55II0Y+hgIVgzJiSoC11qzvCpTj9JkXG+lJfFexNHf+RD
         II5xKIbquLE6/ndX3o90hQLGuIdTlLSIQxDES/L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 5.8 119/124] tty/vt: Do not warn when huge selection requested
Date:   Mon, 12 Oct 2020 15:32:03 +0200
Message-Id: <20201012133152.609765516@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit 44c413d9a51752056d606bf6f312003ac1740fab upstream.

The tty TIOCL_SETSEL ioctl allocates a memory buffer big enough for text
selection area. The maximum allowed console size is
VC_RESIZE_MAXCOL * VC_RESIZE_MAXROW == 32767*32767 == ~1GB and typical
MAX_ORDER is set to allow allocations lot less than than (circa 16MB).

So it is quite possible to trigger huge allocation (and syzkaller just
did that) which is going to fail (which is fine) with a backtrace in
mm/page_alloc.c at WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN)) and
this may trigger panic (if panic_on_warn is enabled) and
leak kernel addresses to dmesg.

This passes __GFP_NOWARN to kmalloc_array to avoid unnecessary user-
triggered WARN_ON. Note that the error is not ignored and
the warning is still printed.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Link: https://lore.kernel.org/r/20200617070444.116704-1-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/selection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -193,7 +193,7 @@ static int vc_selection_store_chars(stru
 	/* Allocate a new buffer before freeing the old one ... */
 	/* chars can take up to 4 bytes with unicode */
 	bp = kmalloc_array((vc_sel.end - vc_sel.start) / 2 + 1, unicode ? 4 : 1,
-			   GFP_KERNEL);
+			   GFP_KERNEL | __GFP_NOWARN);
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();


