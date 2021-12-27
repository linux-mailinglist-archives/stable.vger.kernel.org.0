Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720DD47FFF1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbhL0PmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbhL0Pkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC79C0698D0;
        Mon, 27 Dec 2021 07:39:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6DA47CE1070;
        Mon, 27 Dec 2021 15:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E04CC36AE7;
        Mon, 27 Dec 2021 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619551;
        bh=Z4nb6KHfY0hczw55GbtfYWIMO3C47iDBfI+UHPWTVIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcmaIg3s3blw0gERPMLtcBU2KeJH+4sF9LS20KUn2wlYx7oz7swIRZlNNkWIFGVw0
         xk+Lbbtlsk/h3lDSH4iy3/UQpwVoyzJjVOqMWu4ZAiNgyHmEv9dk574mqJEi3cXfL3
         +ht4b0ZEH19G0hJn3Z8xc510ZI5R/YQ9KY7Nj4YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 63/76] KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state
Date:   Mon, 27 Dec 2021 16:31:18 +0100
Message-Id: <20211227151326.874184962@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 0ff29701ffad9a5d5a24344d8b09f3af7b96ffda upstream.

Update the documentation for kvm-intel's emulate_invalid_guest_state to
rectify the description of KVM's default behavior, and to document that
the behavior and thus parameter only applies to L1.

Fixes: a27685c33acc ("KVM: VMX: Emulate invalid guest state by default")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211207193006.120997-4-seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2294,8 +2294,12 @@
 			Default is 1 (enabled)
 
 	kvm-intel.emulate_invalid_guest_state=
-			[KVM,Intel] Enable emulation of invalid guest states
-			Default is 0 (disabled)
+			[KVM,Intel] Disable emulation of invalid guest state.
+			Ignored if kvm-intel.enable_unrestricted_guest=1, as
+			guest state is never invalid for unrestricted guests.
+			This param doesn't apply to nested guests (L2), as KVM
+			never emulates invalid L2 guest state.
+			Default is 1 (enabled)
 
 	kvm-intel.flexpriority=
 			[KVM,Intel] Disable FlexPriority feature (TPR shadow).


