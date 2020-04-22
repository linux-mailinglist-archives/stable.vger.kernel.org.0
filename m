Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A3D1B4129
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgDVKui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgDVKMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:12:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0EE12070B;
        Wed, 22 Apr 2020 10:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550327;
        bh=FJ5gKHUKWaL00/Yg14OCF+bnaMFYnd2VPJmO5ZS6rt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUdaiFoul6XLZg4SAbv4yUn4lmcUxpGTLVHd0cZyd9u91m/44RimKFNpLLScJsqFj
         AKSCI3Mafgmhw2vMK+/aVDET1wg9ERp/bEUzc6/xXw/LSfUE8sP5BHWDTr3nhXMg9J
         o71I41QjVpqj/aHzUGcmloZpqA/XWjC6e/cx3Y/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 4.14 059/199] KVM: s390: vsie: Fix delivery of addressing exceptions
Date:   Wed, 22 Apr 2020 11:56:25 +0200
Message-Id: <20200422095104.163280364@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 4d4cee96fb7a3cc53702a9be8299bf525be4ee98 upstream.

Whenever we get an -EFAULT, we failed to read in guest 2 physical
address space. Such addressing exceptions are reported via a program
intercept to the nested hypervisor.

We faked the intercept, we have to return to guest 2. Instead, right
now we would be returning -EFAULT from the intercept handler, eventually
crashing the VM.
the correct thing to do is to return 1 as rc == 1 is the internal
representation of "we have to go back into g2".

Addressing exceptions can only happen if the g2->g3 page tables
reference invalid g2 addresses (say, either a table or the final page is
not accessible - so something that basically never happens in sane
environments.

Identified by manual code inspection.

Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200403153050.20569-3-david@redhat.com
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com: fix patch description]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/vsie.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1027,6 +1027,7 @@ static int vsie_run(struct kvm_vcpu *vcp
 		scb_s->iprcc = PGM_ADDRESSING;
 		scb_s->pgmilc = 4;
 		scb_s->gpsw.addr = __rewind_psw(scb_s->gpsw, 4);
+		rc = 1;
 	}
 	return rc;
 }


