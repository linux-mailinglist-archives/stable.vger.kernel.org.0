Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4CD345CD
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 13:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfFDLqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 07:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfFDLqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 07:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A4A245BC;
        Tue,  4 Jun 2019 11:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559648794;
        bh=cc+XBsmoRfD3JUIDmY8ud6VGyswQf8m4jnRyy68Y/mA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1Et/BUSNeRW+9m9+SDsUvaD1+04SfCa/IlYKFq9hx5AZjyxFsFONvbdBv8pIziyu
         XuSgE/wTrz51dKspuUhGydaW9GdXToBW5EMWJAoQcScUY2Xw6rBo1jHV0dUvAMnY7V
         ZwCHbjEgSU7l93/WzjGqjSZ+WfQMOKBC5+KWd02w=
Date:   Tue, 4 Jun 2019 13:46:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     stable@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH for 5.1 and older] KVM: s390: Do not report unusabled IDs
 via KVM_CAP_MAX_VCPU_ID
Message-ID: <20190604114632.GB13480@kroah.com>
References: <155963851418943@kroah.com>
 <20190604091828.39955-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604091828.39955-1-borntraeger@de.ibm.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 11:18:28AM +0200, Christian Borntraeger wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> KVM_CAP_MAX_VCPU_ID is currently always reporting KVM_MAX_VCPU_ID on all
> architectures. However, on s390x, the amount of usable CPUs is determined
> during runtime - it is depending on the features of the machine the code
> is running on. Since we are using the vcpu_id as an index into the SCA
> structures that are defined by the hardware (see e.g. the sca_add_vcpu()
> function), it is not only the amount of CPUs that is limited by the hard-
> ware, but also the range of IDs that we can use.
> Thus KVM_CAP_MAX_VCPU_ID must be determined during runtime on s390x, too.
> So the handling of KVM_CAP_MAX_VCPU_ID has to be moved from the common
> code into the architecture specific code, and on s390x we have to return
> the same value here as for KVM_CAP_MAX_VCPUS.
> This problem has been discovered with the kvm_create_max_vcpus selftest.
> With this change applied, the selftest now passes on s390x, too.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20190523164309.13345-9-thuth@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> [backport to 5.1 and older]

Now queued up, but next time, give me a hint and put the git sha1 id of
the commit in Linus's tree somewhere in here...

thanks,

greg k-h
