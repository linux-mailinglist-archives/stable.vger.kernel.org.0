Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2653647FF1D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbhL0Pf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39890 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbhL0PfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED0BDCE10D2;
        Mon, 27 Dec 2021 15:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74BDC36AEC;
        Mon, 27 Dec 2021 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619315;
        bh=V2qw+lTL3q3d7YefE0rr8zmZwROjgfEPR1SGAe3lDMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rpe4H0mngO5URoFLBq5qNffR+6JZ3xkjHwkjKOIjX9pLPQbUx5sMLq0RVH4bkVXLr
         qID1npdjWekPHOEPpxl2wTUMC5bzf4NYxGQyO9/RDd+S/fT8eYyXi2yH/D2BEd9unH
         fVVZHVvmUhjHLA1356hlPc/snwA61j8VPGG9SAA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 29/47] parisc: Correct completer in lws start
Date:   Mon, 27 Dec 2021 16:31:05 +0100
Message-Id: <20211227151321.798676370@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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


