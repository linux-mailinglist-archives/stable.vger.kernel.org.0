Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437A2FC2A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfD3PGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:06:19 -0400
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25409 "EHLO
        sender-pp-o92.zoho.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725906AbfD3PGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 11:06:19 -0400
X-Greylist: delayed 2708 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 11:06:19 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1556634062; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=FekgT0yaoJTctRbEqW1SPQP+2EyMyVLnIk+jFPDwuwkRFyZeiaGlVsQcfK6kKGs5srwRz46tPuJTfeBB5ltW72KkBhuFXkzNQDvgSjM0mVBgJQsYo2H8uK5xcvsm+BN4x+HhaLIkMW8hIICe/8VIP2W/sA4cZ34YKBHTmvPHK4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1556634062; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=K5BzyEqf24wVQe40Lud47ZVAeu3TYSMvcKqwIoHWhsQ=; 
        b=DZxtfUb3RAvB/+5+saUGnk5PJyXA0E6E8QZK1AbGNJ8xT1J9C0vZFeAtBTt75MDLTllPW37bKv1VppsawEuWWLQvs643BHHMwo/DaRaQYYoVrKXwHyzNgcy7RbX1SAxiJT4asdDvCfAENeo+ETzLSoW3GI5DWi4afJwLgVor4d4=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=strongbox8@zoho.com;
        dmarc=pass header.from=<strongbox8@zoho.com> header.from=<strongbox8@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=from:to:cc:message-id:subject:date:mime-version:content-type; 
  b=LO7DJBJFTxshes/zPiT1qmQZpcE/5taXzgE75P3UwqIHDKWzcLRxKmA+DeDIx3BgVzKwkYAQqKhB
    DnMimChn5Do1y1RKMT8yWmhPBC6dp25PwbyQD8SpWbKsEO6wR8xR  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1556634062;
        s=default; d=zoho.com; i=strongbox8@zoho.com;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1352; bh=K5BzyEqf24wVQe40Lud47ZVAeu3TYSMvcKqwIoHWhsQ=;
        b=l7eqyrh568GmCaIvp38TDBukNpIyFXmgwrAMPIfQb4aFP3f2HY3vY6ZVZKIb7lIM
        PMu12LiE/W31YzMWXRANWwGBrC+1HACSfDBaXVT/8K8kbFwAsCLKsldZ41MKX6vv/lm
        uFHAmaPVWdRJ6IvVHImfQ76dz1xdmDapdp3pEbs8=
Received: from archlinux.localdomain (180.97.206.46 [180.97.206.46]) by mx.zohomail.com
        with SMTPS id 1556634059124564.1015564377054; Tue, 30 Apr 2019 07:20:59 -0700 (PDT)
From:   Perr Zhang <strongbox8@zoho.com>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, stable@vger.kernel.org,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20190430142056.3133-1-strongbox8@zoho.com>
Subject: [PATCH] KVM: x86: revert the order of calls in kvm_fast_pio()
Date:   Tue, 30 Apr 2019 22:20:56 +0800
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 45def77ebf79, the order of function calls in kvm_fast_pio()
was changed. This causes that the vm(XP,and also XP's iso img) failed
to boot. This doesn't happen with win10 or ubuntu.

After revert the order, the vm(XP) succeedes to boot. In addition, the
change of calls's order of kvm_fast_pio() in commit 45def77ebf79 has no
obvious reason.

Fixes: 45def77ebf79 ("KVM: x86: update %rip after emulating IO")
Cc: <stable@vger.kernel.org>
Signed-off-by: Perr Zhang <strongbox8@zoho.com>
---
 arch/x86/kvm/x86.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a0d1fc80ac5a..248753cb94a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6610,13 +6610,12 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, i=
nt size,
=20
 int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int=
 in)
 {
-=09int ret;
+=09int ret =3D kvm_skip_emulated_instruction(vcpu);
=20
 =09if (in)
-=09=09ret =3D kvm_fast_pio_in(vcpu, size, port);
+=09=09return kvm_fast_pio_in(vcpu, size, port) && ret;
 =09else
-=09=09ret =3D kvm_fast_pio_out(vcpu, size, port);
-=09return ret && kvm_skip_emulated_instruction(vcpu);
+=09=09return kvm_fast_pio_out(vcpu, size, port) && ret;
 }
 EXPORT_SYMBOL_GPL(kvm_fast_pio);
=20
--=20
2.21.0



