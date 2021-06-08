Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D035B3A01AA
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhFHSzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhFHSwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 674F86147F;
        Tue,  8 Jun 2021 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177619;
        bh=Sl3LgPsHXAwzziHw42C4BhP3eSx1q5+MQHXdHP1UgMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbBmY5Fpyj9jrIhJzZkTytNi+urH5+V8eNiEqjpDt7i2deK/OM2dYc41nLATzaosa
         /3N+fj9dKax4LeZ0+hBfaIMJIN5mSSgFY6CphjHM2qRbuhS0bNI1BkN46hCwSxBXOD
         q+G8WZRaWUUueWX9c8fmtEha0CmiZ1w/iGB7zQpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/137] bpf: Simplify cases in bpf_base_func_proto
Date:   Tue,  8 Jun 2021 20:26:17 +0200
Message-Id: <20210608175943.669860800@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit 61ca36c8c4eb3bae35a285b1ae18c514cde65439 ]

!perfmon_capable() is checked before the last switch(func_id) in
bpf_base_func_proto. Thus, the cases BPF_FUNC_trace_printk and
BPF_FUNC_snprintf_btf can be moved to that last switch(func_id) to omit
the inline !perfmon_capable() checks.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210127174615.3038-1-tklauser@distanz.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index c489430cac78..d0fc091d2ab4 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -707,14 +707,6 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_spin_lock_proto;
 	case BPF_FUNC_spin_unlock:
 		return &bpf_spin_unlock_proto;
-	case BPF_FUNC_trace_printk:
-		if (!perfmon_capable())
-			return NULL;
-		return bpf_get_trace_printk_proto();
-	case BPF_FUNC_snprintf_btf:
-		if (!perfmon_capable())
-			return NULL;
-		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_per_cpu_ptr:
@@ -729,6 +721,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return NULL;
 
 	switch (func_id) {
+	case BPF_FUNC_trace_printk:
+		return bpf_get_trace_printk_proto();
 	case BPF_FUNC_get_current_task:
 		return &bpf_get_current_task_proto;
 	case BPF_FUNC_probe_read_user:
@@ -739,6 +733,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
 		return &bpf_probe_read_kernel_str_proto;
+	case BPF_FUNC_snprintf_btf:
+		return &bpf_snprintf_btf_proto;
 	default:
 		return NULL;
 	}
-- 
2.30.2



