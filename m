Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B6C420E84
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhJDNZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237024AbhJDNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D2161C11;
        Mon,  4 Oct 2021 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353026;
        bh=H/EPqUtZHIEDKO9oV35T1Bf3435LGktlH6aQfh5KD0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9LulAlBHQOfY0REebGNzrHTxc/uL+SgxUMav/AgwGe3h5gG8xZdZZfKh1GVRkd42
         LiUppWGwpVspa2c3+5o8HMnnt5IeWeUvFLP79exItkX5gW+Oi++JJTDskGUBSetqx9
         kDpkeHqbCSwps+qnfTjlwI/rqgmPOellVFQpa5r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 18/93] KVM: x86: nSVM: dont copy virt_ext from vmcb12
Date:   Mon,  4 Oct 2021 14:52:16 +0200
Message-Id: <20211004125035.178726400@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit faf6b755629627f19feafa75b32e81cd7738f12d upstream.

These field correspond to features that we don't expose yet to L2

While currently there are no CVE worthy features in this field,
if AMD adds more features to this field, that could allow guest
escapes similar to CVE-2021-3653 and CVE-2021-3656.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210914154825.104886-6-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -447,7 +447,6 @@ static void nested_prepare_vmcb_control(
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
 		(svm->nested.hsave->control.int_ctl & int_ctl_vmcb01_bits);
 
-	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
 	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
 	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;


