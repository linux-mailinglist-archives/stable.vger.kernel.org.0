Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B4647FEE4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhL0Pdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237590AbhL0PdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEECC06175D;
        Mon, 27 Dec 2021 07:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD9F76104C;
        Mon, 27 Dec 2021 15:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C36C36AEA;
        Mon, 27 Dec 2021 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619196;
        bh=V2qw+lTL3q3d7YefE0rr8zmZwROjgfEPR1SGAe3lDMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYocSEJxL/PubA7682+cRYRoeFaMggSON4h12YhfAbVkCO8QAyu7CSD3xslZulqIF
         7kWTPdz2/dZD2CPJkQ6YjPRAo0WIlWl3kby2snGZaPDEx+KE7rZq2/BvCguYRjrNN+
         HwB97jN1IfC3luBnVfJxNLI+09s32zdSIYhS92CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 26/38] parisc: Correct completer in lws start
Date:   Mon, 27 Dec 2021 16:31:03 +0100
Message-Id: <20211227151320.254627160@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit 8f66fce0f46560b9e910787ff7ad0974441c4f9c upstream.

The completer in the "or,ev %r1,%r30,%r30" instruction is reversed, so we are
not clipping the LWS number when we are called from a 32-bit process (W=0).
We need to nulify the following depdi instruction when the least-significant
bit of %r30 is 1.

If the %r20 register is not clipped, a user process could perform a LWS call
that would branch to an undefined location in the kernel and potentially crash
the machine.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/syscall.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -478,7 +478,7 @@ lws_start:
 	extrd,u	%r1,PSW_W_BIT,1,%r1
 	/* sp must be aligned on 4, so deposit the W bit setting into
 	 * the bottom of sp temporarily */
-	or,ev	%r1,%r30,%r30
+	or,od	%r1,%r30,%r30
 
 	/* Clip LWS number to a 32-bit value for 32-bit processes */
 	depdi	0, 31, 32, %r20


