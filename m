Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE7D2AB9F8
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733155AbgKINOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733149AbgKINO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC71220789;
        Mon,  9 Nov 2020 13:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927668;
        bh=VaIpHISW1bHeg0YK+bGy4dB54g61d2RgvK3sQTLnD6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfYuJOahE1fbIShIubfDzwK6POVkcxBipckNONQXzhmqdRDfwA+vhjbnW4IGT4Cwp
         iZhACYpyyuY2bET0VoAH6h8w50BezpIMnj+B8HbQykDNYiu7PJ32KSCjCs0SoxHn7a
         bAb+8Au5uuZd/nCELhX9yaVfE89gD35mM8LWp8zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 36/85] ftrace: Fix recursion check for NMI test
Date:   Mon,  9 Nov 2020 13:55:33 +0100
Message-Id: <20201109125024.330189877@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit ee11b93f95eabdf8198edd4668bf9102e7248270 upstream.

The code that checks recursion will work to only do the recursion check once
if there's nested checks. The top one will do the check, the other nested
checks will see recursion was already checked and return zero for its "bit".
On the return side, nothing will be done if the "bit" is zero.

The problem is that zero is returned for the "good" bit when in NMI context.
This will set the bit for NMIs making it look like *all* NMI tracing is
recursing, and prevent tracing of anything in NMI context!

The simple fix is to return "bit + 1" and subtract that bit on the end to
get the real bit.

Cc: stable@vger.kernel.org
Fixes: edc15cafcbfa3 ("tracing: Avoid unnecessary multiple recursion checks")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -653,7 +653,7 @@ static __always_inline int trace_test_an
 	current->trace_recursion = val;
 	barrier();
 
-	return bit;
+	return bit + 1;
 }
 
 static __always_inline void trace_clear_recursion(int bit)
@@ -663,6 +663,7 @@ static __always_inline void trace_clear_
 	if (!bit)
 		return;
 
+	bit--;
 	bit = 1 << bit;
 	val &= ~bit;
 


