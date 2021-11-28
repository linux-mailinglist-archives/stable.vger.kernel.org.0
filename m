Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047DC4605AE
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 11:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhK1KeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 05:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357110AbhK1KcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 05:32:07 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54B5C061746
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 02:28:51 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id k23so28591561lje.1
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 02:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uo499mLugJATaXr93SfSgunbw/0o9QRQJqTNtF0ykcs=;
        b=aRlQ2DmV7Za8T1e8KXBvzHs9+ToQujCjBCD4ZUjulmp2VXjXIeHaNIyPRqZqcgeD47
         D4pIQy2KE9Zqtq4fRbyKd4eoPhsDuu1AL3T8kzc7iJUS+YUR/Pbtd0zPwigzObRyfEsO
         kfMI39A1keuZxTlNvj4msLmEJGGCCkYvpmTjaVhj2+Ng3aam/IQduyRJ5FtLrTDwol4Q
         oPAR66LMdKCrP1se8ZGivnJkZ5aMdag6pwu/m4yMK+nxLDspOlCMlmDNF9jgFovURxyi
         6SuY902fLW9IKZ97sLxVgF0/ypzc4DECFNzmfXm9iyl+V2CVByghI4zFTRzosS80LwYl
         JUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uo499mLugJATaXr93SfSgunbw/0o9QRQJqTNtF0ykcs=;
        b=uW/qB1Qz4GoI//quoxoBPR3v51IQKEqisH4z6cfQ5888PbhqERf9KdttgPBGdjeFKs
         aQ0fmu2rBfPiz0dxM++iXRitSLOOYUbLcLbhqadBT4baTi+N/+43DsJr7gwh5LiY4qCn
         FvVX5gbYkK1t/3czJ6A8RZc3ACU25w6bOOkiTJ+jtyWKxtYl9V4eroUVuVu63sQzd3eG
         6AxlgBJINy/o97qMLFP4A0jKElqfoSOfzGy3CQX+2VBSSvSSH0wWQ+s3wiJvt9FkRIlJ
         fygZyZ3Nv8nCoNP8Eyu/8mYjAc3VOfjl4uXy/0q1U8lYq3KXj9Wc3nDrY2Bux+PtODFd
         +61A==
X-Gm-Message-State: AOAM531DosEphygT8rz0U2NzC3NlkL0nSOk0OjISKvLqz6t63QZ92dhG
        2iBJvUaESmAr+7q01kCbCguoBXeyYHFUWYaTySCWtTfvNJTMeg==
X-Google-Smtp-Source: ABdhPJyUe/087BcpdBQst6zjcxWWH/UIOxkgLfLHL5C2VYG9++qmUwKKDydOgkaLm9oNBtClrcIlN0CB8F7sNYSePOk=
X-Received: by 2002:a2e:5c04:: with SMTP id q4mr43473473ljb.334.1638095329955;
 Sun, 28 Nov 2021 02:28:49 -0800 (PST)
MIME-Version: 1.0
References: <1637577215186161@kroah.com> <20211125115809.354531-1-masami.ichikawa@cybertrust.co.jp>
 <YZ97xekHtjTvjRJw@kroah.com> <CACOXgS_HpBBKxrC7pDJy5Pw85LymfVJu9u1SasuHvc+6MD-bKw@mail.gmail.com>
 <YaIeqkVuJRE344jh@kroah.com>
In-Reply-To: <YaIeqkVuJRE344jh@kroah.com>
From:   Masami Ichikawa <masami256@gmail.com>
Date:   Sun, 28 Nov 2021 19:28:38 +0900
Message-ID: <CACOXgS88zDufgTH+icz5DAzeC0ubPNmy9yXTsgm5p8x=qEaWkA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix toctou on read-only map's constant scalar tracking
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        stable@vger.kernel.org, w1tcher.bupt@gmail.com,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 27, 2021 at 9:03 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 25, 2021 at 09:12:37PM +0900, Masami Ichikawa wrote:
> > On Thu, Nov 25, 2021 at 9:05 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Nov 25, 2021 at 08:58:10PM +0900, Masami Ichikawa(CIP) wrote:
> > > > From: Daniel Borkmann <daniel@iogearbox.net>
> > > >
> > > > commit 353050be4c19e102178ccc05988101887c25ae53 upstream
> > > >
> > > > Commit a23740ec43ba ("bpf: Track contents of read-only maps as scalars") is
> > > > checking whether maps are read-only both from BPF program side and user space
> > > > side, and then, given their content is constant, reading out their data via
> > > > map->ops->map_direct_value_addr() which is then subsequently used as known
> > > > scalar value for the register, that is, it is marked as __mark_reg_known()
> > > > with the read value at verification time. Before a23740ec43ba, the register
> > > > content was marked as an unknown scalar so the verifier could not make any
> > > > assumptions about the map content.
> > > >
> > > > The current implementation however is prone to a TOCTOU race, meaning, the
> > > > value read as known scalar for the register is not guaranteed to be exactly
> > > > the same at a later point when the program is executed, and as such, the
> > > > prior made assumptions of the verifier with regards to the program will be
> > > > invalid which can cause issues such as OOB access, etc.
> > > >
> > > > While the BPF_F_RDONLY_PROG map flag is always fixed and required to be
> > > > specified at map creation time, the map->frozen property is initially set to
> > > > false for the map given the map value needs to be populated, e.g. for global
> > > > data sections. Once complete, the loader "freezes" the map from user space
> > > > such that no subsequent updates/deletes are possible anymore. For the rest
> > > > of the lifetime of the map, this freeze one-time trigger cannot be undone
> > > > anymore after a successful BPF_MAP_FREEZE cmd return. Meaning, any new BPF_*
> > > > cmd calls which would update/delete map entries will be rejected with -EPERM
> > > > since map_get_sys_perms() removes the FMODE_CAN_WRITE permission. This also
> > > > means that pending update/delete map entries must still complete before this
> > > > guarantee is given. This corner case is not an issue for loaders since they
> > > > create and prepare such program private map in successive steps.
> > > >
> > > > However, a malicious user is able to trigger this TOCTOU race in two different
> > > > ways: i) via userfaultfd, and ii) via batched updates. For i) userfaultfd is
> > > > used to expand the competition interval, so that map_update_elem() can modify
> > > > the contents of the map after map_freeze() and bpf_prog_load() were executed.
> > > > This works, because userfaultfd halts the parallel thread which triggered a
> > > > map_update_elem() at the time where we copy key/value from the user buffer and
> > > > this already passed the FMODE_CAN_WRITE capability test given at that time the
> > > > map was not "frozen". Then, the main thread performs the map_freeze() and
> > > > bpf_prog_load(), and once that had completed successfully, the other thread
> > > > is woken up to complete the pending map_update_elem() which then changes the
> > > > map content. For ii) the idea of the batched update is similar, meaning, when
> > > > there are a large number of updates to be processed, it can increase the
> > > > competition interval between the two. It is therefore possible in practice to
> > > > modify the contents of the map after executing map_freeze() and bpf_prog_load().
> > > >
> > > > One way to fix both i) and ii) at the same time is to expand the use of the
> > > > map's map->writecnt. The latter was introduced in fc9702273e2e ("bpf: Add mmap()
> > > > support for BPF_MAP_TYPE_ARRAY") and further refined in 1f6cb19be2e2 ("bpf:
> > > > Prevent re-mmap()'ing BPF map as writable for initially r/o mapping") with
> > > > the rationale to make a writable mmap()'ing of a map mutually exclusive with
> > > > read-only freezing. The counter indicates writable mmap() mappings and then
> > > > prevents/fails the freeze operation. Its semantics can be expanded beyond
> > > > just mmap() by generally indicating ongoing write phases. This would essentially
> > > > span any parallel regular and batched flavor of update/delete operation and
> > > > then also have map_freeze() fail with -EBUSY. For the check_mem_access() in
> > > > the verifier we expand upon the bpf_map_is_rdonly() check ensuring that all
> > > > last pending writes have completed via bpf_map_write_active() test. Once the
> > > > map->frozen is set and bpf_map_write_active() indicates a map->writecnt of 0
> > > > only then we are really guaranteed to use the map's data as known constants.
> > > > For map->frozen being set and pending writes in process of still being completed
> > > > we fall back to marking that register as unknown scalar so we don't end up
> > > > making assumptions about it. With this, both TOCTOU reproducers from i) and
> > > > ii) are fixed.
> > > >
> > > > Note that the map->writecnt has been converted into a atomic64 in the fix in
> > > > order to avoid a double freeze_mutex mutex_{un,}lock() pair when updating
> > > > map->writecnt in the various map update/delete BPF_* cmd flavors. Spanning
> > > > the freeze_mutex over entire map update/delete operations in syscall side
> > > > would not be possible due to then causing everything to be serialized.
> > > > Similarly, something like synchronize_rcu() after setting map->frozen to wait
> > > > for update/deletes to complete is not possible either since it would also
> > > > have to span the user copy which can sleep. On the libbpf side, this won't
> > > > break d66562fba1ce ("libbpf: Add BPF object skeleton support") as the
> > > > anonymous mmap()-ed "map initialization image" is remapped as a BPF map-backed
> > > > mmap()-ed memory where for .rodata it's non-writable.
> > > >
> > > > Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
> > > > Reported-by: w1tcher.bupt@gmail.com
> > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > [fix conflict to call bpf_map_write_active_dec() in err_put block.
> > > > fix conflict to insert new functions after find_and_alloc_map().]
> > > > Reference: CVE-2021-4001
> > > > Signed-off-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
> > > > ---
> > > >  include/linux/bpf.h   |  3 ++-
> > > >  kernel/bpf/syscall.c  | 57 +++++++++++++++++++++++++++----------------
> > > >  kernel/bpf/verifier.c | 17 ++++++++++++-
> > > >  3 files changed, 54 insertions(+), 23 deletions(-)
> > >
> > > What stable tree(s) is this for?
> > >
> >
> > I'm sorry that I forgot to specify stable tree name.
> > This patch is for 5.10.y branch.
>
> Wonderful, I will go queue it up now.
>

Thank you.

> Can you also provide a version for 5.4?  It is needed there as well.
>

I tried backporting to 5.4.y branch but 353050 ("bpf: Fix toctou on
read-only map's constant scalar tracking ") is based on several
commits that don't exist in the stable/linux-5.4.y branch. At least I
found following commits are needed.

- fc97022 ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
- 1f6cb19 ("bpf: Prevent re-mmap()'ing BPF map as writable for
initially r/o mapping")
- 196e8ca ("bpf: Switch bpf_map_{area_alloc,area_mmapable_alloc}() to
u64 size ")
- cb4d03a ("bpf: Add generic support for lookup batch op")

So I couldn't simply apply 353050 to 5.4 .y branch.
Sorry for inconvenient.

> thanks,
>
> greg k-h


Regards,

-- 
/**
* Masami Ichikawa
* personal: masami256@gmail.com
* fedora project: masami@fedoraproject.org
*/
