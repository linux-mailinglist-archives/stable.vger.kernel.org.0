Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113C81CAF4C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgEHNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbgEHMom (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A1512145D;
        Fri,  8 May 2020 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941882;
        bh=5qwJ1HXduhShhqO66V2xRuZoNmsgUkmpW5HiZw1jGHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0zOpcfs8wvyvdfWO888M0Ib4t/7wRE0MxS8fRcHBPKkkhah6aOjsDKgs8X5RnNv3
         UHUZ67/UY5dhMnPaP3UVCmnjKCO2AoF9BEykWQe+TaeKSrs7dGZGBqnDzUvMPrsSOr
         eaLpegonuDfQl+L2jCCrgmQQrt2zYiEubnEicjrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 210/312] bpf, trace: check event type in bpf_perf_event_read
Date:   Fri,  8 May 2020 14:33:21 +0200
Message-Id: <20200508123139.179064292@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@fb.com>

commit ad572d174787daa59e24b8b5c83028c09cdb5ddb upstream.

similar to bpf_perf_event_output() the bpf_perf_event_read() helper
needs to check the type of the perf_event before reading the counter.

Fixes: a43eec304259 ("bpf: introduce bpf_perf_event_output() helper")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/bpf_trace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -206,6 +206,10 @@ static u64 bpf_perf_event_read(u64 r1, u
 	    event->pmu->count)
 		return -EINVAL;
 
+	if (unlikely(event->attr.type != PERF_TYPE_HARDWARE &&
+		     event->attr.type != PERF_TYPE_RAW))
+		return -EINVAL;
+
 	/*
 	 * we don't know if the function is run successfully by the
 	 * return value. It can be judged in other places, such as


