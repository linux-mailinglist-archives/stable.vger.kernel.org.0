Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F75D9E20
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395381AbfJPV4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391375AbfJPV4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:34 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB6521925;
        Wed, 16 Oct 2019 21:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262993;
        bh=vsZnRybb1oRRLje+6QOYMh4wo/50seiDG8wLW8igT9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6DNAJow1l5iHn5rrC8dPUXnuWZHBqt65UOCMPyym2NRIe3pC73P7XlywQQRrvONp
         DrqkDLtonUMo/CbqtNlU/s/3DU3HWMdwSNxR1urJ0RCcmSUBJsXJmzRH3DJWQkz1vc
         IKS0+RVHYNqx81zCJPx94ZaXZiyOQAESdVz76c3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 61/65] tracing/hwlat: Dont ignore outer-loop duration when calculating max_latency
Date:   Wed, 16 Oct 2019 14:51:15 -0700
Message-Id: <20191016214839.826570224@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

commit fc64e4ad80d4b72efce116f87b3174f0b7196f8e upstream.

max_latency is intended to record the maximum ever observed hardware
latency, which may occur in either part of the loop (inner/outer). So
we need to also consider the outer-loop sample when updating
max_latency.

Link: http://lkml.kernel.org/r/157073345463.17189.18124025522664682811.stgit@srivatsa-ubuntu

Fixes: e7c15cd8a113 ("tracing: Added hardware latency tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_hwlat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -258,6 +258,8 @@ static int get_sample(void)
 		/* Keep a running maximum ever recorded hardware latency */
 		if (sample > tr->max_latency)
 			tr->max_latency = sample;
+		if (outer_sample > tr->max_latency)
+			tr->max_latency = outer_sample;
 	}
 
 out:


