Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C28C19DA2E
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 17:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404327AbgDCPb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 11:31:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404292AbgDCPbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 11:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585927867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1iTHN+tnT2p+g/fi18lrfKuFFUGCiTi5w5obFOSEB4=;
        b=HZUB48HsDX3wx5N15wLzLhTxxj/ajaoQoP/mQf5yMLzAx8kqkizoDAFzcDHCtpFSwxUP/C
        IIArNKQox4AnbJRvQy6my7hvH/XaAJ+3/OxWza0tUsYUKNayvd5bHRcox8wD3R+nwOx8Pz
        PE5K/vnEAzB0LuMmxTsEUTSQ8SRn5VU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-m04b8OhgN3i6PG6Oq4RBpg-1; Fri, 03 Apr 2020 11:31:03 -0400
X-MC-Unique: m04b8OhgN3i6PG6Oq4RBpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CBD7190B2A0;
        Fri,  3 Apr 2020 15:31:02 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-213.ams2.redhat.com [10.36.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C83A26DD1;
        Fri,  3 Apr 2020 15:30:59 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/5] KVM: s390: vsie: Fix delivery of addressing exceptions
Date:   Fri,  3 Apr 2020 17:30:47 +0200
Message-Id: <20200403153050.20569-3-david@redhat.com>
In-Reply-To: <20200403153050.20569-1-david@redhat.com>
References: <20200403153050.20569-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

