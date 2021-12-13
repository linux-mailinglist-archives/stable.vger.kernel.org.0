Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B00247297D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbhLMKVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245109AbhLMKTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:19:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D391C07E5E9;
        Mon, 13 Dec 2021 01:57:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8DF7B80E1D;
        Mon, 13 Dec 2021 09:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31202C34600;
        Mon, 13 Dec 2021 09:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389452;
        bh=sIRIkcoDgPuhl7ymA/dryZJax2cFiAE5VUx8RTfu31g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGWhCnHxlFGWdf6GS46Br2mhmpftJO1KLIyI35TWqZX4XGQRAI+TfhsnUWBB66A9y
         w3zY8jKbqQjOQyTH87TLKIFBhk1VycgHSGTSATXAdAwASyEUTTa9mgJid7kp+yjIcZ
         OZ57ei4SELnwIvsHlQTQv81GHqzPH32IBKEBvOaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 057/171] KVM: x86: Dont WARN if userspace mucks with RCX during string I/O exit
Date:   Mon, 13 Dec 2021 10:29:32 +0100
Message-Id: <20211213092946.997574366@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d07898eaf39909806128caccb6ebd922ee3edd69 upstream.

Replace a WARN with a comment to call out that userspace can modify RCX
during an exit to userspace to handle string I/O.  KVM doesn't actually
support changing the rep count during an exit, i.e. the scenario can be
ignored, but the WARN needs to go as it's trivial to trigger from
userspace.

Cc: stable@vger.kernel.org
Fixes: 3b27de271839 ("KVM: x86: split the two parts of emulator_pio_in")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211025201311.1881846-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7021,7 +7021,13 @@ static int emulator_pio_in(struct kvm_vc
 			   unsigned short port, void *val, unsigned int count)
 {
 	if (vcpu->arch.pio.count) {
-		/* Complete previous iteration.  */
+		/*
+		 * Complete a previous iteration that required userspace I/O.
+		 * Note, @count isn't guaranteed to match pio.count as userspace
+		 * can modify ECX before rerunning the vCPU.  Ignore any such
+		 * shenanigans as KVM doesn't support modifying the rep count,
+		 * and the emulator ensures @count doesn't overflow the buffer.
+		 */
 	} else {
 		int r = __emulator_pio_in(vcpu, size, port, count);
 		if (!r)
@@ -7030,7 +7036,6 @@ static int emulator_pio_in(struct kvm_vc
 		/* Results already available, fall through.  */
 	}
 
-	WARN_ON(count != vcpu->arch.pio.count);
 	complete_emulator_pio_in(vcpu, val);
 	return 1;
 }


