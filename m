Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1AF14559F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgAVNXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbgAVNXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:23:41 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC46205F4;
        Wed, 22 Jan 2020 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699420;
        bh=lCuu7sL1e/H2b4/0FmtQ9bkOCclElc5kZCwTiINyETA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4u92QJ31H6LN0R8oUacs+f3ib3n9EkZ7B/65G/u30mYTkporCgJTwGgDLrKlC2Dr
         Ok824KjtYcfyVUdeBU8gMBGeE8SD2cZnAy1n9XO2pqtOP3qCdBkfs2sYETCwk6xB3S
         VW240ovV9ZKLkIq/6tPy0UtRcifae4np+D1X4Z0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 112/222] bpf: Sockmap/tls, msg_push_data may leave end mark in place
Date:   Wed, 22 Jan 2020 10:28:18 +0100
Message-Id: <20200122092841.753381385@linuxfoundation.org>
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

commit cf21e9ba1eb86c9333ca5b05b2f1cc94021bcaef upstream.

Leaving an incorrect end mark in place when passing to crypto
layer will cause crypto layer to stop processing data before
all data is encrypted. To fix clear the end mark on push
data instead of expecting users of the helper to clear the
mark value after the fact.

This happens when we push data into the middle of a skmsg and
have room for it so we don't do a set of copies that already
clear the end flag.

Fixes: 6fff607e2f14b ("bpf: sk_msg program helper bpf_msg_push_data")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20200111061206.8028-6-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/filter.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2415,6 +2415,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_
 
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);
+		sg_unmark_end(&rsge);
 		sk_msg_iter_next(msg, end);
 	}
 


