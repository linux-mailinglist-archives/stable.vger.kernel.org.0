Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3D3591258
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbiHLOgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 10:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238816AbiHLOgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 10:36:53 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83CA85AAB;
        Fri, 12 Aug 2022 07:36:50 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u14so1352033oie.2;
        Fri, 12 Aug 2022 07:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=aLNxAW8k/19aq8D5p21jQUroC1e8wOaHHjI3tUSg7Ug=;
        b=PjBoEWCWr/syZR311IaxNV7cmyWntmhJtWnSzcRcoz++dD2f0iW5sYGmbUt9qSl916
         vZ04rprhghoi3cu0uVEmXHsz8GniijvmbiIA+4runp2JXDjcHl7Q7YehdJyjYkMWLOF3
         qiQ51E8E4xGHOzBf4I2qWJLAaxOrWLUSZpyBDpg0vdGznDHVnwrO9pRT/7HDpF6eKVlP
         JhbaeYW0DGZKDLYHmX5ayi2JrBxV/Nd8OiZXzTeH+0UiCDhuRQ3YTejrJp5NVtUbzhGd
         yjMMzPMDqTEQNE8ZR+vrcq/6eXnuiVFqmjuJaXc9QkBDNtMyW+5VSphWuLEnEVJmu+2b
         x1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=aLNxAW8k/19aq8D5p21jQUroC1e8wOaHHjI3tUSg7Ug=;
        b=Jo6lUrJwsdmTna3G71lyUo9FAM4mwygc6FZIgnITGjSAaYlSfh7TktQYZip7tdLOOM
         RFUXvgItf3+PT8xnnrKJKoDVWRC9Lm75mR5kJrvBYiE9XhOt5cyqaa6FoWgTyTAnapOG
         MkoDJV5RtR3TqoE+ITByymPP8BQIuVej0VEpBCWBV3s1JUt5mMk5Tv2RegeiFaqq15pB
         /Fm+dFYbGJHYtvm8oXInVCwaMPSt0wkiSXHAuD8z2YkNw1V0yomceeL0zgP/VoRNcfgV
         RqDG+eLRVOlZXZsRfI5IWJ9n72C9mkSjIXQ7yvwz4+hlUX/5zjAFFxsssIsKlXDKkIVr
         fkjQ==
X-Gm-Message-State: ACgBeo1Ia5/uiZix5GVltPsVOJL/U5KzolY00UkVk177jBXjud50Ohvv
        T5B4ENVR7mz2OOfC8RyNwZNtR7vH9gwC7J4JAfI=
X-Google-Smtp-Source: AA6agR4Z5PbmZ216emjezmCAyH/nksiSu9/y/DOXeCFT+1BhwNeeysCfTVOutF7WfFomt1Lj6s6ufS5lVSqUMZ3/OUc=
X-Received: by 2002:a05:6808:6da:b0:342:cf1e:45be with SMTP id
 m26-20020a05680806da00b00342cf1e45bemr5558490oih.138.1660315009788; Fri, 12
 Aug 2022 07:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220811100912.126447-1-bingjingc@synology.com>
 <20220811100912.126447-3-bingjingc@synology.com> <CAL3q7H60vU2SNto+vqo7bc6f8+0bWSTV-yMZ+mTOu-hWt_wejA@mail.gmail.com>
In-Reply-To: <CAL3q7H60vU2SNto+vqo7bc6f8+0bWSTV-yMZ+mTOu-hWt_wejA@mail.gmail.com>
From:   bingjing chang <bxxxjxxg@gmail.com>
Date:   Fri, 12 Aug 2022 22:36:38 +0800
Message-ID: <CAMmgxWFpRRp_gGXXncBzoJgsmmbfdtBtfysntW7JpxFBxBNPJQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs: send: fix failures when processing inodes
 with no links
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     bingjingc <bingjingc@synology.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robbie Ko <robbieko@synology.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Filipe Manana <fdmanana@kernel.org> =E6=96=BC 2022=E5=B9=B48=E6=9C=8811=E6=
=97=A5 =E9=80=B1=E5=9B=9B =E6=99=9A=E4=B8=8A8:00=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Thu, Aug 11, 2022 at 11:09 AM bingjingc <bingjingc@synology.com> wrote=
:
> >
> > From: BingJing Chang <bingjingc@synology.com>
> >
> > There is a bug causing send failures when processing an orphan director=
y
> > with no links. In commit 46b2f4590aab ("Btrfs: fix send failure when ro=
ot
> > has deleted files still open")', the orphan inode issue was addressed. =
The
> > send operation fails with a ENOENT error because of any attempts to
> > generate a path for the inode with a link count of zero. Therefore, in =
that
> > patch, sctx->ignore_cur_inode was introduced to be set if the current i=
node
> > has a link count of zero for bypassing some unnecessary steps. And a he=
lper
> > function btrfs_unlink_all_paths() was introduced and called to clean up=
 old
> > paths found in the parent snapshot. However, not only regular files but
> > also directories can be orphan inodes. So if the send operation meets a=
n
> > orphan directory, it will issue a wrong unlink command for that directo=
ry
> > now. Soon the receive operation fails with a EISDIR error. Besides, the
> > send operation also fails with a ENOENT error later when it tries to
> > generate a path of it.
> >
> > Similar example but making an orphan dir for an incremental send:
> >
> >   $ btrfs subvolume create vol
> >   $ mkdir vol/dir
> >   $ touch vol/dir/foo
> >
> >   $ btrfs subvolume snapshot -r vol snap1
> >   $ btrfs subvolume snapshot -r vol snap2
> >
> >   # Turn the second snapshot to RW mode and delete the whole dir while
> >   # holding an open file descriptor on it.
> >   $ btrfs property set snap2 ro false
> >   $ exec 73<snap2/dir
> >   $ rm -rf snap2/dir
> >
> >   # Set the second snapshot back to RO mode and do an incremental send.
> >   $ btrfs property set snap2 ro true
> >   $ mkdir receive_dir
> >   $ btrfs send snap2 -p snap1 | btrfs receive receive_dir/
> >   At subvol snap2
> >   At snapshot snap2
> >   ERROR: send ioctl failed with -2: No such file or directory
> >   ERROR: unlink dir failed. Is a directory
> >
> > Actually, orphan inodes are more common use cases in cascading backups.
> > (Please see the illustration below.) In a cascading backup, a user want=
s
> > to replicate a couple of snapshots from Machine A to Machine B and from
> > Machine B to Machine C. Machine B doesn't take any RO snapshots for
> > sending. All a receiver does is create an RW snapshot of its parent
> > snapshot, apply the send stream and turn it into RO mode at the end. Ev=
en
> > if all paths of some inodes are deleted in applying the send stream, th=
ese
> > inodes would not be deleted and become orphans after changing the subvo=
lume
> > from RW to RO. Moreover, orphan inodes can occur not only in send snaps=
hots
> > but also in parent snapshots because Machine B may do a batch replicati=
on
> > of a couple of snapshots.
> >
> > An illustration for cascading backups:
> > Machine A (snapshot {1..n}) --> Machine B --> Machine C
> >
> > The intuition to solve the problem is to delete all the items of orphan
> > inodes before using these snapshots for sending. I used to think that t=
he
> > reasonable timing for doing that is during the ioctl of changing the
> > subvolume from RW to RO because it sounds good that we will not modify =
the
> > fs tree of a RO snapshot anymore. However, attempting to do the orphan
> > cleanup in the ioctl would be pointless. Because if someone is holding =
an
> > open file descriptor on the inode, the reference count of the inode wil=
l
> > never drop to 0. Then iput() cannot trigger eviction, which finally del=
etes
> > all the items of it. So we try to extend the original patch to handle
> > orphans in send/parent snapshots. Here are several cases that need to b=
e
> > considered:
> >
> > Case 1: BTRFS_COMPARE_TREE_NEW
> >        |  send snapshot  | action
> >  --------------------------------
> >  nlink |        0        | ignore
> >
> > In case 1, when we get a BTRFS_COMPARE_TREE_NEW tree comparison result,
> > it means that a new inode is found in the send snapshot and it doesn't
> > appear in the parent snapshot. Since this inode has a link count of zer=
o
> > (It's an orphan and there're no paths for it.), we can leverage
> > sctx->ignore_cur_inode in the original patch to prevent it from being
> > created.
> >
> > Case 2: BTRFS_COMPARE_TREE_DELETED
> >        | parent snapshot | action
> >  ----------------------------------
> >  nlink |        0        | as usual
> >
> > In case 2, when we get a BTRFS_COMPARE_TREE_DELETED tree comparison
> > result, it means that the inode only appears in the parent snapshot.
> > As usual, the send operation will try to delete all its paths. However,
> > this inode has a link count of zero, so no paths of it will be found. N=
o
> > deletion operations will be issued. We don't need to change any logic.
> >
> > Case 3: BTRFS_COMPARE_TREE_CHANGED
> >            |       | parent snapshot | send snapshot | action
> >  ----------------------------------------------------------------------=
-
> >  subcase 1 | nlink |        0        |       0       | ignore
> >  subcase 2 | nlink |       >0        |       0       | new_gen(deletion=
)
> >  subcase 3 | nlink |        0        |      >0       | new_gen(creation=
)
> >
> > In case 3, when we get a BTRFS_COMPARE_TREE_CHANGED tree comparison res=
ult,
> > it means that the inode appears in both snapshots. Here're three subcas=
es.
> >
> > First, if the inode has link counts of zero in both snapshots. Since th=
ere
> > are no paths for this inode in (source/destination) parent snapshots an=
d we
> > don't care about whether there is also an orphan inode in destination o=
r
> > not, we can set sctx->ignore_cur_inode on to prevent it from being crea=
ted.
> >
> > For the second and the third subcases, if there're paths in one snapsho=
t
> > and there're no paths in the other snapshot for this inode. We can trea=
t
> > this inode as a new generation. We can also leverage the logic handling=
 a
> > new generation of an inode with small adjustments. Then it will delete =
all
> > old paths and create a new inode with new attributes and paths only whe=
n
> > there's a positive link count in the send snapshot. In subcase 2, the
> > send operation only needs to delete all old paths as in the parent
> > snapshot. But it may require more operations for a directory to remove =
its
> > old paths. If a not-empty directory is going to be deleted (because it =
has
> > a link count of zero in the send snapshot) but there're files/directori=
es
> > with bigger inode numbers under it, the send operation will need to ren=
ame
> > it to its orphan name first. After processing and deleting the last ite=
m
> > under this directory, the send operation will check this directory, aka
> > the parent directory of the last item, again and issue a rmdir operatio=
n
> > to remove it finally. Therefore, we also need to treat inodes with a li=
nk
> > count of zero as if they didn't exist in get_cur_inode_state(), which i=
s
> > used in process_recorded_refs(). By doing this, when reviewing a direct=
ory
> > with orphan names after the last item under it has been deleted, the se=
nd
> > operation now can properly issue a rmdir operation. Otherwise, without
> > doing this, the orphan directory with an orphan name would be kept here
> > at the end due to the existing inode with a link count of zero being fo=
und.
> > In subcase 3, as in case 2, no old paths would be found, so no deletion
> > operations will be issued. The send operation will only create a new on=
e
> > for that inode.
> >
> > Note that subcase 3 is not a common case. That's because it's easy to
> > reduce the hard links of an inode, but once all valid paths are removed=
,
> > there're no valid paths for creating other hard links. The only way to =
do
> > that is trying to send an older snapshot after a newer snapshot has bee=
n
> > sent.
> >
> > Cc: <stable@vger.kernel.org> # 4.9: 46b2f4590aab: Btrfs: fix send
> > failure when root has deleted files still open
> > Cc: <stable@vger.kernel.org> # 4.9: 71ecfc133b03: btrfs: send:
> > introduce recorded_ref_alloc and recorded_ref_free
> > Cc: <stable@vger.kernel.org> # 4.9: 3aa5bd367fa5: btrfs: send: fix
> > sending link commands for existing file paths
> > Cc: <stable@vger.kernel.org> # 4.9: 0d8869fb6b6f8: btrfs: send: always
> > use the rbtree based inode ref management infrastructure
>
> Btw, lines with CC, Fixes, etc, tags should not be broken even if they
> are wider than 74 characters.
>

Okay, thank you for telling me that.

> So, in v1 when I gave you that example of CC stable tags, it wasn't
> meant for you to literally copy-paste them.
>
> First I asked if the purpose of the original Fixes tag was to backport
> the fix to stable releases.
> Was that the intention? You didn't provide an answer about that.
>

Oh, I misunderstood your suggestion. I'm sorry about that.
Our intention is to report this bug and try to provide a reasonable and
acceptable fix for it. Backporting is not our goal.

> Then I told if that was the case, the proper way would be adding CC
> stable tags and listing any
> dependencies. I gave those 4 as examples with commits that are fairly
> recent and obvious dependencies,
> but I also said that probably there's a lot more missing - especially
> if we want to backport to as far as 4.9.
>

> Even with just those 4 dependencies, some of those commits are fairly
> large, and that may be frowned upon
> according to stable backport rules (listed at
> https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst)=
.
> For e.g., patches with over 100 lines changed.
>
> Now, did you actually verify if there were more dependencies? (and test)
> And do you really want to go as far as 4.9 (currently the oldest
> stable release)?

No, I didn't. I used to think the CC tag was a very cool feature, which
just putting a few commits lets backport easily when I read your mail,
so I copied and pasted these 4 commits in the beginning of revising
the patch v2. However, I'm wrong.

> I seriously doubt that those 4 commits are the only dependencies in
> order to be able to cleanly backport to 4.9 and other old branches.
>
> It may be better to backport only to a few younger stable branches, or
> just provide later a version of the patch to
> apply to each desired stable branch (once the fix is in Linus' tree
> and in a -rc release).
>
> If you are not interested in backporting to stable or don't have the
> time to verify the dependencies and test, then just remove all the
> stable tags.
> Just leave a fixes tag:
>
> Fixes: 31db9f7c23fbf7 ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/re=
ceive")
>

Since backporting is not our goal. I will just leave the fix tag here.

> Also, please don't forget to send a test case for fstests, covering as
> many cases as possible (not just the example
> at the beginning of the changelog).
>

Okay, I will submit a test case covering all cases.
Because I still need to spend time learning how to use the fssum utility
for the last test case you reviewed, so I will submit the test case later.

Thanks.

> Thanks.
>
> > Reviewed-by: Robbie Ko <robbieko@synology.com>
> > Signed-off-by: BingJing Chang <bingjingc@synology.com>
> > ---
> >  fs/btrfs/send.c | 214 +++++++++++++++++++-----------------------------
> >  1 file changed, 85 insertions(+), 129 deletions(-)
> >
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index f8d77a33b9b7..6ab1ba66ff4b 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -850,6 +850,7 @@ struct btrfs_inode_info {
> >         u64 gid;
> >         u64 rdev;
> >         u64 attr;
> > +       u64 nlink;
> >  };
> >
> >  /*
> > @@ -888,6 +889,7 @@ static int get_inode_info(struct btrfs_root *root, =
u64 ino,
> >         info->uid =3D btrfs_inode_uid(path->nodes[0], ii);
> >         info->gid =3D btrfs_inode_gid(path->nodes[0], ii);
> >         info->rdev =3D btrfs_inode_rdev(path->nodes[0], ii);
> > +       info->nlink =3D btrfs_inode_nlink(path->nodes[0], ii);
> >         /*
> >          * Transfer the unchanged u64 value of btrfs_inode_item::flags,=
 that's
> >          * otherwise logically split to 32/32 parts.
> > @@ -1652,19 +1654,22 @@ static int get_cur_inode_state(struct send_ctx =
*sctx, u64 ino, u64 gen)
> >         int right_ret;
> >         u64 left_gen;
> >         u64 right_gen;
> > +       struct btrfs_inode_info info;
> >
> > -       ret =3D get_inode_gen(sctx->send_root, ino, &left_gen);
> > +       ret =3D get_inode_info(sctx->send_root, ino, &info);
> >         if (ret < 0 && ret !=3D -ENOENT)
> >                 goto out;
> > -       left_ret =3D ret;
> > +       left_ret =3D (info.nlink =3D=3D 0) ? -ENOENT : ret;
> > +       left_gen =3D info.gen;
> >
> >         if (!sctx->parent_root) {
> >                 right_ret =3D -ENOENT;
> >         } else {
> > -               ret =3D get_inode_gen(sctx->parent_root, ino, &right_ge=
n);
> > +               ret =3D get_inode_info(sctx->parent_root, ino, &info);
> >                 if (ret < 0 && ret !=3D -ENOENT)
> >                         goto out;
> > -               right_ret =3D ret;
> > +               right_ret =3D (info.nlink =3D=3D 0) ? -ENOENT : ret;
> > +               right_gen =3D info.gen;
> >         }
> >
> >         if (!left_ret && !right_ret) {
> > @@ -6413,86 +6418,6 @@ static int finish_inode_if_needed(struct send_ct=
x *sctx, int at_end)
> >         return ret;
> >  }
> >
> > -struct parent_paths_ctx {
> > -       struct list_head *refs;
> > -       struct send_ctx *sctx;
> > -};
> > -
> > -static int record_parent_ref(int num, u64 dir, int index, struct fs_pa=
th *name,
> > -                            void *ctx)
> > -{
> > -       struct parent_paths_ctx *ppctx =3D ctx;
> > -
> > -       /*
> > -        * Pass 0 as the generation for the directory, we don't care ab=
out it
> > -        * here as we have no new references to add, we just want to de=
lete all
> > -        * references for an inode.
> > -        */
> > -       return record_ref_in_tree(&ppctx->sctx->rbtree_deleted_refs, pp=
ctx->refs,
> > -                                 name, dir, 0, ppctx->sctx);
> > -}
> > -
> > -/*
> > - * Issue unlink operations for all paths of the current inode found in=
 the
> > - * parent snapshot.
> > - */
> > -static int btrfs_unlink_all_paths(struct send_ctx *sctx)
> > -{
> > -       LIST_HEAD(deleted_refs);
> > -       struct btrfs_path *path;
> > -       struct btrfs_root *root =3D sctx->parent_root;
> > -       struct btrfs_key key;
> > -       struct btrfs_key found_key;
> > -       struct parent_paths_ctx ctx;
> > -       int iter_ret =3D 0;
> > -       int ret;
> > -
> > -       path =3D alloc_path_for_send();
> > -       if (!path)
> > -               return -ENOMEM;
> > -
> > -       key.objectid =3D sctx->cur_ino;
> > -       key.type =3D BTRFS_INODE_REF_KEY;
> > -       key.offset =3D 0;
> > -
> > -       ctx.refs =3D &deleted_refs;
> > -       ctx.sctx =3D sctx;
> > -
> > -       btrfs_for_each_slot(root, &key, &found_key, path, iter_ret) {
> > -               if (found_key.objectid !=3D key.objectid)
> > -                       break;
> > -               if (found_key.type !=3D key.type &&
> > -                   found_key.type !=3D BTRFS_INODE_EXTREF_KEY)
> > -                       break;
> > -
> > -               ret =3D iterate_inode_ref(root, path, &found_key, 1,
> > -                                       record_parent_ref, &ctx);
> > -               if (ret < 0)
> > -                       goto out;
> > -       }
> > -       /* Catch error found during iteration */
> > -       if (iter_ret < 0) {
> > -               ret =3D iter_ret;
> > -               goto out;
> > -       }
> > -
> > -       while (!list_empty(&deleted_refs)) {
> > -               struct recorded_ref *ref;
> > -
> > -               ref =3D list_first_entry(&deleted_refs, struct recorded=
_ref, list);
> > -               ret =3D send_unlink(sctx, ref->full_path);
> > -               if (ret < 0)
> > -                       goto out;
> > -               recorded_ref_free(ref);
> > -       }
> > -       ret =3D 0;
> > -out:
> > -       btrfs_free_path(path);
> > -       if (ret)
> > -               __free_recorded_refs(&deleted_refs);
> > -       return ret;
> > -}
> > -
> >  static void close_current_inode(struct send_ctx *sctx)
> >  {
> >         u64 i_size;
> > @@ -6583,25 +6508,37 @@ static int changed_inode(struct send_ctx *sctx,
> >          * file descriptor against it or turning a RO snapshot into RW =
mode,
> >          * keep an open file descriptor against a file, delete it and t=
hen
> >          * turn the snapshot back to RO mode before using it for a send
> > -        * operation. So if we find such cases, ignore the inode and al=
l its
> > -        * items completely if it's a new inode, or if it's a changed i=
node
> > -        * make sure all its previous paths (from the parent snapshot) =
are all
> > -        * unlinked and all other the inode items are ignored.
> > +        * operation. The former is what the receiver operation does.
> > +        * Therefore, if we want to send these snapshots soon after the=
y're
> > +        * received, we need to handle orphan inodes as well. Moreover,
> > +        * orphans can appear not only in the send snapshot but also in=
 the
> > +        * parent snapshot. Here are several cases:
> > +        *
> > +        * Case 1: BTRFS_COMPARE_TREE_NEW
> > +        *       |  send snapshot  | action
> > +        * --------------------------------
> > +        * nlink |        0        | ignore
> > +        *
> > +        * Case 2: BTRFS_COMPARE_TREE_DELETED
> > +        *       | parent snapshot | action
> > +        * ----------------------------------
> > +        * nlink |        0        | as usual
> > +        * Note: No unlinks will be sent because there're no paths for =
it.
> > +        *
> > +        * Case 3: BTRFS_COMPARE_TREE_CHANGED
> > +        *           |       | parent snapshot | send snapshot | action
> > +        * ------------------------------------------------------------=
-----------
> > +        * subcase 1 | nlink |        0        |       0       | ignore
> > +        * subcase 2 | nlink |       >0        |       0       | new_ge=
n(deletion)
> > +        * subcase 3 | nlink |        0        |      >0       | new_ge=
n(creation)
> > +        *
> >          */
> > -       if (result =3D=3D BTRFS_COMPARE_TREE_NEW ||
> > -           result =3D=3D BTRFS_COMPARE_TREE_CHANGED) {
> > -               u32 nlinks;
> > -
> > -               nlinks =3D btrfs_inode_nlink(sctx->left_path->nodes[0],=
 left_ii);
> > -               if (nlinks =3D=3D 0) {
> > +       if (result =3D=3D BTRFS_COMPARE_TREE_NEW) {
> > +               if (btrfs_inode_nlink(sctx->left_path->nodes[0], left_i=
i) =3D=3D
> > +                                     0) {
> >                         sctx->ignore_cur_inode =3D true;
> > -                       if (result =3D=3D BTRFS_COMPARE_TREE_CHANGED)
> > -                               ret =3D btrfs_unlink_all_paths(sctx);
> >                         goto out;
> >                 }
> > -       }
> > -
> > -       if (result =3D=3D BTRFS_COMPARE_TREE_NEW) {
> >                 sctx->cur_inode_gen =3D left_gen;
> >                 sctx->cur_inode_new =3D true;
> >                 sctx->cur_inode_deleted =3D false;
> > @@ -6622,6 +6559,18 @@ static int changed_inode(struct send_ctx *sctx,
> >                 sctx->cur_inode_mode =3D btrfs_inode_mode(
> >                                 sctx->right_path->nodes[0], right_ii);
> >         } else if (result =3D=3D BTRFS_COMPARE_TREE_CHANGED) {
> > +               u32 new_nlinks, old_nlinks;
> > +
> > +               new_nlinks =3D btrfs_inode_nlink(sctx->left_path->nodes=
[0],
> > +                                              left_ii);
> > +               old_nlinks =3D btrfs_inode_nlink(sctx->right_path->node=
s[0],
> > +                                              right_ii);
> > +               if (new_nlinks =3D=3D 0 && old_nlinks =3D=3D 0) {
> > +                       sctx->ignore_cur_inode =3D true;
> > +                       goto out;
> > +               } else if (new_nlinks =3D=3D 0 || old_nlinks =3D=3D 0) =
{
> > +                       sctx->cur_inode_new_gen =3D 1;
> > +               }
> >                 /*
> >                  * We need to do some special handling in case the inod=
e was
> >                  * reported as changed with a changed generation number=
. This
> > @@ -6648,38 +6597,45 @@ static int changed_inode(struct send_ctx *sctx,
> >                         /*
> >                          * Now process the inode as if it was new.
> >                          */
> > -                       sctx->cur_inode_gen =3D left_gen;
> > -                       sctx->cur_inode_new =3D true;
> > -                       sctx->cur_inode_deleted =3D false;
> > -                       sctx->cur_inode_size =3D btrfs_inode_size(
> > -                                       sctx->left_path->nodes[0], left=
_ii);
> > -                       sctx->cur_inode_mode =3D btrfs_inode_mode(
> > -                                       sctx->left_path->nodes[0], left=
_ii);
> > -                       sctx->cur_inode_rdev =3D btrfs_inode_rdev(
> > -                                       sctx->left_path->nodes[0], left=
_ii);
> > -                       ret =3D send_create_inode_if_needed(sctx);
> > -                       if (ret < 0)
> > -                               goto out;
> > +                       if (new_nlinks > 0) {
> > +                               sctx->cur_inode_gen =3D left_gen;
> > +                               sctx->cur_inode_new =3D true;
> > +                               sctx->cur_inode_deleted =3D false;
> > +                               sctx->cur_inode_size =3D btrfs_inode_si=
ze(
> > +                                               sctx->left_path->nodes[=
0],
> > +                                               left_ii);
> > +                               sctx->cur_inode_mode =3D btrfs_inode_mo=
de(
> > +                                               sctx->left_path->nodes[=
0],
> > +                                               left_ii);
> > +                               sctx->cur_inode_rdev =3D btrfs_inode_rd=
ev(
> > +                                               sctx->left_path->nodes[=
0],
> > +                                               left_ii);
> > +                               ret =3D send_create_inode_if_needed(sct=
x);
> > +                               if (ret < 0)
> > +                                       goto out;
> >
> > -                       ret =3D process_all_refs(sctx, BTRFS_COMPARE_TR=
EE_NEW);
> > -                       if (ret < 0)
> > -                               goto out;
> > -                       /*
> > -                        * Advance send_progress now as we did not get =
into
> > -                        * process_recorded_refs_if_needed in the new_g=
en case.
> > -                        */
> > -                       sctx->send_progress =3D sctx->cur_ino + 1;
> > +                               ret =3D process_all_refs(sctx,
> > +                                               BTRFS_COMPARE_TREE_NEW)=
;
> > +                               if (ret < 0)
> > +                                       goto out;
> > +                               /*
> > +                                * Advance send_progress now as we did =
not get
> > +                                * into process_recorded_refs_if_needed=
 in the
> > +                                * new_gen case.
> > +                                */
> > +                               sctx->send_progress =3D sctx->cur_ino +=
 1;
> >
> > -                       /*
> > -                        * Now process all extents and xattrs of the in=
ode as if
> > -                        * they were all new.
> > -                        */
> > -                       ret =3D process_all_extents(sctx);
> > -                       if (ret < 0)
> > -                               goto out;
> > -                       ret =3D process_all_new_xattrs(sctx);
> > -                       if (ret < 0)
> > -                               goto out;
> > +                               /*
> > +                                * Now process all extents and xattrs o=
f the
> > +                                * inode as if they were all new.
> > +                                */
> > +                               ret =3D process_all_extents(sctx);
> > +                               if (ret < 0)
> > +                                       goto out;
> > +                               ret =3D process_all_new_xattrs(sctx);
> > +                               if (ret < 0)
> > +                                       goto out;
> > +                       }
> >                 } else {
> >                         sctx->cur_inode_gen =3D left_gen;
> >                         sctx->cur_inode_new =3D false;
> > --
> > 2.37.1
> >
