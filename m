Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6021711D3
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 08:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgB0Hxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 02:53:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728495AbgB0Hx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 02:53:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582790008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QdZSZmeTi2IR4EjFeqNNXbBpQhhR9pgfAjrS+j97XLk=;
        b=QTinIWj5lWemza/wh1H7nE+5bGF/6/kNz65ze9hKCs46ICsjANzRTgmjKBsaMzAgXmFPOW
        eJa79mWqgQgxis8+cQew/yFO1YPUtmIbGKy3d4OfD2BCFnQIM93HzDdFlNsXIcl5u7RZQe
        5GP13Sf6qjVbLz7BK8vmCM7m4xQtkgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-bVGe7fi4PHm8nrUFOfsItw-1; Thu, 27 Feb 2020 02:53:24 -0500
X-MC-Unique: bVGe7fi4PHm8nrUFOfsItw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69614802561;
        Thu, 27 Feb 2020 07:53:23 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-150.ams2.redhat.com [10.36.116.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B10F19C58;
        Thu, 27 Feb 2020 07:53:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B2A621744A; Thu, 27 Feb 2020 08:53:21 +0100 (CET)
Date:   Thu, 27 Feb 2020 08:53:21 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Thomas =?utf-8?Q?Hellstr=C3=B6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Cc:     dri-devel@lists.freedesktop.org, Guillaume.Gardet@arm.com,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, gurchetansingh@chromium.org,
        tzimmermann@suse.de
Subject: Re: [PATCH v5 1/3] drm/shmem: add support for per object caching
 flags.
Message-ID: <20200227075321.ki74hfjpnsqv2yx2@sirius.home.kraxel.org>
References: <20200226154752.24328-1-kraxel@redhat.com>
 <20200226154752.24328-2-kraxel@redhat.com>
 <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  Hi,

> > +		if (!shmem->map_cached)
> > +			prot =3D pgprot_writecombine(prot);
> >   		shmem->vaddr =3D vmap(shmem->pages, obj->size >> PAGE_SHIFT,
> > -				    VM_MAP, pgprot_writecombine(PAGE_KERNEL));
> > +				    VM_MAP, prot)
>=20
>=20
> Wouldn't a vmap with pgprot_writecombine() create conflicting mappings =
with
> the linear kernel map which is not write-combined?

I think so, yes.

> Or do you change the linear kernel map of the shmem pages somewhere?

Havn't seen anything doing so while browsing the code.

> vmap bypassess at least the
> x86 PAT core mapping consistency check and this could potentially cause
> spuriously overwritten memory.

Well, I don't think the linear kernel map is ever used to access the
shmem gem objects.  So while this isn't exactly clean it shouldn't
cause problems in practice.

Suggestions how to fix that?

The reason I need cachable gem object mappings for virtio-gpu is because
we have a inconsistency between host (cached) and guest (wc) otherwise.

> > +	}
> >   	if (!shmem->vaddr) {
> >   		DRM_DEBUG_KMS("Failed to vmap pages\n");
> > @@ -540,7 +545,9 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj=
, struct vm_area_struct *vma)
> >   	}
> >   	vma->vm_flags |=3D VM_MIXEDMAP | VM_DONTEXPAND;
> > -	vma->vm_page_prot =3D pgprot_writecombine(vm_get_page_prot(vma->vm_=
flags));
> > +	vma->vm_page_prot =3D vm_get_page_prot(vma->vm_flags);
> > +	if (!shmem->map_cached)
> > +		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
>=20
> Same thing here. Note that vmf_insert_page() which is used by the fault
> handler also bypasses the x86 PAT=A0 consistency check, whereas
> vmf_insert_mixed() doesn't.

vmap + mmap are consistent though, so this likewise shouldn't cause
issues in practice.

> >   	vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
>=20
> At least with SME or SEV encryption, where shmem memory has its kernel =
map
> set to encrypted, creating conflicting mappings is explicitly disallowe=
d.
> BTW, why is mmap mapping decrypted while vmap isn't?

Ok, that sounds like a real problem.  Have to check.

cheers,
  Gerd

PS: Given we are discussing pre-existing issues in the code I think the
    series can be merged nevertheless.

