Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C78B145645
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgAVNYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgAVNYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:16 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA9A2468D;
        Wed, 22 Jan 2020 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699455;
        bh=2XFJKf9YRkxVNoy0KmpGHz7h35hFjbn2m6Ub3IWWJng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJaXxKPC0h6owD+4O7COaUW/Nh33k8Y8ZCazKSmrEh9eanaSoDKGEz2+Eq1gAwmAI
         NIIvDdo/o80jGTBWjnq1lGPF/EZ/H8LLPNQKkfeoV8ETMGk153MLsa1IIq/cq7dtb4
         M9CIey4DfxmZ9lQmwQmwrRDpDmQR1TAzr6ltPd8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH 5.4 115/222] bpf: Sockmap/tls, fix pop data with SK_DROP return code
Date:   Wed, 22 Jan 2020 10:28:21 +0100
Message-Id: <20200122092841.966043129@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 7361d44896ff20d48bdd502d1a0cd66308055d45 upstream.

When user returns SK_DROP we need to reset the number of copied bytes
to indicate to the user the bytes were dropped and not sent. If we
don't reset the copied arg sendmsg will return as if those bytes were
copied giving the user a positive return value.

This works as expected today except in the case where the user also
pops bytes. In the pop case the sg.size is reduced but we don't correctly
account for this when copied bytes is reset. The popped bytes are not
accounted for and we return a small positive value potentially confusing
the user.

The reason this happens is due to a typo where we do the wrong comparison
when accounting for pop bytes. In this fix notice the if/else is not
needed and that we have a similar problem if we push data except its not
visible to the user because if delta is larger the sg.size we return a
negative value so it appears as an error regardless.

Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20200111061206.8028-9-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_bpf.c |    5 +----
 net/tls/tls_sw.c   |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -315,10 +315,7 @@ more_data:
 		 */
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
-		if (msg->sg.size < delta)
-			delta -= msg->sg.size;
-		else
-			delta = 0;
+		delta -= msg->sg.size;
 	}
 
 	if (msg->cork_bytes &&
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -804,10 +804,7 @@ more_data:
 	if (psock->eval == __SK_NONE) {
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
-		if (delta < msg->sg.size)
-			delta -= msg->sg.size;
-		else
-			delta = 0;
+		delta -= msg->sg.size;
 	}
 	if (msg->cork_bytes && msg->cork_bytes > msg->sg.size &&
 	    !enospc && !full_record) {


