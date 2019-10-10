Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A836D22EF
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbfJJIiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbfJJIiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8765720B7C;
        Thu, 10 Oct 2019 08:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696683;
        bh=KXPIak5gVB/545cBYDyectDUfIbRwx5aoYc83wnV82M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veGtfb9rtrnT1tUWQqZekBHuDSBpYxwdF8/cgSDFoQzhZYJktxpdYQNaEOUeb8GvO
         10t7LsW+S1317v9u05JEOU0blS35xC+ISW4hHftosjGtb68DYXpxz8nkuyf35xZzZT
         rtXjaWs6FFtBZlx5M/xW9VYzelSAfWTcocCIdFpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 5.3 015/148] KVM: PPC: Book3S HV: Dont lose pending doorbell request on migration on P9
Date:   Thu, 10 Oct 2019 10:34:36 +0200
Message-Id: <20191010083612.025631289@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

commit ff42df49e75f053a8a6b4c2533100cdcc23afe69 upstream.

On POWER9, when userspace reads the value of the DPDES register on a
vCPU, it is possible for 0 to be returned although there is a doorbell
interrupt pending for the vCPU.  This can lead to a doorbell interrupt
being lost across migration.  If the guest kernel uses doorbell
interrupts for IPIs, then it could malfunction because of the lost
interrupt.

This happens because a newly-generated doorbell interrupt is signalled
by setting vcpu->arch.doorbell_request to 1; the DPDES value in
vcpu->arch.vcore->dpdes is not updated, because it can only be updated
when holding the vcpu mutex, in order to avoid races.

To fix this, we OR in vcpu->arch.doorbell_request when reading the
DPDES value.

Cc: stable@vger.kernel.org # v4.13+
Fixes: 579006944e0d ("KVM: PPC: Book3S HV: Virtualize doorbell facility on POWER9")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1678,7 +1678,14 @@ static int kvmppc_get_one_reg_hv(struct
 		*val = get_reg_val(id, vcpu->arch.pspb);
 		break;
 	case KVM_REG_PPC_DPDES:
-		*val = get_reg_val(id, vcpu->arch.vcore->dpdes);
+		/*
+		 * On POWER9, where we are emulating msgsndp etc.,
+		 * we return 1 bit for each vcpu, which can come from
+		 * either vcore->dpdes or doorbell_request.
+		 * On POWER8, doorbell_request is 0.
+		 */
+		*val = get_reg_val(id, vcpu->arch.vcore->dpdes |
+				   vcpu->arch.doorbell_request);
 		break;
 	case KVM_REG_PPC_VTB:
 		*val = get_reg_val(id, vcpu->arch.vcore->vtb);


