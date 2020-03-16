Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30FE186A52
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbgCPLph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:45:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47744 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730845AbgCPLph (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584359135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjC5eyqiVh4MSP5+mfLOvVmb5WFAsqeD54Xi4bPf+uc=;
        b=WqQD2PtlJMOkwxZgPAFw7Js7CxudVnbksOGvNUS748Szac4iL4PFZE9zeXRtvodbnSvi0j
        Qd13+vkCAUXIJ9YCtI+auq3nrLhHzGW5akBx6P+dY9CuLxt7OnyKa2L+KX3QCf5Drfxrwi
        QL40wlZF3XWOcCU8zNWlYrPgM8q1Y1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-qBH6rYb2OOC7Rsz_bGiHjg-1; Mon, 16 Mar 2020 07:45:33 -0400
X-MC-Unique: qBH6rYb2OOC7Rsz_bGiHjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABFFF18A8CBE;
        Mon, 16 Mar 2020 11:45:32 +0000 (UTC)
Received: from gondolin (ovpn-117-70.ams2.redhat.com [10.36.117.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CD497388E;
        Mon, 16 Mar 2020 11:45:27 +0000 (UTC)
Date:   Mon, 16 Mar 2020 12:45:25 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: Also reset registers in sync regs for
 initial cpu reset
Message-ID: <20200316124525.3bc099f9.cohuck@redhat.com>
In-Reply-To: <8bdef3aa-01b5-93a1-c54a-46768d47dfa4@redhat.com>
References: <20200310131223.10287-1-borntraeger@de.ibm.com>
        <8bdef3aa-01b5-93a1-c54a-46768d47dfa4@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Mar 2020 14:21:23 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 10.03.20 14:12, Christian Borntraeger wrote:
> > When we do the initial CPU reset we must not only clear the registers
> > in the internal data structures but also in kvm_run sync_regs. For
> > modern userspace sync_regs is the only place that it looks at.
> > 
> > Cc: stable@vger.kernel.org  
> 
> # v?
> 
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)

> However, I do wonder if that ioctl *originally* was designed for that -
> IOW if this is rally a stable patch or just some change that makes
> sense. IIRC, userspace/QEMU always did the right thing, no? There was no
> documentation about the guarantees AFAIK.

The documentation only refers to the PoP for what is actually reset...
should it also mention the sync regs?

