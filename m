Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC990157B9E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731415AbgBJNbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbgBJMgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CDE20842;
        Mon, 10 Feb 2020 12:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338162;
        bh=IYzxdXsmudUkeoX+3056nzpQ6OHR3iAIkWE89utgMGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbVc5IfCCM9aNLxEh978GfAErBGwKz7BhjTjkOIkDHC7LPLPWFj2s55BUD3+ZxEom
         cICxsIdzfAr86SiWFXDi1EIV2/W8rdyNf2W2a6zvyVFtV2dJGLfltf2xiC8XlUq++1
         6NnhJl6lVU1cWxZO0WFDqvfV+FHN0YWVzH9Nd4MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 138/195] x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
Date:   Mon, 10 Feb 2020 04:33:16 -0800
Message-Id: <20200210122318.794552975@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 8c6de56a42e0c657955e12b882a81ef07d1d073e upstream.

kvm_steal_time_set_preempted() may accidentally clear KVM_VCPU_FLUSH_TLB
bit if it is called more than once while VCPU is preempted.

This is part of CVE-2019-3016.

(This bug was also independently discovered by Jim Mattson
<jmattson@google.com>)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3244,6 +3244,9 @@ static void kvm_steal_time_set_preempted
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
+	if (vcpu->arch.st.steal.preempted)
+		return;
+
 	vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,


