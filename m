Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113A0383085
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbhEQO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239434AbhEQO0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7BB961364;
        Mon, 17 May 2021 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260817;
        bh=6ddgKla64uBEGApX7ZIEwioGFErlQV89OSB8CcnYl/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEYtFn8Ygg1of9xe5E6ClRjo2mchZJDCnLLL7sfGlXCDQ0mLNu8t1QXs14yoQrd4u
         Z5e86SevaZOo76B4engz6Jc/5Fhqyw6TQ4/RfJ+0cYIdEb9Su7BN9W0vlyrWdSkrhd
         vrnUEf4PeO2Z3NwwES3ZvfAYkoAK7ZzHBlI6WaWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 011/329] kvm: Cap halt polling at kvm->max_halt_poll_ns
Date:   Mon, 17 May 2021 15:58:42 +0200
Message-Id: <20210517140302.431230811@linuxfoundation.org>
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
@@ -2734,8 +2734,8 @@ static void grow_halt_poll_ns(struct kvm
 	if (val < grow_start)
 		val = grow_start;
 
-	if (val > halt_poll_ns)
-		val = halt_poll_ns;
+	if (val > vcpu->kvm->max_halt_poll_ns)
+		val = vcpu->kvm->max_halt_poll_ns;
 
 	vcpu->halt_poll_ns = val;
 out:


