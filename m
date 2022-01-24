Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D532349A9AD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356880AbiAYD0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387203AbiAXVDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501C1C06B5AE;
        Mon, 24 Jan 2022 12:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CF80B811FB;
        Mon, 24 Jan 2022 20:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1741BC340E8;
        Mon, 24 Jan 2022 20:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054628;
        bh=C0SHw/HBGJeYO40tcsni0/1HVx1c5uqo7CZO59eKrpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tavopEPZxX4z99dK4v3mfaOUtCnxcEmA51k8qw+ydS6kl4Uy+q14mfHN/SJ7kAuT1
         YN0LKHL6lea8gMdYDvjQuPmBpQ/jLeu7Ve7Dz4N5WyXk/aK+F0Y5D4vFWM+UCRDL3J
         kREggO16RP+OxpsW99S/fVUiU4nAabqkY+utDdVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Xiangyang Zhang <xyz.sun.ok@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 451/563] tracing/kprobes: nmissed not showed correctly for kretprobe
Date:   Mon, 24 Jan 2022 19:43:36 +0100
Message-Id: <20220124184040.047274925@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiangyang Zhang <xyz.sun.ok@gmail.com>

commit dfea08a2116fe327f79d8f4d4b2cf6e0c88be11f upstream.

The 'nmissed' column of the 'kprobe_profile' file for kretprobe is
not showed correctly, kretprobe can be skipped by two reasons,
shortage of kretprobe_instance which is counted by tk->rp.nmissed,
and kprobe itself is missed by some reason, so to show the sum.

Link: https://lkml.kernel.org/r/20220107150242.5019-1-xyz.sun.ok@gmail.com

Cc: stable@vger.kernel.org
Fixes: 4a846b443b4e ("tracing/kprobes: Cleanup kprobe tracer code")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1183,15 +1183,18 @@ static int probes_profile_seq_show(struc
 {
 	struct dyn_event *ev = v;
 	struct trace_kprobe *tk;
+	unsigned long nmissed;
 
 	if (!is_trace_kprobe(ev))
 		return 0;
 
 	tk = to_trace_kprobe(ev);
+	nmissed = trace_kprobe_is_return(tk) ?
+		tk->rp.kp.nmissed + tk->rp.nmissed : tk->rp.kp.nmissed;
 	seq_printf(m, "  %-44s %15lu %15lu\n",
 		   trace_probe_name(&tk->tp),
 		   trace_kprobe_nhit(tk),
-		   tk->rp.kp.nmissed);
+		   nmissed);
 
 	return 0;
 }


