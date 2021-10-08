Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FDA4269BD
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbhJHLky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243283AbhJHLjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4582615E6;
        Fri,  8 Oct 2021 11:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692810;
        bh=/g68fCW7EKslGzoBlnuOAln9+zqm7mdEjmeXMxWP0lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uv638qhi68EB/uxcMm1l/5JODBqnB8i5aIJST22mP7TBSGyTEscczcvyfJjKkfDke
         EnpCbEt2XiofbzUl86qlTiGfQo9Eh4/wFagDEJK8WLg4UYzbB4uGmp42xejTTZtmOT
         idYmWDnNgZLzW9xWipZl7QTDBrptxKihPs/KcqnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 41/48] KVM: do not shrink halt_poll_ns below grow_start
Date:   Fri,  8 Oct 2021 13:28:17 +0200
Message-Id: <20211008112721.413969911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit ae232ea460888dc5a8b37e840c553b02521fbf18 ]

grow_halt_poll_ns() ignores values between 0 and
halt_poll_ns_grow_start (10000 by default). However,
when we shrink halt_poll_ns we may fall way below
halt_poll_ns_grow_start and endup with halt_poll_ns
values that don't make a lot of sense: like 1 or 9,
or 19.

VCPU1 trace (halt_poll_ns_shrink equals 2):

VCPU1 grow 10000
VCPU1 shrink 5000
VCPU1 shrink 2500
VCPU1 shrink 1250
VCPU1 shrink 625
VCPU1 shrink 312
VCPU1 shrink 156
VCPU1 shrink 78
VCPU1 shrink 39
VCPU1 shrink 19
VCPU1 shrink 9
VCPU1 shrink 4

Mirror what grow_halt_poll_ns() does and set halt_poll_ns
to 0 as soon as new shrink-ed halt_poll_ns value falls
below halt_poll_ns_grow_start.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210902031100.252080-1-senozhatsky@chromium.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b50dbe269f4b..1a11dcb670a3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3053,15 +3053,19 @@ out:
 
 static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 {
-	unsigned int old, val, shrink;
+	unsigned int old, val, shrink, grow_start;
 
 	old = val = vcpu->halt_poll_ns;
 	shrink = READ_ONCE(halt_poll_ns_shrink);
+	grow_start = READ_ONCE(halt_poll_ns_grow_start);
 	if (shrink == 0)
 		val = 0;
 	else
 		val /= shrink;
 
+	if (val < grow_start)
+		val = 0;
+
 	vcpu->halt_poll_ns = val;
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
 }
-- 
2.33.0



