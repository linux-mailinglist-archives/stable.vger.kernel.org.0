Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0338310D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbhEQOd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239405AbhEQObw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F21B960720;
        Mon, 17 May 2021 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260948;
        bh=4YbuxYWZXLqmOhoZbHuVpCt5pHBSQsjnP+PfCImFYhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0J8Vp+72n0kmUo1tC4/dhj7u0xH57kFBzVZJjw+zZ46gBya0LnMb1O/d063U1ATGu
         4gqDZIYjq8CFVMhp02KCnb4AWvgrBZyzJ8Serdx+AaoWZg40FCxBB/vlMInINQmXMJ
         LYmfPNv0Ta8h2VCLFNTEw6hkPmZjUWy10e3QEcR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 5.12 273/363] kvm: exit halt polling on need_resched() as well
Date:   Mon, 17 May 2021 16:02:19 +0200
Message-Id: <20210517140311.846094465@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
@@ -2838,7 +2838,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcp
 				goto out;
 			}
 			poll_end = cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (single_task_running() && !need_resched() &&
+			 ktime_before(cur, stop));
 	}
 
 	prepare_to_rcuwait(&vcpu->wait);


