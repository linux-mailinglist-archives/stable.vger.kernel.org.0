Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E99D263A1A
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgIJCTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 22:19:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730170AbgIJCRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 22:17:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599704262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hRuaCM4UO0QYlTpMIEqBgJQxJgieRpUxJTH6YhefOQ=;
        b=PfQUYc+5peHE5ZERC1xZTp5LKs4GtqKU32MQdHcdbAAKm/LgXUEexm9UpfPpjhAnX3MsVY
        mMxn1xYrqCQM10lDl2WwxEc1CMRkcZCkhTMkGnXmABYIwpUSPu5XdH9RwJhai11v7W9ADz
        9pYk58obg5zbmFOZwZDguMuKRG6La4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-levCQ31sNTGtP_svl2bqAA-1; Wed, 09 Sep 2020 22:17:38 -0400
X-MC-Unique: levCQ31sNTGtP_svl2bqAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8D7E1882FB0;
        Thu, 10 Sep 2020 02:17:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC6151002393;
        Thu, 10 Sep 2020 02:17:36 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 953A018095FF;
        Thu, 10 Sep 2020 02:17:36 +0000 (UTC)
Date:   Wed, 9 Sep 2020 22:17:35 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Ashok Raj <ashok.raj@intel.com>
Cc:     dwmw2@infradead.org, baolu lu <baolu.lu@linux.intel.com>,
        joro@8bytes.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, eperezma@redhat.com,
        peterx@redhat.com, mst@redhat.com, stable@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <491540137.16465450.1599704255365.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200909171056.GF104641@otc-nc-03>
References: <20200909083432.9464-1-jasowang@redhat.com> <20200909171056.GF104641@otc-nc-03>
Subject: Re: [PATCH] intel-iommu: don't disable ATS for device without page
 aligned request
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.24]
Thread-Topic: intel-iommu: don't disable ATS for device without page aligned request
Thread-Index: OZU0O/7OadpZCvrZzmt7QzTbbYaicg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> Hi Jason
> 
> On Wed, Sep 09, 2020 at 04:34:32PM +0800, Jason Wang wrote:
> > Commit 61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses
> > page aligned address.") disables ATS for device that can do unaligned
> > page request.
> 
> Did you take a look at the PCI specification?
> Page Aligned Request is in the ATS capability Register.
> 
> ATS Capability Register (Offset 0x04h)
> 
> bit (5):
> Page Aligned Request - If Set, indicates the Untranslated address is always
> aligned to 4096 byte boundary. Setting this field is recommended. This
> field permits software to distinguish between implemntations compatible
> with this specification and those compatible with an earlier version of
> this specification in which a Requester was permitted to supply anything in
> bits [11:2].

Yes, my understanding is that this is optional not mandatory.

> 
> > 
> > This looks wrong, since the commit log said it's because the page
> > request descriptor doesn't support reporting unaligned request.
> 
> I don't think you can change the definition from ATS to PRI. Both are
> orthogonal feature.

I may miss something, here's my understanding is that:

- page request descriptor will only be used when PRS is enabled
- ATS spec allows unaligned request

So any reason for disabling ATS for unaligned request even if PRS is
not enabled?

> 
> > 
> > A victim is Qemu's virtio-pci which doesn't advertise the page aligned
> > address. Fixing by disable PRI instead of ATS if device doesn't have
> > page aligned request.
> 
> This is a requirement for the Intel IOMMU's.
> 
> You say virtio, so is it all emulated device or you talking about some
> hardware that implemented virtio-pci compliant hw? If you are sure the
> device actually does comply with the requirement, but just not enumerating
> the capability, you can maybe work a quirk to overcome that?

So far only emulated devices. But we are helping some vendor to
implement virtio hardware so  we need to understand the connection
between ATS alignment and page request descriptor.

> 
> Now PRI also has an alignment requirement, and Intel IOMMU's requires that
> as well. If your device supports SRIOV as well, PASID and PRI are
> enumerated just on the PF and not the VF. You might want to pay attension
> to that. We are still working on a solution for that problem.

Thanks for the reminding, but it looks to me according to the ATS
spec, all PRI message is 4096 byte aligned? E.g lower bites were used
for group index etc.

Thanks

> 
> I don't think this is the right fix for your problem.
> 
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Ashok Raj <ashok.raj@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Keith Busch <keith.busch@intel.com>
> > Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/iommu/intel/iommu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> 
> 

