Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F02FC73
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfD3PJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:09:06 -0400
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25419 "EHLO
        sender-pp-o92.zoho.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725942AbfD3PJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 11:09:06 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1556634240; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=Xghw7sO9q2Xyheo0Rl3GjNu4r7FElFKYUG3aLj7NE1qb+J9REVqgLp5b1X1oycGVQTWMf6Dws3XjK5aMyYwN53UEVhsU8JsndurqSrFRychgDwTWJR/ol1cTWIj7zYz1uhy8WndIiV+sbNIHy14SjFzQauptwegenDwmRrsv+FA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1556634240; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=K5BzyEqf24wVQe40Lud47ZVAeu3TYSMvcKqwIoHWhsQ=; 
        b=j6o4RpIF5oY+AVv64AUy7gT85GaSRX+nAswAWfHQOXS36yBf9+dJ5MGJtMYeffQyNZ9mYFgfVNd+vKBtFlwVt+wcEqxk92mlghvJKTcDO0jGDbfpOiw/VA6F6qUTKf4hgt5dv7b3Ct/vR0X2dQdRv/IW0E5r3WRD0yn1gQHrVk0=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=strongbox8@zoho.com;
        dmarc=pass header.from=<strongbox8@zoho.com> header.from=<strongbox8@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=from:to:cc:message-id:subject:date:mime-version:content-type; 
  b=uNgRJxNlPJVGjUs4kxP7VYqyV08Oo9s9qK0kmQUmzz7LlZTnatJF/537hcL0hLCXV0rvtbEol2+J
    +/DrrRM4jEp7CfpDgth3I6r3pHJuafpig1Hu5HbiUh84Kgg45dmi  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1556634240;
        s=default; d=zoho.com; i=strongbox8@zoho.com;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1352; bh=K5BzyEqf24wVQe40Lud47ZVAeu3TYSMvcKqwIoHWhsQ=;
        b=c1KboL2NZwqHHg5YkxtqQ5OInjg682X3PQ5T4yKcV1yVa92NTtCabq5oEVN08EMf
        YRfaaiYex0hygj4u7EOI9MmJPv1XTlzUga7saa9BD5Q0tfNZctkNyLvWwFD77tAWPaY
        o3Iek0C88KY8eEH6X7I/hGCl/9ysIYlOpqpWG5HA=
Received: from archlinux.localdomain (106.2.239.6 [106.2.239.6]) by mx.zohomail.com
        with SMTPS id 1556634239308968.9743923236803; Tue, 30 Apr 2019 07:23:59 -0700 (PDT)
From:   Perr Zhang <strongbox8@zoho.com>
To:     strongbox8@zoho.com
Cc:     stable@vger.kernel.org
Message-ID: <20190430142403.3344-1-strongbox8@zoho.com>
Subject: [PATCH] KVM: x86: revert the order of calls in kvm_fast_pio()
Date:   Tue, 30 Apr 2019 22:24:03 +0800
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



