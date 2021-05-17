Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D152A382E53
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbhEQOGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237810AbhEQOF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 724B961221;
        Mon, 17 May 2021 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260281;
        bh=m5LxW08p885Yq4NLdEFRCj/2P/qR3556v3A8SahSzS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AN5x8VDAzUqChVw8mNFisXSZQv1MnShN9/KLS7cWToWkmSDk/JsNDD//EIRQSfa8Z
         IxTyJsBAO+q5RKC9nQiBTDqOeeDaY+w09G5eKMu2BiRLTBHYRxggXkzZfNsLoCMEoa
         n0aIUX0rLUMKFsW0gtrfSuBOaY90W+4vWXIB399c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 011/363] kvm: Cap halt polling at kvm->max_halt_poll_ns
Date:   Mon, 17 May 2021 15:57:57 +0200
Message-Id: <20210517140302.934349093@linuxfoundation.org>
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

From: David Matlack <dmatlack@google.com>

commit 258785ef08b323bddd844b4926a32c2b2045a1b0 upstream.

When growing halt-polling, there is no check that the poll time exceeds
the per-VM limit. It's possible for vcpu->halt_poll_ns to grow past
kvm->max_halt_poll_ns and stay there until a halt which takes longer
than kvm->halt_poll_ns.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
Message-Id: <20210506152442.4010298-1-venkateshs@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2758,8 +2758,8 @@ static void grow_halt_poll_ns(struct kvm
 	if (val < grow_start)
 		val = grow_start;
 
-	if (val > halt_poll_ns)
-		val = halt_poll_ns;
+	if (val > vcpu->kvm->max_halt_poll_ns)
+		val = vcpu->kvm->max_halt_poll_ns;
 
 	vcpu->halt_poll_ns = val;
 out:


