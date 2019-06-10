Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1943F3BF6E
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 00:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbfFJWU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 18:20:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34203 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389927AbfFJWU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 18:20:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so4202640plt.1;
        Mon, 10 Jun 2019 15:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=15yQqgIi/SikZOybzZbSKOuahkGrOGENHVv8nStG9WM=;
        b=UITBVaV7bpziKljVZsdJiuAjzxCneW+Bejb6UYHHz4h0T9cVlz+d+mgL4FHKQIYvfS
         SZefXWachkys3nZDDIO0iXhYxoBSYGlen89vlCt8QdLatZtz4wEBbIiTGAtSwdU3Yur5
         PE7VstfwJOTjsvaIxc7KeFsCSA7Y6PC2lwWfMrNZ+6yYSHf0eqkw/Mxy5QLMQYe7DyN3
         FIouWWK/j9BeDTD4z7je0eonVePcwfUbdXu7/b2CNrJP+eFthesgd6XCnN3j6y/9QkMU
         t1swKw7BeNl1bWk98UxGk/gCYLg8wvOhL2XfgYm8xalgzYUEHVwhuTUZEX1ZKA3YWTif
         gOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=15yQqgIi/SikZOybzZbSKOuahkGrOGENHVv8nStG9WM=;
        b=W+tmic4yq2mKNhKv1ElrEc6iQlnXwPnPg0dN6MFOdmOoQk6GNEND4W1DiyfnhgGqbm
         AP5MPpiRxkBMGvJTCJlMbiNsbtQHrs3ZGrVviTsW9VTIAiZ/I8aC+eSt4WuJx+Cf3NYP
         692lPzQmNfGrHjuvzmSYAGnsCy8WpP495yyEGzmrlnnNjv3EKko8wkTgDFKZDLTaVlbO
         EEOHxVVT/dvTF72+ul0MKVsX38kmZb+gPnkYYiYOs0jihFsvdYORq8yOD53TmIoGJ46d
         nblauL3+MtCyYwQ0BV0T+BigIQlgWS3zmoIKl3PTzNljE/6DwMK3euwLGWs0YHOC7vSR
         NcLQ==
X-Gm-Message-State: APjAAAWXLZBGv99b4gDj0e9axRUcXS7q+OvNRAhPiESDkkRiFeMrGvqg
        hZIYRb0tdLj1ouVtbsi7q6x8IE0DFfvQUTw3Sg0=
X-Google-Smtp-Source: APXvYqxmh3cxgIzM0RomQcLVkAWjlwQ20PVg33H8JXxVbnEJgyabG+xU3b/lxdE9ZLYO0F8+FWnbTfo75mC4554n41I=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr44973639plb.46.1560205226700;
 Mon, 10 Jun 2019 15:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190605003838.13101-1-lsahlber@redhat.com> <CAKywueRYC2dm83zWCgrOVJc7J5s+UdMh-5NnF0sUOJ69NQ3qvQ@mail.gmail.com>
In-Reply-To: <CAKywueRYC2dm83zWCgrOVJc7J5s+UdMh-5NnF0sUOJ69NQ3qvQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Jun 2019 17:20:15 -0500
Message-ID: <CAH2r5mtgUQz5A3xmVMWr=1O5aerzSFSOL05Ay0y1U711OzdeVw@mail.gmail.com>
Subject: Re: [PATCH] cifs: add spinlock for the openFileList to cifsInodeInfo
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000509a62058aff9643"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000509a62058aff9643
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding a comment as requested and also mention of the new spinlock in
the list of locks and their purpose in cifsglob.h (then squashed that
change into Ronnie's commit and added your Reviewed-by - see attached)

On Mon, Jun 10, 2019 at 4:36 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=B2=D1=82, 4 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 17:42, Ronnie Sah=
lberg <lsahlber@redhat.com>:
> >
> > We can not depend on the tcon->open_file_lock here since in multiuser m=
ode
> > we may have the same file/inode open via multiple different tcons.
> >
> > The current code is race prone and will crash if one user deletes a fil=
e
> > at the same time a different user opens/create the file.
> >
> > To avoid this we need to have a spinlock attached to the inode and not =
the tcon.
> >
> > RHBZ:  1580165
> >
> > CC: Stable <stable@vger.kernel.org>
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c   | 1 +
> >  fs/cifs/cifsglob.h | 1 +
> >  fs/cifs/file.c     | 8 ++++++--
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index f5fcd6360056..65d9771e49f9 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -303,6 +303,7 @@ cifs_alloc_inode(struct super_block *sb)
> >         cifs_inode->uniqueid =3D 0;
> >         cifs_inode->createtime =3D 0;
> >         cifs_inode->epoch =3D 0;
> > +       spin_lock_init(&cifs_inode->open_file_lock);
> >         generate_random_uuid(cifs_inode->lease_key);
> >
> >         /*
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 334ff5f9c3f3..733ddd5fd480 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1377,6 +1377,7 @@ struct cifsInodeInfo {
> >         struct rw_semaphore lock_sem;   /* protect the fields above */
> >         /* BB add in lists for dirty pages i.e. write caching info for =
oplock */
> >         struct list_head openFileList;
> > +       spinlock_t      open_file_lock; /* protects openFileList */
> >         __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, s=
ystem */
> >         unsigned int oplock;            /* oplock/lease level we have *=
/
> >         unsigned int epoch;             /* used to track lease state ch=
anges */
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 06e27ac6d82c..97090693d182 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct fi=
le *file,
> >         atomic_inc(&tcon->num_local_opens);
> >
> >         /* if readable file instance put first in list*/
> > +       spin_lock(&cinode->open_file_lock);
> >         if (file->f_mode & FMODE_READ)
> >                 list_add(&cfile->flist, &cinode->openFileList);
> >         else
> >                 list_add_tail(&cfile->flist, &cinode->openFileList);
> > +       spin_unlock(&cinode->open_file_lock);
> >         spin_unlock(&tcon->open_file_lock);
> >
> >         if (fid->purge_cache)
> > @@ -413,7 +415,9 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_fi=
le, bool wait_oplock_handler)
> >         cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
> >
> >         /* remove it from the lists */
> > +       spin_lock(&cifsi->open_file_lock);
> >         list_del(&cifs_file->flist);
> > +       spin_unlock(&cifsi->open_file_lock);
> >         list_del(&cifs_file->tlist);
> >         atomic_dec(&tcon->num_local_opens);
> >
> > @@ -1950,9 +1954,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs=
_inode, bool fsuid_only,
> >                         return 0;
> >                 }
> >
> > -               spin_lock(&tcon->open_file_lock);
> > +               spin_lock(&cifs_inode->open_file_lock);
> >                 list_move_tail(&inv_file->flist, &cifs_inode->openFileL=
ist);
> > -               spin_unlock(&tcon->open_file_lock);
> > +               spin_unlock(&cifs_inode->open_file_lock);
> >                 cifsFileInfo_put(inv_file);
> >                 ++refind;
> >                 inv_file =3D NULL;
> > --
> > 2.13.6
> >
>
> Thanks for the patch. Looks good to me.
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> I would only add a comment telling what an order of the locks should
> be: cifs_tcon.open_file_lock and then cifsInodeInfo.open_file_lock.
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--000000000000509a62058aff9643
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-add-spinlock-for-the-openFileList-to-cifsInodeI.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-spinlock-for-the-openFileList-to-cifsInodeI.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jwqxwer20>
X-Attachment-Id: f_jwqxwer20

RnJvbSBiNWVhNjEyOWM5M2M0OWViNGE2ZDkxZWRkZjY3OTgyYjg3YWRmMGY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFdlZCwgNSBKdW4gMjAxOSAxMDozODozOCArMTAwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGFkZCBzcGlubG9jayBmb3IgdGhlIG9wZW5GaWxlTGlzdCB0byBjaWZzSW5vZGVJbmZvCgpX
ZSBjYW4gbm90IGRlcGVuZCBvbiB0aGUgdGNvbi0+b3Blbl9maWxlX2xvY2sgaGVyZSBzaW5jZSBp
biBtdWx0aXVzZXIgbW9kZQp3ZSBtYXkgaGF2ZSB0aGUgc2FtZSBmaWxlL2lub2RlIG9wZW4gdmlh
IG11bHRpcGxlIGRpZmZlcmVudCB0Y29ucy4KClRoZSBjdXJyZW50IGNvZGUgaXMgcmFjZSBwcm9u
ZSBhbmQgd2lsbCBjcmFzaCBpZiBvbmUgdXNlciBkZWxldGVzIGEgZmlsZQphdCB0aGUgc2FtZSB0
aW1lIGEgZGlmZmVyZW50IHVzZXIgb3BlbnMvY3JlYXRlIHRoZSBmaWxlLgoKVG8gYXZvaWQgdGhp
cyB3ZSBuZWVkIHRvIGhhdmUgYSBzcGlubG9jayBhdHRhY2hlZCB0byB0aGUgaW5vZGUgYW5kIG5v
dCB0aGUgdGNvbi4KClJIQlo6ICAxNTgwMTY1CgpDQzogU3RhYmxlIDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5j
b20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
UmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvY2lmc2ZzLmMgICB8IDEgKwogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgNSArKysrKwog
ZnMvY2lmcy9maWxlLmMgICAgIHwgOCArKysrKystLQogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMg
Yi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IGY1ZmNkNjM2MDA1Ni4uNjVkOTc3MWU0OWY5IDEwMDY0
NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTMwMyw2
ICszMDMsNyBAQCBjaWZzX2FsbG9jX2lub2RlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJY2lm
c19pbm9kZS0+dW5pcXVlaWQgPSAwOwogCWNpZnNfaW5vZGUtPmNyZWF0ZXRpbWUgPSAwOwogCWNp
ZnNfaW5vZGUtPmVwb2NoID0gMDsKKwlzcGluX2xvY2tfaW5pdCgmY2lmc19pbm9kZS0+b3Blbl9m
aWxlX2xvY2spOwogCWdlbmVyYXRlX3JhbmRvbV91dWlkKGNpZnNfaW5vZGUtPmxlYXNlX2tleSk7
CiAKIAkvKgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xv
Yi5oCmluZGV4IDMzNGZmNWY5YzNmMy4uNDc3N2IzYzRhOTJjIDEwMDY0NAotLS0gYS9mcy9jaWZz
L2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBAIC0xMzc3LDYgKzEzNzcsNyBA
QCBzdHJ1Y3QgY2lmc0lub2RlSW5mbyB7CiAJc3RydWN0IHJ3X3NlbWFwaG9yZSBsb2NrX3NlbTsJ
LyogcHJvdGVjdCB0aGUgZmllbGRzIGFib3ZlICovCiAJLyogQkIgYWRkIGluIGxpc3RzIGZvciBk
aXJ0eSBwYWdlcyBpLmUuIHdyaXRlIGNhY2hpbmcgaW5mbyBmb3Igb3Bsb2NrICovCiAJc3RydWN0
IGxpc3RfaGVhZCBvcGVuRmlsZUxpc3Q7CisJc3BpbmxvY2tfdAlvcGVuX2ZpbGVfbG9jazsJLyog
cHJvdGVjdHMgb3BlbkZpbGVMaXN0ICovCiAJX191MzIgY2lmc0F0dHJzOyAvKiBlLmcuIERPUyBh
cmNoaXZlIGJpdCwgc3BhcnNlLCBjb21wcmVzc2VkLCBzeXN0ZW0gKi8KIAl1bnNpZ25lZCBpbnQg
b3Bsb2NrOwkJLyogb3Bsb2NrL2xlYXNlIGxldmVsIHdlIGhhdmUgKi8KIAl1bnNpZ25lZCBpbnQg
ZXBvY2g7CQkvKiB1c2VkIHRvIHRyYWNrIGxlYXNlIHN0YXRlIGNoYW5nZXMgKi8KQEAgLTE3ODAs
MTAgKzE3ODEsMTQgQEAgcmVxdWlyZSB1c2Ugb2YgdGhlIHN0cm9uZ2VyIHByb3RvY29sICovCiAg
KiAgdGNwX3Nlc19sb2NrIHByb3RlY3RzOgogICoJbGlzdCBvcGVyYXRpb25zIG9uIHRjcCBhbmQg
U01CIHNlc3Npb24gbGlzdHMKICAqICB0Y29uLT5vcGVuX2ZpbGVfbG9jayBwcm90ZWN0cyB0aGUg
bGlzdCBvZiBvcGVuIGZpbGVzIGhhbmdpbmcgb2ZmIHRoZSB0Y29uCisgKiAgaW5vZGUtPm9wZW5f
ZmlsZV9sb2NrIHByb3RlY3RzIHRoZSBvcGVuRmlsZUxpc3QgaGFuZ2luZyBvZmYgdGhlIGlub2Rl
CiAgKiAgY2ZpbGUtPmZpbGVfaW5mb19sb2NrIHByb3RlY3RzIGNvdW50ZXJzIGFuZCBmaWVsZHMg
aW4gY2lmcyBmaWxlIHN0cnVjdAogICogIGZfb3duZXIubG9jayBwcm90ZWN0cyBjZXJ0YWluIHBl
ciBmaWxlIHN0cnVjdCBvcGVyYXRpb25zCiAgKiAgbWFwcGluZy0+cGFnZV9sb2NrIHByb3RlY3Rz
IGNlcnRhaW4gcGVyIHBhZ2Ugb3BlcmF0aW9ucwogICoKKyAqICBOb3RlIHRoYXQgdGhlIGNpZnNf
dGNvbi5vcGVuX2ZpbGVfbG9jayBzaG91bGQgYmUgdGFrZW4gYmVmb3JlCisgKiAgbm90IGFmdGVy
IHRoZSBjaWZzSW5vZGVJbmZvLm9wZW5fZmlsZV9sb2NrCisgKgogICogIFNlbWFwaG9yZXMKICAq
ICAtLS0tLS0tLS0tCiAgKiAgc2VzU2VtICAgICBvcGVyYXRpb25zIG9uIHNtYiBzZXNzaW9uCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IDA2ZTI3YWM2
ZDgyYy4uOTcwOTA2OTNkMTgyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9j
aWZzL2ZpbGUuYwpAQCAtMzM4LDEwICszMzgsMTIgQEAgY2lmc19uZXdfZmlsZWluZm8oc3RydWN0
IGNpZnNfZmlkICpmaWQsIHN0cnVjdCBmaWxlICpmaWxlLAogCWF0b21pY19pbmMoJnRjb24tPm51
bV9sb2NhbF9vcGVucyk7CiAKIAkvKiBpZiByZWFkYWJsZSBmaWxlIGluc3RhbmNlIHB1dCBmaXJz
dCBpbiBsaXN0Ki8KKwlzcGluX2xvY2soJmNpbm9kZS0+b3Blbl9maWxlX2xvY2spOwogCWlmIChm
aWxlLT5mX21vZGUgJiBGTU9ERV9SRUFEKQogCQlsaXN0X2FkZCgmY2ZpbGUtPmZsaXN0LCAmY2lu
b2RlLT5vcGVuRmlsZUxpc3QpOwogCWVsc2UKIAkJbGlzdF9hZGRfdGFpbCgmY2ZpbGUtPmZsaXN0
LCAmY2lub2RlLT5vcGVuRmlsZUxpc3QpOworCXNwaW5fdW5sb2NrKCZjaW5vZGUtPm9wZW5fZmls
ZV9sb2NrKTsKIAlzcGluX3VubG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2spOwogCiAJaWYgKGZp
ZC0+cHVyZ2VfY2FjaGUpCkBAIC00MTMsNyArNDE1LDkgQEAgdm9pZCBfY2lmc0ZpbGVJbmZvX3B1
dChzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjaWZzX2ZpbGUsIGJvb2wgd2FpdF9vcGxvY2tfaGFuZGxl
cikKIAljaWZzX2FkZF9wZW5kaW5nX29wZW5fbG9ja2VkKCZmaWQsIGNpZnNfZmlsZS0+dGxpbmss
ICZvcGVuKTsKIAogCS8qIHJlbW92ZSBpdCBmcm9tIHRoZSBsaXN0cyAqLworCXNwaW5fbG9jaygm
Y2lmc2ktPm9wZW5fZmlsZV9sb2NrKTsKIAlsaXN0X2RlbCgmY2lmc19maWxlLT5mbGlzdCk7CisJ
c3Bpbl91bmxvY2soJmNpZnNpLT5vcGVuX2ZpbGVfbG9jayk7CiAJbGlzdF9kZWwoJmNpZnNfZmls
ZS0+dGxpc3QpOwogCWF0b21pY19kZWMoJnRjb24tPm51bV9sb2NhbF9vcGVucyk7CiAKQEAgLTE5
NTAsOSArMTk1NCw5IEBAIGNpZnNfZ2V0X3dyaXRhYmxlX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUlu
Zm8gKmNpZnNfaW5vZGUsIGJvb2wgZnN1aWRfb25seSwKIAkJCXJldHVybiAwOwogCQl9CiAKLQkJ
c3Bpbl9sb2NrKCZ0Y29uLT5vcGVuX2ZpbGVfbG9jayk7CisJCXNwaW5fbG9jaygmY2lmc19pbm9k
ZS0+b3Blbl9maWxlX2xvY2spOwogCQlsaXN0X21vdmVfdGFpbCgmaW52X2ZpbGUtPmZsaXN0LCAm
Y2lmc19pbm9kZS0+b3BlbkZpbGVMaXN0KTsKLQkJc3Bpbl91bmxvY2soJnRjb24tPm9wZW5fZmls
ZV9sb2NrKTsKKwkJc3Bpbl91bmxvY2soJmNpZnNfaW5vZGUtPm9wZW5fZmlsZV9sb2NrKTsKIAkJ
Y2lmc0ZpbGVJbmZvX3B1dChpbnZfZmlsZSk7CiAJCSsrcmVmaW5kOwogCQlpbnZfZmlsZSA9IE5V
TEw7Ci0tIAoyLjIwLjEKCg==
--000000000000509a62058aff9643--
