Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC81F65115E
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 18:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLSRwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiLSRwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 12:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C83DF5F;
        Mon, 19 Dec 2022 09:52:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83093B80E28;
        Mon, 19 Dec 2022 17:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95961C433EF;
        Mon, 19 Dec 2022 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671472365;
        bh=9gyLtjRirqJ+ePdyNuABoYrBdKSYXBIBumgFVi+Cdac=;
        h=From:To:Cc:Subject:Date:From;
        b=IdImKSqr77DpONvqWsJ8ltMtA9V2/EiVntsYmCgVgPSHloFemWF+h9YaSgEyEFPgF
         0KzZgo1tPPycn7KDZJBln6oz8aWLhQH7oX2e2epqmf+Tw/88JdmIQvGbYi3lwfQe5F
         44lf/nBFTyriE+ji3gVGygW4xtC3vFBdDVvPYl3QTOzf5F96z2NVCxLC9BQkpPoNA2
         vri+C5hBNYIoE/8EEsCxALqtTLhyuG9Wlbu/Ry2Q/b1p8lmN6BIFgC58t93bGKH4VA
         YuRbjrfKG7KNQdPO0Msr4NYf+RWAqVUTeNcwY7UmmmuC0UHGQ/JSmVDNeqX25GsKda
         Xfatwwc2jhdEw==
From:   Christian Brauner <brauner@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ditang Chen <ditang.c@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] pnode: terminate for peers
Date:   Mon, 19 Dec 2022 18:52:30 +0100
Message-Id: <20221219175230.716541-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=24128; i=brauner@kernel.org; h=from:subject; bh=9gyLtjRirqJ+ePdyNuABoYrBdKSYXBIBumgFVi+Cdac=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQvWHLt8BqZv48D1pmf4TyRVlIev59377OdeYUnfnstuflW eesGj45SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJtBgz/JXOt7tx4PHf2QtU/674Zr S6pefUAtYtIcwGqvdCp2gz+55jZLjxmH3VrXuvq5RSjrRlTl94QOJxsPjOEn7vOUeP8a7vu8gCAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The propagate_mnt() functions handles mount propagation when creating mounts
and propagates the source mount tree headed by @source_mnt to the destination
propagation mount tree @dest_mnt. Unfortunately it contains a bug where it
fails to terminate correctly and causes a NULL dereference.

While fixing this bug we've gotten confused multiple times due to conflicting
or even missing terminology and concepts. So I want to start this with the
following clarifications:

* The terms "master" or "peer" denote a shared mount. A shared mount belongs to
  a peer group identified by a peer group id recorded in
  @shared_mnt->mnt_group_id. Shared mounts within the same peer group have the
  same peer group id. The peers in a peer group can be reached via
  @shared_mnt->mnt_share.

* Shared mounts may have dependent or "slave" mounts. These are listed on
  @shared_mnt->mnt_slave_list. Multiple peers in a peer group can have
  non-empty ->mnt_slave_lists and non-empty mnt_slave_lists of peers don't
  intersect. Consequently, to ensure all slave mounts of a peer group are
  visited the ->mnt_slave_lists of all peers in that peer group need to be
  walked.

* A slave mount is a dependent mount that receives propagation from the peers
  in a peer group it is a slave to. The closest peer group a slave mount
  receives propagation from can be identified by looking at the peer group id
  of the ->mnt_master of that slave mount, i.e., by looking at
  @slave_mnt->mnt_master->mnt_group_id. A slave mount to a peer group pg1 can
  itself be a peer in another peer group pg2. Such slaves will be called
  "shared-slave mounts" because they are both slave mounts to pg1 and a shared
  mount in a peer group pg2. Each shared-slave mount which is a peer in a peer
  group pg2 can be a slave mount to a different peer group. For example,
  @shared_slave_1->mnt_group_id = 1 and @shared_slave_2->mnt_group_id = 1 are
  peers in the peer group with peer group id 2. But
  @shared_slave_1->mnt_master->mnt_group_id = 2 and
  @shared_slave_1->mnt_master->mnt_group_id = 3 are slaves to different peer
  groups; @shared_slave_1 is a slave to peer group 2 and @shared_slave_2 is a
  slave to peer group 3. A slave that isn't a peer in another peer group, i.e.,
  is not a shared-slave mount will be called a "pure slave mount".

* A propagation group denotes the set of mounts consisting of a single peer
  group pg1 and all slave mounts and shared-slave mounts that receive
  propagation from this peer group, i.e., whose master is from pg1.
  Specifically, the boundary of a propagation group ends with its immediate
  slaves: It only encompasses the peers in that peer group and all slave mounts
  whose master is a mount in that peer group such that
  @slave_mnt->mnt_master->mnt_group_id is equal to @shared_mnt->mnt_group_id.
  IOW, it excludes the slave mounts of peer groups that shared-slave mounts of the
  peer group form. It makes it easier to talk about a single propagation
  "level" whereas a propagation tree usually refers to the set of mounts that
  receive propagation starting from a specific shared mount.

  For example, for propagate_mnt() a @dest_mnt is the start of a propagation
  tree. The peers in @dest_mnt's peer group and all slaves whose ->mnt_master
  points to a peer in @dest_mnt's peer group form a propagation group. The peer
  group of a shared-slave and the slave mounts whose ->mnt_master points to a
  peer in the shared-slave mount's peer group form another propagation group.

With that out of the way let's get to the actual algorithm. First,
propagate_mnt() propagates the @source_mnt tree to all peers in the peer group
of @dest_mnt. We know that @dest_mnt is guaranteed to be a shared mount as
attach_recursive_mnt() will have verified this for us:

for (n = next_peer(dest_mnt); n != dest_mnt; n = next_peer(n)) {
        ret = propagate_one(n);
        if (ret)
               goto out;
}

Notice, that it doesn't propagate @dest_mnt itself. That is because @dest_mnt
is mounted directly in attach_recursive_mnt(). This means that by the time
propagate_mnt() is called @source_mnt will not yet have been mounted on
@dest_mnt. Consequently,  @source_mnt->mnt_parent will still be pointing to
it's old parent - when the mount is moved - or to itself when it's a new or
bind-mount.

So for each peer @m in the peer group of @dest_mnt we create a new copy @child
of @source_mnt and mount it @m such that @child->mnt_parent is @m. This is
straightforward and no further steps are required.

After having finished propagating @source_mnt to the peers in @dest_mnt's peer
group propagate_mnt() will propagate @source_mnt to the slaves of the peers in
@dest_mnt's peer group:

for (m = next_group(dest_mnt, dest_mnt); m;
                m = next_group(m, dest_mnt)) {
        /* everything in that slave group */
        n = m;
        do {
                ret = propagate_one(n);
                if (ret)
                        goto out;
                n = next_peer(n);
        } while (n != m);
}

The next_group() helper will take care to walk the destination propagation tree
by peer groups recursively. For each peer group that receives propagation it
ensures that we always find a peer in a peer group before we find any slaves of
that peer group. IOW, finding masters before slaves.

It is important to remember that propagating the @source_mnt tree to each mount
@m in the destination propagation tree simply means that we create and mount a
new copy @child of the @source_mnt tree on @m such that @child->mnt_parent is @m.

The tricky part is to figure out what the masters of the new copies of
@source_mnt will be when mounted on their new parent @m in the destination
propagation tree. This is tricky because we must keep track of the last
propagation node @m in the destination propagation tree headed by @dest_mnt and
the corresponding copy of @source_mnt we created and mounted at @. We track the
former in @last_dest and we track the later in @last_source. So with each call
to propagate_one() we advance @last_dest and @last_source to @m and @child were
@child is the copy of @last_source we created.

The easy case is what @m and @last_dest are peers as we know that we can simply
copy @last_source without having to figure out what the master for the new copy
@child of @last_source needs to be.

The hard case is when we're dealing with a slave mount or a new shared-slave
mount @m in a destination propagation group.

First, we lookup the master of @m. If we haven't descended into a separate
propagation group that @dest_mnt propagates to yes then we don't have any
marked masters and the relevant master for @m will be @dest_mnt->mnt_master.
IOW, we walk the destination master chain all the way back up to
@dest_mnt->mnt_master and break:

for (n = m; ; n = p) {
        p = n->mnt_master;
        if (p == dest_master || IS_MNT_MARKED(p))
                break;
}

For each propagation node @m in the destination propagation tree headed
@dest_mnt we can walk up the peer group hierarchy by following the masters
@m->mnt_master of @m. Inevitably we will end up either @dest_mnt.

One the first slave mount @m of @dest_mnt in @dest_mnt's propagation group no
mount is marked yet. So the first iteration sets:

n = m;
p = n->mnt_master;

@p now points to @dest_mnt since that is it's master. We walk up one more level
since we don't have any marked mounts. So we end up with

n = dest_mnt;
p = dest_mnt->mnt_master;

Either dest_mnt is a pure shared mount then dest_mnt->mnt_master is NULL or
dest_mnt is a shared-slave and dest_mnt->mnt_master points to a master outside
the propagation tree we're dealing with.

Now we need to figure out the master for the copy of @last_source we're about
to create:

do {
        struct mount *parent = last_source->mnt_parent;
        if (last_source == first_source)
                break;
        done = parent->mnt_master == p;
        if (done && peers(n, parent))
                break;
        last_source = last_source->mnt_master;
} while (!done);

For the first slave mount of @dest_mnt's peer group we know that
@last_source->mnt_parent points to @last_dest. And we know that @last_dest
points to the last peer we handled in propagate_mnt()'s peer loop.
Consequently, @last_source->mnt_parent->mnt_master points to
@last_dest->mnt_master.

We also know that @last_dest->mnt_master is either NULL or points to a master
outside of the propagation tree:

done = parent->mnt_master == p;

is trivially true.

We also know that for the first slave mount of @dest_mnt that @last_dest either
points @dest_mnt itself because it was initialized to:

last_dest = dest_mnt;

at the beginning of propagate_mnt() or it will point to a peer of @dest_mnt in
its peer group. In both cases it is guaranteed that on the first iteration @n
and @parent are peers:

if (done && peers(n, parent))
        break;

This means that the master of the copy @child of @last_source we're going to
mount at @m needs to be @last_source. And we know that @last_source is set to
the last copy we created and mounted at the last destination node @m which was
a peer in @dest_mnt's peer group.

And since the master of the first destination propagation node @m we handled
after handling the peer of @dest_mnt's peer group is @dest_mnt - as it's a
slave mount of @dest_mnt - we mark this mount as a master.

Although less obvious, the lookup of the correct master for @last_source is
premised on the assumption that each copy of @source_mnt that is mounted on top
of @m we will allows us to similarly traverse the peer group hierarchy of the
destination propagation tree.

If we take @last_source which is the copy of @source_mnt we have mounted on @m
in previous iteration of propagate_one() then @last_source->mnt_master will
point to an earlier copy of @last_source that we mounted at the previous
destination propagation node @m. Hence, the first
@last_source->mnt_master->mnt_parent will point to @last_dest and
@last_dest->mnt_master will be our hook into the master hierarchy of the
destination propagation tree headed @dest_mnt.

Hence, by walking up @last_source->mnt_master we will walk up the new source
destination peer group hierarchy each anchored at a destination propagation
node @m in the destination propagation tree headed at @dest_mnt.

IOW, the destination propagation tree will be overlayed with copies of
@source_mnt. And when we're all done with this the sequence of copies of
@source_mnt we mounted on top the destination propagation nodes @m will mirror
the propagation of the destination nodes @m.

So, for each new destination propagation node @m we use the previous copy of
@last_source and previous destination propagation node @last_dest to determine
what the master of the new copy of @last_source has to be.

And with each destination propagation node @m we mount a copy of @source_mnt on
we will mark the peer which is the closest peer that @m receives propagation
from in the destination propagation tree.

For the next @m we search for a marked master which will be the closest peer
group that @m receives propagation from. We store that master in @p and record
the previous destination propagation node @n.

We then search for this master via @last_source by walking up the master
hierarchy based on the last copy of @last_source we mounted on the previous
destination propagation node.

Ultimately we will hit a master in the source propagation master hierarchy that
is mounted on a previous destination propagation node @m. We can access that @m
via @last_source->mnt_master->mnt_parent.

We will then find a master @last_source->mnt_master->mnt_parent->mnt_master
that will correspond to the closest marked peer group master @p we receive
propagation from and that we detected earlier.

Now, if @last_source->mnt_master->mnt_parent and @n are peers then we know that
the new master is the one we just looked up: @last_source. If they aren't peers
we know that the new master needs to be @last_source->mnt_master.

However, terminating the walk has corner cases...

If the closest marked master for a given destination node @m cannot be found by
walking up the master hierarchy based on @last_source then we need to terminate
the walk when we encounter @source_mnt as this means @source_mnt will be the
master of the new copy of @last_source we're about to create.

As @last_source might not have a master this would lead to a NULL dereference.
So we have to stop the walk when we encounter @source_mnt again.

In a way, this happens when we handled the last slave mount that is a slave to
a peer group that receives propagation from @dest_mnt's peer group, i.e., when
we "reascend" from handling slaves of peer groups deeper down the propagation
tree back to a slave mount that receives propagation in @dest_mnt's peer group
so a slave mount in @dest_mnt's propagation group.

So terminate on @source_mnt, easy peasy. Except, that it misses something what
the rest of the algorithm already handles.

If @dest_mnt has peers in it's peer group the first loop in propagate_mnt():

for (n = next_peer(dest_mnt); n != dest_mnt; n = next_peer(n)) {
        ret = propagate_one(n);
        if (ret)
                goto out;
}

will consecutively update @last_source such that after that loop terminates
@last_source will point to whatever copy was created for the last peer in that
peer group.

It is however guaranteed that if there is a single additional peer in
@dest_mnt's peer group that @last_source will __not__ point to @source_mnt
anymore. Because, as we mentioned above, @dest_mnt isn't even handled in this
loop but directly in attach_recursive_mnt().

So the first time we handle a slave mount @m of @dest_mnt's peer group the copy
of @last_source we create will make the __last copy for the last peer in
@dest_mnt's peer group__ we created the master of the copy that we now create
for the first slave mount of @dest_mnt's peer group.

But this means that the termination condition @source_mnt is wrong. The
@source_mnt cannot be found anymore by propagate_one(). Instead it will find
the copy we created for the last peer of @dest_mnt's peer group we processed in
the earlier peer loop. And that is a peer of @source_mnt not @source_mnt
itself.

IOW, we fail to terminate the lookup loop for the source master and ultimately
deref @last_source->mnt_master->mnt_parent when @last_source->mnt_master is
NULL because @source_mnt and it's peers are pure shared mounts, i.e., they
aren't slaves to another peer group.

For example, assume @dest_mnt is a pure shared mount and has three peers:

===================================================================================
                                         mount-id   mount-parent-id   peer-group-id
===================================================================================
(@dest_mnt) mnt_master[216]              309        297               shared:216
    \
     (@source_mnt) mnt_master[218]:      609        609               shared:218

(1) mnt_master[216]:                     607        605               shared:216
    \
     (P1) mnt_master[218]:               624        607               shared:218

(2) mnt_master[216]:                     576        574               shared:216
    \
     (P2) mnt_master[218]:               625        576               shared:218

(3) mnt_master[216]:                     545        543               shared:216
    \
     (P3) mnt_master[218]:               626        545               shared:218

After this sequence has been processed @last_source will point to (P3), the
copy generated for the third peer propagation we handled. So the first slave
of @dest_mnt's peer group we handle:

===================================================================================
                                         mount-id   mount-parent-id   peer-group-id
===================================================================================
    mnt_master[216]                      309        297               shared:216
   /
  /
(S0) mnt_slave                           483        481               master:216
  \
   \    (P3) mnt_master[218]             626        545               shared:218
    \  /
     \/
    (P4) mnt_slave                       627        483               master:218

we can see that (P3) will become the master of the copy of the new slave we
created in propagation (P4) and mounted on top of the first slave (S0) of
@dest_mnt.

On any give walk through the @last_source master hierarchy we generate we may
encounter (P3) but not @source_mnt itself. Ultimately leading to a NULL
dereference.

We can fix this in multiple ways. First, by setting:

@last_source = @source_mnt

after we processed the peers in @dest_mnt's peer group. Second, by changing the
termination condition that relies on finding exactly @source_mnt to find a peer
of @source_mnt. Third, by only moving @last_source when we actually venture
into a new peer group. The latter is more intrusive but something I'd like to
explore in the near future.

Now, we just do the minimally correct thing. Passes LTP and specifically the
mount propagation testsuite part of it and holds up against all reproducers.

Final words...
First, this is a clever but __worringly__ underdocumented algorithm. There
isn't a single detailed comment to be found in next_group(), propagate_one() or
anywhere else in that file for that matter. This has been a giant pain to
understand and work through and a bug like this is insanely difficult to fix
without detailed understanding of what's happening. Let's not talk about the
amount of time that was sunk into fixing this.

Second, all the cool kids with access to
unshare --mount --user --map-root --propagation=unchanged
are going to have a lot of fun.

[  115.848393] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  115.848967] #PF: supervisor read access in kernel mode
[  115.849386] #PF: error_code(0x0000) - not-present page
[  115.849803] PGD 0 P4D 0
[  115.850012] Oops: 0000 [#1] PREEMPT SMP PTI
[  115.850354] CPU: 0 PID: 15591 Comm: mount Not tainted 6.1.0-rc7 #3
[  115.850851] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  115.851510] RIP: 0010:propagate_one.part.0+0x7f/0x1a0
[  115.851924] Code: 75 eb 4c 8b 05 c2 25 37 02 4c 89 ca 48 8b 4a 10
49 39 d0 74 1e 48 3b 81 e0 00 00 00 74 26 48 8b 92 e0 00 00 00 be 01
00 00 00 <48> 8b 4a 10 49 39 d0 75 e2 40 84 f6 74 38 4c 89 05 84 25 37
02 4d
[  115.853441] RSP: 0018:ffffb8d5443d7d50 EFLAGS: 00010282
[  115.853865] RAX: ffff8e4d87c41c80 RBX: ffff8e4d88ded780 RCX: ffff8e4da4333a00
[  115.854458] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8e4d88ded780
[  115.855044] RBP: ffff8e4d88ded780 R08: ffff8e4da4338000 R09: ffff8e4da43388c0
[  115.855693] R10: 0000000000000002 R11: ffffb8d540158000 R12: ffffb8d5443d7da8
[  115.856304] R13: ffff8e4d88ded780 R14: 0000000000000000 R15: 0000000000000000
[  115.856859] FS:  00007f92c90c9800(0000) GS:ffff8e4dfdc00000(0000)
knlGS:0000000000000000
[  115.857531] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  115.858006] CR2: 0000000000000010 CR3: 0000000022f4c002 CR4: 00000000000706f0
[  115.858598] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  115.859393] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  115.860099] Call Trace:
[  115.860358]  <TASK>
[  115.860535]  propagate_mnt+0x14d/0x190
[  115.860848]  attach_recursive_mnt+0x274/0x3e0
[  115.861212]  path_mount+0x8c8/0xa60
[  115.861503]  __x64_sys_mount+0xf6/0x140
[  115.861819]  do_syscall_64+0x5b/0x80
[  115.862117]  ? do_faccessat+0x123/0x250
[  115.862435]  ? syscall_exit_to_user_mode+0x17/0x40
[  115.862826]  ? do_syscall_64+0x67/0x80
[  115.863133]  ? syscall_exit_to_user_mode+0x17/0x40
[  115.863527]  ? do_syscall_64+0x67/0x80
[  115.863835]  ? do_syscall_64+0x67/0x80
[  115.864144]  ? do_syscall_64+0x67/0x80
[  115.864452]  ? exc_page_fault+0x70/0x170
[  115.864775]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  115.865187] RIP: 0033:0x7f92c92b0ebe
[  115.865480] Code: 48 8b 0d 75 4f 0c 00 f7 d8 64 89 01 48 83 c8 ff
c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 42 4f 0c 00 f7 d8 64 89
01 48
[  115.866984] RSP: 002b:00007fff000aa728 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[  115.867607] RAX: ffffffffffffffda RBX: 000055a77888d6b0 RCX: 00007f92c92b0ebe
[  115.868240] RDX: 000055a77888d8e0 RSI: 000055a77888e6e0 RDI: 000055a77888e620
[  115.868823] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[  115.869403] R10: 0000000000001000 R11: 0000000000000246 R12: 000055a77888e620
[  115.869994] R13: 000055a77888d8e0 R14: 00000000ffffffff R15: 00007f92c93e4076
[  115.870581]  </TASK>
[  115.870763] Modules linked in: nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set rfkill nf_tables nfnetlink qrtr snd_intel8x0
sunrpc snd_ac97_codec ac97_bus snd_pcm snd_timer intel_rapl_msr
intel_rapl_common snd vboxguest intel_powerclamp video rapl joydev
soundcore i2c_piix4 wmi fuse zram xfs vmwgfx crct10dif_pclmul
crc32_pclmul crc32c_intel polyval_clmulni polyval_generic
drm_ttm_helper ttm e1000 ghash_clmulni_intel serio_raw ata_generic
pata_acpi scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_multipath
[  115.875288] CR2: 0000000000000010
[  115.875641] ---[ end trace 0000000000000000 ]---
[  115.876135] RIP: 0010:propagate_one.part.0+0x7f/0x1a0
[  115.876551] Code: 75 eb 4c 8b 05 c2 25 37 02 4c 89 ca 48 8b 4a 10
49 39 d0 74 1e 48 3b 81 e0 00 00 00 74 26 48 8b 92 e0 00 00 00 be 01
00 00 00 <48> 8b 4a 10 49 39 d0 75 e2 40 84 f6 74 38 4c 89 05 84 25 37
02 4d
[  115.878086] RSP: 0018:ffffb8d5443d7d50 EFLAGS: 00010282
[  115.878511] RAX: ffff8e4d87c41c80 RBX: ffff8e4d88ded780 RCX: ffff8e4da4333a00
[  115.879128] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8e4d88ded780
[  115.879715] RBP: ffff8e4d88ded780 R08: ffff8e4da4338000 R09: ffff8e4da43388c0
[  115.880359] R10: 0000000000000002 R11: ffffb8d540158000 R12: ffffb8d5443d7da8
[  115.880962] R13: ffff8e4d88ded780 R14: 0000000000000000 R15: 0000000000000000
[  115.881548] FS:  00007f92c90c9800(0000) GS:ffff8e4dfdc00000(0000)
knlGS:0000000000000000
[  115.882234] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  115.882713] CR2: 0000000000000010 CR3: 0000000022f4c002 CR4: 00000000000706f0
[  115.883314] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  115.883966] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: f2ebb3a921c1 ("smarter propagate_mnt()")
Cc: <stable@vger.kernel.org>
Reported-by: Ditang Chen <ditang.c@gmail.com>
Signed-off-by: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
If there are no big objections I'll get this to Linus rather sooner than later.
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/pnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pnode.c b/fs/pnode.c
index 1106137c747a..468e4e65a615 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -244,7 +244,7 @@ static int propagate_one(struct mount *m)
 		}
 		do {
 			struct mount *parent = last_source->mnt_parent;
-			if (last_source == first_source)
+			if (peers(last_source, first_source))
 				break;
 			done = parent->mnt_master == p;
 			if (done && peers(n, parent))

base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
-- 
2.34.1

