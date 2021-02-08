Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69631368E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhBHPMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230417AbhBHPIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:08:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB92E64EB8;
        Mon,  8 Feb 2021 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796772;
        bh=CislfrCJDfHTo9CTkhei2y+/rYz2DoPL3d30oLssA3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KommwNPu88a6sYzY1vfUe1RnCLOPmcl/LphqJk5NQtCNO+mnIBdcTLV+9LnCDPoJB
         KyNX7YOAJ8gS4XShnRXxp1l5QUu8sFl8p+qmlyJsQysj1IEbY2HWfzSMy705kpD5Gn
         0zvfcx3ca2qLnGlMNm0GkU+i3ajy4w7ixY2+aeo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Cheng Jian <cj.chengjian@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 15/30] kretprobe: Avoid re-registration of the same kretprobe earlier
Date:   Mon,  8 Feb 2021 16:01:01 +0100
Message-Id: <20210208145805.863520126@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

commit 0188b87899ffc4a1d36a0badbe77d56c92fd91dc upstream.

Our system encountered a re-init error when re-registering same kretprobe,
where the kretprobe_instance in rp->free_instances is illegally accessed
after re-init.

Implementation to avoid re-registration has been introduced for kprobe
before, but lags for register_kretprobe(). We must check if kprobe has
been re-registered before re-initializing kretprobe, otherwise it will
destroy the data struct of kretprobe registered, which can lead to memory
leak, system crash, also some unexpected behaviors.

We use check_kprobe_rereg() to check if kprobe has been re-registered
before running register_kretprobe()'s body, for giving a warning message
and terminate registration process.

Link: https://lkml.kernel.org/r/20210128124427.2031088-1-bobo.shaobowang@huawei.com

Cc: stable@vger.kernel.org
Fixes: 1f0ab40976460 ("kprobes: Prevent re-registration of the same kprobe")
[ The above commit should have been done for kretprobes too ]
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1989,6 +1989,10 @@ int register_kretprobe(struct kretprobe
 	if (!kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset))
 		return -EINVAL;
 
+	/* If only rp->kp.addr is specified, check reregistering kprobes */
+	if (rp->kp.addr && check_kprobe_rereg(&rp->kp))
+		return -EINVAL;
+
 	if (kretprobe_blacklist_size) {
 		addr = kprobe_addr(&rp->kp);
 		if (IS_ERR(addr))


