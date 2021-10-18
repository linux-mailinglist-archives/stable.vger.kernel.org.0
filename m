Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB41A431DF1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhJRN4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234487AbhJRNx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED291619F8;
        Mon, 18 Oct 2021 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564369;
        bh=dzqWgEgr5HFi1i3QRGceWJ6s6UTKBiP3TXHj47l8gXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjlDNaCtVOclaOKVKebAk9MjyYTctU41a3Y74Rb89wSVBwHZNAPn9q/NvoVTQa0d/
         9jYS51PEq4lQAU5qTM4LygjEtzwOHzdWZDnrHWkXqA7L2al2K49Ejl4ndlo08nDYYI
         6hRXhbt7pynCCWVtgZ8J46x8nDuK2E5az9KGLJ5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Ser Olmy <ser.olmy@protonmail.com>
Subject: [PATCH 5.14 062/151] x86/fpu: Mask out the invalid MXCSR bits properly
Date:   Mon, 18 Oct 2021 15:24:01 +0200
Message-Id: <20211018132342.713052446@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit b2381acd3fd9bacd2c63f53b2c610c89959b31cc upstream.

This is a fix for the fix (yeah, /facepalm).

The correct mask to use is not the negation of the MXCSR_MASK but the
actual mask which contains the supported bits in the MXCSR register.

Reported and debugged by Ville Syrjälä <ville.syrjala@linux.intel.com>

Fixes: d298b03506d3 ("x86/fpu: Restore the masking out of reserved MXCSR bits")
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ser Olmy <ser.olmy@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YWgYIYXLriayyezv@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -385,7 +385,7 @@ static int __fpu_restore_sig(void __user
 				return -EINVAL;
 		} else {
 			/* Mask invalid bits out for historical reasons (broken hardware). */
-			fpu->state.fxsave.mxcsr &= ~mxcsr_feature_mask;
+			fpu->state.fxsave.mxcsr &= mxcsr_feature_mask;
 		}
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */


