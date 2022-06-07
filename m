Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611AD53FB3D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbiFGKaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241083AbiFGKaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:30:14 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF856205;
        Tue,  7 Jun 2022 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654597807;
        bh=KXmvrCVmPTp9ETroo0GXYDXtE5AGQuVE2j1m4dG2o+k=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=HGmtUudUHxMdWG4UG8enWT++g9V6NYhFjfdl3L2orVfp0anulC2P2jQpa23sUth3W
         KZfj4s5VD9z6dF8afmkKe42RzK2+G6aYyCku92aZ20t6bw6Ae2n/IzF4cS0f4WCThp
         m4i/zxudANSs7iZ59ZXG7/Cunrs9oMR2R6xaaWB8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MCbIn-1o6Sx31pch-009hEa; Tue, 07
 Jun 2022 12:30:07 +0200
Message-ID: <532d5fd2-e93b-2fec-72d3-d0b0f099e541@gmx.com>
Date:   Tue, 7 Jun 2022 18:30:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] btrfs: correctly populate
 btrfs_super_block::log_root_transid
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <f7ae86f509d11d941ceac2a153b38a4f3bc5d342.1654578537.git.wqu@suse.com>
 <20220607094055.GB3554947@falcondesktop>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220607094055.GB3554947@falcondesktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/LcIXZubzgIkLmPUkUPkUJx3DyZ+T3OzDHH48uI6VwGqdpRJUqd
 QJDAejZh8+RC+rvazGbQLNACgs9Umc/gd5b9JEJ61uhYsugEMLRb2iutAmHN7XcbB/JX3oS
 E5ZMjn6SLKbGhtMMk+hcF1KI3WeMCM1F243qK48XFRrCGu7cMw1LReoo7YAYIXcXUYONYlP
 lJHRdDaJz/pCre0WmKc6w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Szf3RQdGzEo=:gCUye8o1jFgHpPwbpi8ham
 +x8qmCXChPlXeg4qk1hHVrNL3W01Kb+nnEjZgyN6DFMaQcPQQOmCF+VfgyIIsBi4Wqa24Trty
 vCbm57jJwmcSfsbCIwnDRMHtfxnrF+5lATo3Gjt6OECVRzKBXQKOAxKoMJ0Tat/g9dlsMryZ5
 9jmNvAsOhthbPR4f45Z4IXPFyKwzei3un+VSpHslsNx77RHQ3pVRH5k2SxKaQSIZzDbSqXPE/
 6ytUlnZ+eat0/WvlVkoYytHOVTegdlwV8gOhJB7wlgvb++TflaSCX/pdRcLSUkO7XZwSXcE+Y
 C+SJRujm09o7nZwfBpggsjV69r89MJt4gqlOZpqzQbjCshop22WvMbltkIqVunXhjMHVin89y
 dE6g4EhhDQaGNMvKBAxM2LTyL6cRO5M4Vox3roN9mN6i8Euui2kRybFou1PlXplJ9GwCutl3D
 C9pJAB1NztJiTuSw6TJ1NPrVFvGOH9LuIZDXOL9hhDDI7KeafdZdslgyQDyAYzNTXxtooXjlZ
 getmCudWIRMyymHbB7zag3vokyuHUJ8HHhOeHCwSaGrW14RD2ahmN4Swox/qfk4Ass6g4lvjt
 e0StbfsXmGiz/7bFLL6nxnd/fHeaUuscWREDUGH5hddgBbdoCrE3GrxIKxunu/rnv8CNVpsZ0
 jCJ4Jq4yg7gc7nBgFApoCcIx2uyns3BcyR2w0IupYF7aG4ApEgPLFvsZa8svAR129szTgplEJ
 hh9YeTu2hIrHYdP+W/XkOZo1qqUdvHWwnQniCQwsDy12XgqA3lkwaDhmfyyN6BRa5y/p9b2I2
 Gm52TsUHfQL3kHhMzhEzwm1v/uK4q9QxAwYOQe4FhMxSXzKZMLvWMyno8VE8OqmK5sFClTUbQ
 pWJS2hNgo5zH4AyXr2qZvb/MHccX6QGxxcR6jnuwBkfmLIiLn6VGMuG8+XtKydw7qfGNzYl8o
 RZhRBEBsF0HWq6FFeNjJw/ftd9T/Y71paMqS8LgeAehQJ1d7Kp6KRGKwyFJgcSYiygE+aWYUT
 WaacjV8meAhZl24fZ5sC4e1WG/5eZyzjlKw/DBkkWzgqqiDlR4X2ysZhPM+LwAjYcA0pb0pZ5
 3OwxWSpt6lU1jrCaFg/yA4ppq/6CFxz7Lah6A/QnYSMKlyalgpLSUvcTA==
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/6/7 17:40, Filipe Manana wrote:
> On Tue, Jun 07, 2022 at 01:09:13PM +0800, Qu Wenruo wrote:
>> [BUG]
>> After creating a dirty log tree, although
>> btrfs_super_block::log_root and log_root_level is correctly populated,
>> its generation is still left 0:
>>
>>   log_root                30474240
>>   log_root_transid        0 <<<
>>   log_root_level          0
>>
>> [CAUSE]
>> We just forgot to update btrfs_super_block::log_root_transid completely=
.
>>
>> Thus it's always the original value (0) from the initial super block.
>>
>> Thankfully this old behavior won't break log replay, as in
>> btrfs_read_tree(), parent generation 0 means we just skip the generatio=
n
>
> btrfs_read_tree() does not exists, it's btrfs_read_tree_root().
>
> This is actually irrelevant, because we don't read the root log tree wit=
h
> btrfs_read_tree_root(). We use read_tree_block() for that (at btrfs_repl=
ay_log()),

Oh, right, I forgot to check that code, and just assumed every root read
from superblock would has its generation checked, but it's not the case
for log tree root.

> and we use a generation matching the committed transaction + 1 (as it ca=
n never
> be anything else).
>
> For every other log tree, we use btrfs_read_tree_root(), but the generat=
ion is
> stored in the root's root item stored in the root log tree.
>
> The log_root_transid field was added to the super block by:
>
> commit c3027eb5523d6983f12628f3fe13d8a7576db701
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Mon Dec 8 16:40:21 2008 -0500
>
>      Btrfs: Add inode sequence number for NFS and reserved space in a fe=
w structs
>
> But it was never used.
>
> So this change is not needed.

Then, considering we have never really set log_root_transid anywhere,
and in theory we're always using btrfs_super_block::generation + 1, why
not just deprecate that member?

In fact, every time (thankfully not that many times for me) I checked
log_root_transid, I can not help but to wonder why it's always 0.

Thanks,
Qu

>
> Thanks.
>
>
>> check.
>>
>> And per-root log tree is still done properly using the root generation,
>> so here we really only missed the generation check for log tree root,
>> and even we fixed it, it should not cause any compatible problem.
>>
>> [FIX]
>> Just update btrfs_super_block::log_root_transid properly.
>
> We don't need this.
>
> The log_root_transid field was added to the super block by:
>
> commit c3027eb5523d6983f12628f3fe13d8a7576db701
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Mon Dec 8 16:40:21 2008 -0500
>
>      Btrfs: Add inode sequence number for NFS and reserved space in a fe=
w structs
>
> But it was never used.
> For btrfs_read_tree_root(), what we use is the
>
>
>
>>
>> Cc: stable@vger.kernel.org #4.9+
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/tree-log.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 370388fadf96..27a76d6fef8c 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -3083,7 +3083,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *tra=
ns,
>>   	struct btrfs_log_ctx root_log_ctx;
>>   	struct blk_plug plug;
>>   	u64 log_root_start;
>> -	u64 log_root_level;
>> +	u64 log_root_transid;
>> +	u8 log_root_level;
>>
>>   	mutex_lock(&root->log_mutex);
>>   	log_transid =3D ctx->log_transid;
>> @@ -3297,6 +3298,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *tra=
ns,
>>
>>   	log_root_start =3D log_root_tree->node->start;
>>   	log_root_level =3D btrfs_header_level(log_root_tree->node);
>> +	log_root_transid =3D btrfs_header_generation(log_root_tree->node);
>>   	log_root_tree->log_transid++;
>>   	mutex_unlock(&log_root_tree->log_mutex);
>>
>> @@ -3334,6 +3336,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *tra=
ns,
>>
>>   	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
>>   	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_l=
evel);
>> +	btrfs_set_super_log_root_transid(fs_info->super_for_commit, log_root_=
transid);
>>   	ret =3D write_all_supers(fs_info, 1);
>>   	mutex_unlock(&fs_info->tree_log_mutex);
>>   	if (ret) {
>> --
>> 2.36.1
>>
