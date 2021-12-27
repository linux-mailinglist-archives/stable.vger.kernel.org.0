Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE247FEF1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbhL0Pd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39078 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbhL0Pdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B52BCCE10B3;
        Mon, 27 Dec 2021 15:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F08CC36AEB;
        Mon, 27 Dec 2021 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619213;
        bh=JCRgNUks6EAzyTz5m67NWn7jD4Hmfwapl8IQRx+GFA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krA+lAItJ9eXHHvpFh9Juak7mXBA1w7PPlQxuTwKhyNagCC/A+8x831pPZIV0mA7c
         zW2BtMUMbns5TpdhxpQew8yoZ7kzBnN12yOLlbwWkSa0mIgg2ttGhD4+5pWErozvBg
         LrnsLskhbBwt8we7qPJqlORKeVrN2CsNeipuv7iQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 32/38] KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state
Date:   Mon, 27 Dec 2021 16:31:09 +0100
Message-Id: <20211227151320.454785031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
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
@@ -2019,8 +2019,12 @@
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


