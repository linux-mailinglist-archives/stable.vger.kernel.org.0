Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB4302AF2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbhAYS4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731308AbhAYSz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7AE221FB;
        Mon, 25 Jan 2021 18:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600918;
        bh=gNFxL61gMEkcT9G2HPY2s5oXzhvLb3UclCcntZNE9Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy997uJERYLByezbU4H420WdMjXZCk/6eeLqqEIwIxZmfHOPfENyRKPH97dRJuVKh
         gKJat1LucgXnIUI55PA7WZvx2KcgF9wTwoHPHFkUZUQLfRu8lvz9GwzALDtaCPwm0P
         gHZ9ZI4c6u3gKxNq2tsMnrtcerewgu+ABJLw/0+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Borislav Petkov <bp@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 5.10 191/199] x86/sev-es: Handle string port IO to kernel memory properly
Date:   Mon, 25 Jan 2021 19:40:13 +0100
Message-Id: <20210125183224.231796983@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunwook (Wooky) Baek <baekhw@google.com>

commit 7024f60d655272bd2ca1d3a4c9e0a63319b1eea1 upstream.

Don't assume dest/source buffers are userspace addresses when manually
copying data for string I/O or MOVS MMIO, as {get,put}_user() will fail
if handed a kernel address and ultimately lead to a kernel panic.

When invoking INSB/OUTSB instructions in kernel space in a
SEV-ES-enabled VM, the kernel crashes with the following message:

  "SEV-ES: Unsupported exception in #VC instruction emulation - can't continue"

Handle that case properly.

 [ bp: Massage commit message. ]

Fixes: f980f9c31a92 ("x86/sev-es: Compile early handler code into kernel image")
Signed-off-by: Hyunwook (Wooky) Baek <baekhw@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Link: https://lkml.kernel.org/r/20210110071102.2576186-1-baekhw@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -286,6 +286,12 @@ static enum es_result vc_write_mem(struc
 	u16 d2;
 	u8  d1;
 
+	/* If instruction ran in kernel mode and the I/O buffer is in kernel space */
+	if (!user_mode(ctxt->regs) && !access_ok(target, size)) {
+		memcpy(dst, buf, size);
+		return ES_OK;
+	}
+
 	switch (size) {
 	case 1:
 		memcpy(&d1, buf, 1);
@@ -335,6 +341,12 @@ static enum es_result vc_read_mem(struct
 	u16 d2;
 	u8  d1;
 
+	/* If instruction ran in kernel mode and the I/O buffer is in kernel space */
+	if (!user_mode(ctxt->regs) && !access_ok(s, size)) {
+		memcpy(buf, src, size);
+		return ES_OK;
+	}
+
 	switch (size) {
 	case 1:
 		if (get_user(d1, s))


