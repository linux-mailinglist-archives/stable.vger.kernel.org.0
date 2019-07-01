Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FCFFC78
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfD3PKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:10:00 -0400
Received: from sender4-pp-o95.zoho.com ([136.143.188.95]:25596 "EHLO
        sender4-pp-o95.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3PKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 11:10:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1556634273; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=mfk8MAVDYBh5D+t5N8zXPT0V16NvwKIXypPd7J9iRimMxTcSSW2Ikd9TZ+V+L2hQlqrg+Pt6FcgF45MQyuT0Y/qjWmX+efWN89xMaaCbqbkcGK8zQm3xit8oDHdDmF8RdREAtRVmhZngSjinxrGE6Edlb858ivdJrEd2qiTPqes=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1556634273; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=K5BzyEqf24wVQe40Lud47ZVAeu3TYSMvcKqwIoHWhsQ=; 
        b=Ppn4+dJJOcgnoJ2/7Euo8xzz+czKtorAVcqEcHVW1CeND9KZrRqtgYc4NnmFWn42LHeI5GslDN6ijPXp17CdtsPSsGn+Slthn4pCTTPMXg2gYOUQTaWPjftVzeNsyZniTnfXZNkt66ogjZOE3CCiUagHoVg9CwNwMhnzzVxOgsg=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=strongbox8@zoho.com;
        dmarc=pass header.from=<strongbox8@zoho.com> header.from=<strongbox8@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=from:to:cc:message-id:subject:date:mime-version:content-type; 
  b=g7f/SM0l7YPsKfWf4XXY773vIoWNkXScXKdqUEoq20PKHtZEgX0ZZNaI3qThm4WFY7hOy7MwzEZ6
    ioMWF0o5TcuzzfIj5P3eIVMKysK20ZrEBjqaN5xiruYhC2vLzSXI  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1556634273;
        s=default; d=zoho.com; i=strongbox8@zoho.com;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1352; bh=K5BzyEqf24wVQe40Lud47ZVAeu3TYSMvcKqwIoHWhsQ=;
        b=ZeaFanAGGV6ujArpeT3QkTx5zPIBAZyNrJgK2crNDcvIYe+myx6btSG/KfAdeUf2
        0dML8vYXabECniOM2AreFsu25VySbOuTmfuni6/6H2rDxIf/nVlRXMSr+X6vPFc+V6T
        lufqWfAwMYNwJcPJUcBBNSLdNC/xu8zjKWFpkIhE=
Received: from archlinux.localdomain (106.2.239.74 [106.2.239.74]) by mx.zohomail.com
        with SMTPS id 1556634269644614.490180315079; Tue, 30 Apr 2019 07:24:29 -0700 (PDT)
From:   Perr Zhang <strongbox8@zoho.com>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, stable@vger.kernel.org,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20190430142423.3393-1-strongbox8@zoho.com>
Subject: [PATCH] KVM: x86: revert the order of calls in kvm_fast_pio()
Date:   Tue, 30 Apr 2019 22:24:23 +0800
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



