Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C8171D9C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgB0OWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389457AbgB0OQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:16:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EF220578;
        Thu, 27 Feb 2020 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812973;
        bh=JlbqrfUdpu7uk8u0aO5BIhvoEvR9l6eiTJyLp5+Xs20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhCUpOwiPh1hA+hPMLnhPxIOOQ5DX1ji1xPpQSBZ37uosmO3RFmgqyjR2hRxf0V9n
         a7ZnlNWhxAZ5SrM5ZuEdKhKz0ETbiSHhGMWOWkRaPgAmyyoJZUmWRWpKZm3Ss04sJp
         KnvSeTPVkZuGrE+s2Zici+hJ4qWjwdUfXVMPM3GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 087/150] KVM: nVMX: Dont emulate instructions in guest mode
Date:   Thu, 27 Feb 2020 14:37:04 +0100
Message-Id: <20200227132245.682892470@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 07721feee46b4b248402133228235318199b05ec upstream.

vmx_check_intercept is not yet fully implemented. To avoid emulating
instructions disallowed by the L1 hypervisor, refuse to emulate
instructions by default.

Cc: stable@vger.kernel.org
[Made commit, added commit msg - Oliver]
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7165,7 +7165,7 @@ static int vmx_check_intercept(struct kv
 	}
 
 	/* TODO: check more intercepts... */
-	return X86EMUL_CONTINUE;
+	return X86EMUL_UNHANDLEABLE;
 }
 
 #ifdef CONFIG_X86_64


