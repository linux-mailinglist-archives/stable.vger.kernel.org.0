Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7963B885
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 04:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbiK2DGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 22:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiK2DGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 22:06:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B9E48415
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 19:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669691057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJYR23KNh0UlxbGzPt0eSeyjNLVB/XO+AaILK784Ha8=;
        b=Q9wg88W26g47kiyDKkUpHJAA5fC9CUqUN8Nn5/sLZQm9+odW23rENTDq9XYcREVpge4/JH
        7hNVTDmnfbdrvh4/zHFkpaqB5jHRRJrJdaS33qqWQhNsivmdi6/7M1Fsuc5eOsTaRsy1kT
        Y+iB/AwVNT8EflAxwT4apSjv6hlLW3Y=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-moAXtYmpMWeoDsHdMdnQvQ-1; Mon, 28 Nov 2022 22:04:15 -0500
X-MC-Unique: moAXtYmpMWeoDsHdMdnQvQ-1
Received: by mail-ot1-f72.google.com with SMTP id v17-20020a9d7d11000000b0066c33c3e0easo5176405otn.11
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 19:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PJYR23KNh0UlxbGzPt0eSeyjNLVB/XO+AaILK784Ha8=;
        b=gYeve6hCopFXVgZ+SQszN8g48An4p93wEsFW1UUonZb2Oz5PAe3YB98XHXPaq8lHQL
         PNlQ19XX9UROtgnxnzmDShN249pec94kTuic/ClKxfCa4YObFPqPyDzZhxWXFgrOXo0l
         56rjP7oNK/SUkucVp2QDZLfKaidmK0x0KuCaBVL/jFjG9Hom291BgDvbGjybJqUAvx8a
         uZuGSE7Itmx0mkG0y5xZtKB0R7vCd9fJ8vCsyBOY3Lvpul+6LbwtYEEGSR6UFihb5kmm
         C+qbieq7PGDx5uVNNLLegZuJ79L1iQiXj1LiZv8m3wIMfozR/RyoDaE/DGIjX64y+9oq
         kmww==
X-Gm-Message-State: ANoB5pkQs78v+ddPEEc5QO+Uwfrsqb0iO+fjYfLoSxFzOL+C9Xr7dR+d
        /px00iVWn2qwilGhGSRVC13iYFLtbSMaplTndai7Y9H1MNhYQ7X5Lyl16AaQHIwpj84sGk2vyQQ
        kJHGLw5yx/gmOZTN18ZB911eqyPu4qDrU
X-Received: by 2002:a9d:4f07:0:b0:66c:64d6:1bb4 with SMTP id d7-20020a9d4f07000000b0066c64d61bb4mr27044582otl.201.1669691054455;
        Mon, 28 Nov 2022 19:04:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf70Ry6OjGs+hy6g6ijoNxP3Znw2AU1BrK7TlBtYSMfr4tzUWxFvSjkwqKm+iZJVXZK3OiprWO47l/Op2eZkPdk=
X-Received: by 2002:a9d:4f07:0:b0:66c:64d6:1bb4 with SMTP id
 d7-20020a9d4f07000000b0066c64d61bb4mr27044576otl.201.1669691054181; Mon, 28
 Nov 2022 19:04:14 -0800 (PST)
MIME-Version: 1.0
References: <20221125023045.2158413-1-lulu@redhat.com> <CACGkMEuPMYVamb9saZWX8E38Xu_Q5vS7BKweyUeOaS==uiVZqw@mail.gmail.com>
 <CACLfguU6VZ7PPf7coj7Fe5ZPdqitekHkL9rfc3o4nWG2uFmonw@mail.gmail.com>
In-Reply-To: <CACLfguU6VZ7PPf7coj7Fe5ZPdqitekHkL9rfc3o4nWG2uFmonw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 29 Nov 2022 11:04:03 +0800
Message-ID: <CACGkMEuxuk3nXK3SnXw1k39jcQr-QGTQMeF8-ZPszxHaBJ6f-w@mail.gmail.com>
Subject: Re: [PATCH v3] vhost_vdpa: fix the crash in unmap a large memory
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 25, 2022 at 3:38 PM Cindy Lu <lulu@redhat.com> wrote:
>
> / and
>
>
> On Fri, 25 Nov 2022 at 15:17, Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Fri, Nov 25, 2022 at 10:31 AM Cindy Lu <lulu@redhat.com> wrote:
> > >
> > > While testing in vIOMMU, sometimes guest will unmap very large memory=
,
> > > which will cause the crash. To fix this,Move the iommu_unmap to
> > > vhost_vdpa_pa_unmap/vhost_vdpa_va_unmap and only unmap the memory
> > > that saved in iotlb.
> > >
> > > Call Trace:
> > > [  647.820144] ------------[ cut here ]------------
> > > [  647.820848] kernel BUG at drivers/iommu/intel/iommu.c:1174!
> > > [  647.821486] invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > [  647.822082] CPU: 10 PID: 1181 Comm: qemu-system-x86 Not tainted 6.=
0.0-rc1home_lulu_2452_lulu7_vhost+ #62
> > > [  647.823139] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BI=
OS rel-1.15.0-29-g6a62e0cb0dfe-prebuilt.qem4
> > > [  647.824365] RIP: 0010:domain_unmap+0x48/0x110
> > > [  647.825424] Code: 48 89 fb 8d 4c f6 1e 39 c1 0f 4f c8 83 e9 0c 83 =
f9 3f 7f 18 48 89 e8 48 d3 e8 48 85 c0 75 59
> > > [  647.828064] RSP: 0018:ffffae5340c0bbf0 EFLAGS: 00010202
> > > [  647.828973] RAX: 0000000000000001 RBX: ffff921793d10540 RCX: 00000=
0000000001b
> > > [  647.830083] RDX: 00000000080000ff RSI: 0000000000000001 RDI: ffff9=
21793d10540
> > > [  647.831214] RBP: 0000000007fc0100 R08: ffffae5340c0bcd0 R09: 00000=
00000000003
> > > [  647.832388] R10: 0000007fc0100000 R11: 0000000000100000 R12: 00000=
000080000ff
> > > [  647.833668] R13: ffffae5340c0bcd0 R14: ffff921793d10590 R15: 00000=
08000100000
> > > [  647.834782] FS:  00007f772ec90640(0000) GS:ffff921ce7a80000(0000) =
knlGS:0000000000000000
> > > [  647.836004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  647.836990] CR2: 00007f02c27a3a20 CR3: 0000000101b0c006 CR4: 00000=
00000372ee0
> > > [  647.838107] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> > > [  647.839283] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> > > [  647.840666] Call Trace:
> > > [  647.841437]  <TASK>
> > > [  647.842107]  intel_iommu_unmap_pages+0x93/0x140
> > > [  647.843112]  __iommu_unmap+0x91/0x1b0
> > > [  647.844003]  iommu_unmap+0x6a/0x95
> > > [  647.844885]  vhost_vdpa_unmap+0x1de/0x1f0 [vhost_vdpa]
> > > [  647.845985]  vhost_vdpa_process_iotlb_msg+0xf0/0x90b [vhost_vdpa]
> > > [  647.847235]  ? _raw_spin_unlock+0x15/0x30
> > > [  647.848181]  ? _copy_from_iter+0x8c/0x580
> > > [  647.849137]  vhost_chr_write_iter+0xb3/0x430 [vhost]
> > > [  647.850126]  vfs_write+0x1e4/0x3a0
> > > [  647.850897]  ksys_write+0x53/0xd0
> > > [  647.851688]  do_syscall_64+0x3a/0x90
> > > [  647.852508]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > [  647.853457] RIP: 0033:0x7f7734ef9f4f
> > > [  647.854408] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 29 76 =
f8 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c8
> > > [  647.857217] RSP: 002b:00007f772ec8f040 EFLAGS: 00000293 ORIG_RAX: =
0000000000000001
> > > [  647.858486] RAX: ffffffffffffffda RBX: 00000000fef00000 RCX: 00007=
f7734ef9f4f
> > > [  647.859713] RDX: 0000000000000048 RSI: 00007f772ec8f090 RDI: 00000=
00000000010
> > > [  647.860942] RBP: 00007f772ec8f1a0 R08: 0000000000000000 R09: 00000=
00000000000
> > > [  647.862206] R10: 0000000000000001 R11: 0000000000000293 R12: 00000=
00000000010
> > > [  647.863446] R13: 0000000000000002 R14: 0000000000000000 R15: fffff=
fff01100000
> > > [  647.864692]  </TASK>
> > > [  647.865458] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 d=
ns_resolver nfs lockd grace fscache netfs v]
> > > [  647.874688] ---[ end trace 0000000000000000 ]---
> > > [  647.876013] RIP: 0010:domain_unmap+0x48/0x110
> > > [  647.878306] Code: 48 89 fb 8d 4c f6 1e 39 c1 0f 4f c8 83 e9 0c 83 =
f9 3f 7f 18 48 89 e8 48 d3 e8 48 85 c0 75 59
> > > [  647.884581] RSP: 0018:ffffae5340c0bbf0 EFLAGS: 00010202
> > > [  647.886308] RAX: 0000000000000001 RBX: ffff921793d10540 RCX: 00000=
0000000001b
> > > [  647.888775] RDX: 00000000080000ff RSI: 0000000000000001 RDI: ffff9=
21793d10540
> > > [  647.890295] RBP: 0000000007fc0100 R08: ffffae5340c0bcd0 R09: 00000=
00000000003
> > > [  647.891660] R10: 0000007fc0100000 R11: 0000000000100000 R12: 00000=
000080000ff
> > > [  647.893019] R13: ffffae5340c0bcd0 R14: ffff921793d10590 R15: 00000=
08000100000
> > > [  647.894506] FS:  00007f772ec90640(0000) GS:ffff921ce7a80000(0000) =
knlGS:0000000000000000
> > > [  647.895963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  647.897348] CR2: 00007f02c27a3a20 CR3: 0000000101b0c006 CR4: 00000=
00000372ee0
> > > [  647.898719] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > ---
> > >  drivers/vhost/vdpa.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 166044642fd5..e5a07751bf45 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -692,6 +692,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa=
 *v,
> > >         struct vhost_iotlb_map *map;
> > >         struct page *page;
> > >         unsigned long pfn, pinned;
> > > +       struct vdpa_device *vdpa =3D v->vdpa;
> > > +       const struct vdpa_config_ops *ops =3D vdpa->config;
> > >
> > >         while ((map =3D vhost_iotlb_itree_first(iotlb, start, last)) =
!=3D NULL) {
> > >                 pinned =3D PFN_DOWN(map->size);
> > > @@ -703,6 +705,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa=
 *v,
> > >                         unpin_user_page(page);
> > >                 }
> > >                 atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm=
);
> > > +               if ((ops->dma_map =3D=3D NULL) && (ops->set_map =3D=
=3D NULL))
> > > +                       iommu_unmap(v->domain, map->start, map->size)=
;
> >
> > I think we'd better move the ops->dma_unmap() here as well as iommu_unm=
ap()?
> >
> > >                 vhost_iotlb_map_free(iotlb, map);
> > >         }
> > >  }
> > > @@ -713,11 +717,15 @@ static void vhost_vdpa_va_unmap(struct vhost_vd=
pa *v,
> > >  {
> > >         struct vhost_iotlb_map *map;
> > >         struct vdpa_map_file *map_file;
> > > +       struct vdpa_device *vdpa =3D v->vdpa;
> > > +       const struct vdpa_config_ops *ops =3D vdpa->config;
> > >
> > >         while ((map =3D vhost_iotlb_itree_first(iotlb, start, last)) =
!=3D NULL) {
> > >                 map_file =3D (struct vdpa_map_file *)map->opaque;
> > >                 fput(map_file->file);
> > >                 kfree(map_file);
> > > +               if (ops->set_map =3D=3D NULL)
> > > +                       iommu_unmap(v->domain, map->start, map->size)=
;
> >
> > Need to check where we have dma_unmap() and call that if it exists?
> >
> > Thanks
> >
> Hi Jason=EF=BC=8C
> I think  these functions are called in vhost_vdpa_unmap,
> Do you want to separate the function in vhost_vdpa_unmap
> and move it to vhost_vdpa_va_unmap and vhost_vdpa_pa_unmap? I

I meant dma_map()/dma_unmap() should be functional equivalent to
iommu_map/unmap(). That means we should unmap exactly what is mapped
before (vDPA parent may call iommu_unmap in its own dma_unmap() if it
needs). If we move the iommu_unmap() from vhost_vdpa_unmap() to
vhost_vdpa_{pa|va}_umap, we should move dma_unmap() as well.

Thanks

> thanks
> cindy
>
> > >                 vhost_iotlb_map_free(iotlb, map);
> > >         }
> > >  }
> > > @@ -805,8 +813,6 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v=
,
> > >         } else if (ops->set_map) {
> > >                 if (!v->in_batch)
> > >                         ops->set_map(vdpa, asid, iotlb);
> > > -       } else {
> > > -               iommu_unmap(v->domain, iova, size);
> > >         }
> > >
> > >         /* If we are in the middle of batch processing, delay the fre=
e
> > > --
> > > 2.34.3
> > >
> >
>

