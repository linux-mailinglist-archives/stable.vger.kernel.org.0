Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C33238365F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244985AbhEQPbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244095AbhEQP3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4694861CBC;
        Mon, 17 May 2021 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262249;
        bh=hGFvCicMJSd+OXQXSjAVDr5lHiJ4sa10UlQ0LN+CYRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLblzrjt/uvoO4nXHeWRlWltcJkx+kdFMu4U85ygofWQhKLgIXqdah1ZduSEruu7k
         QyeoXMsqurjgOGknlEmcCgDMbTmHCt+TXaxEvQ+ZdVhehpP08jQsh66aYWNKyFNl7E
         mNXgZ/z/KN2H2ftrQXYDeEoc49XqU2TmTgQS3Gc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 5.11 249/329] kvm: exit halt polling on need_resched() as well
Date:   Mon, 17 May 2021 16:02:40 +0200
Message-Id: <20210517140310.537115832@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Segall <bsegall@google.com>

commit 262de4102c7bb8e59f26a967a8ffe8cce85cc537 upstream.

single_task_running() is usually more general than need_resched()
but CFS_BANDWIDTH throttling will use resched_task() when there
is just one task to get the task to block. This was causing
long-need_resched warnings and was likely allowing VMs to
overrun their quota when halt polling.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Message-Id: <20210429162233.116849-1-venkateshs@chromium.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2814,7 +2814,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcp
 				goto out;
 			}
 			poll_end = cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (single_task_running() && !need_resched() &&
+			 ktime_before(cur, stop));
 	}
 
 	prepare_to_rcuwait(&vcpu->wait);


