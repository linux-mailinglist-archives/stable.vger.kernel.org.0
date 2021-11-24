Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F0345C685
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353604AbhKXOKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354174AbhKXOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC9E7633F8;
        Wed, 24 Nov 2021 13:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759516;
        bh=5eVFlKmiOGa5MfTM9+XMxFBysfDmMBpwdNLvuurY28g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM6LTTXFnXabiz3uI2lYbRjzhrHESCOg2WQVpGi97C1eLbrFVTzAhGd2q6rymkORd
         sn4fhgeyLQjBQcum2GQMQKsBNals5FDFENxaOuF2+0QDzuem81D95G+xnrzd6AHytf
         weP/Njw1qOL7NOMNE/sJZZsbe9leGdrnbHzg7Qsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 261/279] signal/sparc32: In setup_rt_frame and setup_fram use force_fatal_sig
Date:   Wed, 24 Nov 2021 12:59:08 +0100
Message-Id: <20211124115727.732846259@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 086ec444f86660e103de8945d0dcae9b67132ac9 upstream.

Modify the 32bit version of setup_rt_frame and setup_frame to act
similar to the 64bit version of setup_rt_frame and fail with a signal
instead of calling do_exit.

Replacing do_exit(SIGILL) with force_fatal_signal(SIGILL) ensures that
the process will be terminated cleanly when the stack frame is
invalid, instead of just killing off a single thread and leaving the
process is a weird state.

Cc: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Link: https://lkml.kernel.org/r/20211020174406.17889-16-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/signal_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -244,7 +244,7 @@ static int setup_frame(struct ksignal *k
 		get_sigframe(ksig, regs, sigframe_size);
 
 	if (invalid_frame_pointer(sf, sigframe_size)) {
-		do_exit(SIGILL);
+		force_fatal_sig(SIGILL);
 		return -EINVAL;
 	}
 
@@ -336,7 +336,7 @@ static int setup_rt_frame(struct ksignal
 	sf = (struct rt_signal_frame __user *)
 		get_sigframe(ksig, regs, sigframe_size);
 	if (invalid_frame_pointer(sf, sigframe_size)) {
-		do_exit(SIGILL);
+		force_fatal_sig(SIGILL);
 		return -EINVAL;
 	}
 


