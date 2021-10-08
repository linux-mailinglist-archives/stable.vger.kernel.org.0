Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED51426900
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbhJHLdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240877AbhJHLcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE94610E7;
        Fri,  8 Oct 2021 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692613;
        bh=0C6W9SS6dd73z7EPUbhKn1NEfkcIH093yC9t/+PUAUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umG0zKTx5e4i+OFEcI8rmJ6FXBu5WOZ5dRSXGBwqdONT6iZwQg3Qqp0pYfE9teIs6
         SNGUf3lSfc5u9VI1wz1smYUVlObRlCO/IbGTjSv4bfBj3MQfEVMK5XjNIxDYpcsJlF
         Xohe3wLWX42dLqfiSH1J0hADeejM/XDp3xew6mUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/16] KVM: do not shrink halt_poll_ns below grow_start
Date:   Fri,  8 Oct 2021 13:28:02 +0200
Message-Id: <20211008112715.875188234@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
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
index 77f84cbca740..f31976010622 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2470,15 +2470,19 @@ out:
 
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



