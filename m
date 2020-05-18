Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDE1D86AC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgERS00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgERRpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC87320657;
        Mon, 18 May 2020 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823920;
        bh=5+gaK2ZjATYYSKkQ1x1eK4JtR4CVS+bhoUsM5ty/0yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0r2VEzoqJB2e0Qb+nwinlpOFADXSg21JJ7rUbrpkzQNSKfhhayWzt+sqcWwiYc5w
         KUzJM6rU7ShJGnXufnslYfv3NP/U0Yd2TMk1rIocQX+eJd7uRhWnv5iQUkw/52i/Ff
         +eJgu6j6Nr9L5aL3t1dzXnMA69WX5O25to9o6Ars=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jue Wang <juew@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 89/90] KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce
Date:   Mon, 18 May 2020 19:37:07 +0200
Message-Id: <20200518173509.157337939@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit c4e0e4ab4cf3ec2b3f0b628ead108d677644ebd9 upstream.

Bank_num is a one-based count of banks, not a zero-based index. It
overflows the allocated space only when strictly greater than
KVM_MAX_MCE_BANKS.

Fixes: a9e38c3e01ad ("KVM: x86: Catch potential overrun in MCE setup")
Signed-off-by: Jue Wang <juew@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Message-Id: <20200511225616.19557-1-jmattson@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3128,7 +3128,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(
 	unsigned bank_num = mcg_cap & 0xff, bank;
 
 	r = -EINVAL;
-	if (!bank_num || bank_num >= KVM_MAX_MCE_BANKS)
+	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
 		goto out;
 	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
 		goto out;


