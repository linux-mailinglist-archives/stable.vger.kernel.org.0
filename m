Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694FF19C917
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390063AbgDBSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 14:48:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389916AbgDBSsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 14:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585853314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1iTHN+tnT2p+g/fi18lrfKuFFUGCiTi5w5obFOSEB4=;
        b=h1oM8tqPfU5CRPhh2Qt3e3vizTdAifsUg3e1Ggaz8aprdivxAzYXzfwrhrk3FjnMgagmnW
        FYj/HpmqrvkG+O88VzVdSyJ7XmhRs3GsiiHbHocmIYLg4D8JbplUKBMyjRpz2Wkm8hh1zN
        rrFDQ36LMyDpQRLBq3lNl72HYiqEElc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-ggkVwfV3P3KDHLgJNeELUA-1; Thu, 02 Apr 2020 14:48:31 -0400
X-MC-Unique: ggkVwfV3P3KDHLgJNeELUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C55AC1926DA5;
        Thu,  2 Apr 2020 18:48:29 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-29.ams2.redhat.com [10.36.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B900360BF3;
        Thu,  2 Apr 2020 18:48:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v1 2/5] KVM: s390: vsie: Fix delivery of addressing exceptions
Date:   Thu,  2 Apr 2020 20:48:16 +0200
Message-Id: <20200402184819.34215-3-david@redhat.com>
In-Reply-To: <20200402184819.34215-1-david@redhat.com>
References: <20200402184819.34215-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Whenever we get an -EFAULT, we failed to read in guest 2 physical
address space. Such addressing exceptions are reported via a program
intercept to the nested hypervisor.

We faked the intercept, we have to return to guest 2. Instead, right
now we would be returning -EFAULT from the intercept handler, eventually
crashing the VM.

Addressing exceptions can only happen if the g2->g3 page tables
reference invalid g2 addresses (say, either a table or the final page is
not accessible - so something that basically never happens in sane
environments.

Identified by manual code inspection.

Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtual=
ization")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/vsie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 076090f9e666..4f6c22d72072 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1202,6 +1202,7 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct v=
sie_page *vsie_page)
 		scb_s->iprcc =3D PGM_ADDRESSING;
 		scb_s->pgmilc =3D 4;
 		scb_s->gpsw.addr =3D __rewind_psw(scb_s->gpsw, 4);
+		rc =3D 1;
 	}
 	return rc;
 }
--=20
2.25.1

