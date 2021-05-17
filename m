Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDBA3832A9
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbhEQOuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240356AbhEQOsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84AA8613C5;
        Mon, 17 May 2021 14:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261343;
        bh=wrx2QNvDWbAZD5cd2brIHG1ui/RvakMqdeTrMAp0GUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op/4CjmtRuLsWn2rkI2QW9rto03oND8WW53pq6zDXjpOoGhQMkT1si02JiE3Tq62M
         SbjJOM1YENYpmnm0ltq5kwNHQVGnKT5DOHPW1Fk08ALftpCtHkdw+avpAGrKuH8rF4
         WY/j2kaFPC5hVH5S2CaWVmRN53JSAdMkvrOIgV1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 010/289] kvm: Cap halt polling at kvm->max_halt_poll_ns
Date:   Mon, 17 May 2021 15:58:55 +0200
Message-Id: <20210517140305.525322001@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
@@ -2717,8 +2717,8 @@ static void grow_halt_poll_ns(struct kvm
 	if (val < grow_start)
 		val = grow_start;
 
-	if (val > halt_poll_ns)
-		val = halt_poll_ns;
+	if (val > vcpu->kvm->max_halt_poll_ns)
+		val = vcpu->kvm->max_halt_poll_ns;
 
 	vcpu->halt_poll_ns = val;
 out:


