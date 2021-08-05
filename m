Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618ED3E15A3
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 15:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhHEN1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 09:27:38 -0400
Received: from mail.efficios.com ([167.114.26.124]:35262 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhHEN1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 09:27:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6F37B370901;
        Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id JzP46YLb5rOc; Thu,  5 Aug 2021 09:27:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id CF456370459;
        Thu,  5 Aug 2021 09:27:22 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com CF456370459
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1628170042;
        bh=jtV0eyy5OGRjmfLEo93OnurRPMzroe3nrfzjTSNp0Qc=;
        h=From:To:Date:Message-Id;
        b=ghnFTssNirNRDx8cUNY6drI9/0JS35QIGegYGBd9l1jk8aiTQhkFD9zAcDuszPtkh
         JABxPQ/spaQzj6wjjeMPrUKZroSAcK34LeHzSMzgapRZQGAf4kB59ICWk+Qk9EQcn3
         eh3/hyS/AdpPJp005xYVNwEcDfRf2ih07kU7FSlM+xhoR2+LKafa6rhNWL+A2dCvlJ
         cpp6biJYFAvqc7pI45yngwbfNfMaFOAwU0SRLR31G9X8e6FFbzJzMkfddwpJSv3bbL
         NvAQ4M8EHECnULI/5PrVpTPLZpLcfoT6+oJIR0+y441UPXLRUVdAVbGEsjp2XQxk0E
         k1/wF7RhMgm5A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HLSJAf3mlfNf; Thu,  5 Aug 2021 09:27:22 -0400 (EDT)
Received: from localhost.localdomain (173-246-27-5.qc.cable.ebox.net [173.246.27.5])
        by mail.efficios.com (Postfix) with ESMTPSA id 925FD370457;
        Thu,  5 Aug 2021 09:27:22 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/3] tracepoint static call fixes
Date:   Thu,  5 Aug 2021 09:27:14 -0400
Message-Id: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes issues with tracepoint callback function vs data
argument mismatch when back-to-back registrations/unregistrations are
performed.

Those issues were introduced by the tracepoint optimizations using
static_call().

Thanks,

Mathieu

Mathieu Desnoyers (3):
  Fix: tracepoint: static call: compare data on transition from 2->1
    callees
  Fix: tracepoint: static call function vs data state mismatch (v2)
  Fix: tracepoint: rcu get state and cond sync for static call updates
    (v2)

 kernel/tracepoint.c | 159 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 139 insertions(+), 20 deletions(-)

-- 
2.17.1

