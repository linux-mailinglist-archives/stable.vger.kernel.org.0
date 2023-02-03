Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8CE688D31
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjBCCqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBCCqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:46:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C31234C8;
        Thu,  2 Feb 2023 18:46:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 58D151FEEA;
        Fri,  3 Feb 2023 02:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675392374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZMnm/2jYWDTaF6axONY6uYfF5PsbZNe+kFv6sGM66U=;
        b=GU7GyDlV0YOpuGDfwIwnmm0YPrGKwk3sL5c/RxewKwYdeAc5YMwv27XO7LMXPl3b6nzBm2
        H4LETGmOv+HZA2Y9XYF1bQzpMYo4hriAIccG7i+9OKOHep2Bgpmyv7FbMQWeRU5dEmhIy1
        piMzs5mZJuZjFcvUC4ug+E/7PBtD1s4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675392374;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZMnm/2jYWDTaF6axONY6uYfF5PsbZNe+kFv6sGM66U=;
        b=qMhSJCQXelnrN3DQt1bf3N8voydKfxH5VUL4r+JVl7lUuHeDu03EITJxtEvKoJMEZ3zscw
        7faY0PPj+CCjFYDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D8C81346D;
        Fri,  3 Feb 2023 02:46:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oiPCGnR13GPdfQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 03 Feb 2023 02:46:12 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: Remove some unnecessary NULL point check for the
 return value of __bch_btree_node_alloc-related pointer
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAJedcCzNB+1byPEzEgQ6ELjeoRQcZ=GnZg+1J4+FZvfnoK0H2Q@mail.gmail.com>
Date:   Fri, 3 Feb 2023 10:46:00 +0800
Cc:     Zheng Wang <zyytlz.wz@163.com>, stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alex000young@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A4D30F2-5FCB-4498-9571-12B320F4E1A1@suse.de>
References: <20230203022759.576832-1-zyytlz.wz@163.com>
 <CAJedcCzNB+1byPEzEgQ6ELjeoRQcZ=GnZg+1J4+FZvfnoK0H2Q@mail.gmail.com>
To:     Zheng Hacker <hackerzheng666@gmail.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=883=E6=97=A5 10:43=EF=BC=8CZheng Hacker =
<hackerzheng666@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello,
>=20
> After writing the patch, I found there may be more places to replace
> IS_ERR_OR_NULL to IS_ERR.
> If the alloc of node will never be NULL, the additional NULL check of
> nodes after allocation may also
> be useless. This patch just fixes the check around the alloc. I'm not
> sure about other places for my
> limited understanding of the code in bcache.

This was why I suggested you to post an extra cleanup patch like this.

You may just add more changes as you mentioned into this patch and post =
another updated version.

Thanks.

Coly Li

>=20
> Thanks,
> Zheng Wang
>=20
> Zheng Wang <zyytlz.wz@163.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=883=E6=97=A5=
=E5=91=A8=E4=BA=94 10:28=E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> Due to the previously fix of __bch_btree_node_alloc, the return value =
will
>> never be a NULL pointer. So IS_ERR is enough to handle the failure
>> situation. Fix it by replacing IS_ERR_OR_NULL check to IS_ERR check.
>>=20
>> Fixes: cafe56359144 ("bcache: A block layer cache")
>> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
>> ---
>> drivers/md/bcache/btree.c | 6 +++---
>> drivers/md/bcache/super.c | 2 +-
>> 2 files changed, 4 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 147c493a989a..417cd7c436c4 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -1138,7 +1138,7 @@ static struct btree =
*btree_node_alloc_replacement(struct btree *b,
>> {
>>        struct btree *n =3D bch_btree_node_alloc(b->c, op, b->level, =
b->parent);
>>=20
>> -       if (!IS_ERR_OR_NULL(n)) {
>> +       if (!IS_ERR(n)) {
>>                mutex_lock(&n->write_lock);
>>                bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
>>                bkey_copy_key(&n->key, &b->key);
>> @@ -1352,7 +1352,7 @@ static int btree_gc_coalesce(struct btree *b, =
struct btree_op *op,
>>=20
>>        for (i =3D 0; i < nodes; i++) {
>>                new_nodes[i] =3D btree_node_alloc_replacement(r[i].b, =
NULL);
>> -               if (IS_ERR_OR_NULL(new_nodes[i]))
>> +               if (IS_ERR(new_nodes[i]))
>>                        goto out_nocoalesce;
>>        }
>>=20
>> @@ -1669,7 +1669,7 @@ static int bch_btree_gc_root(struct btree *b, =
struct btree_op *op,
>>        if (should_rewrite) {
>>                n =3D btree_node_alloc_replacement(b, NULL);
>>=20
>> -               if (!IS_ERR_OR_NULL(n)) {
>> +               if (!IS_ERR(n)) {
>>                        bch_btree_node_write_sync(n);
>>=20
>>                        bch_btree_set_root(n);
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index ba3909bb6bea..92de714fe75e 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
>>=20
>>                err =3D "cannot allocate new btree root";
>>                c->root =3D __bch_btree_node_alloc(c, NULL, 0, true, =
NULL);
>> -               if (IS_ERR_OR_NULL(c->root))
>> +               if (IS_ERR(c->root))
>>                        goto err;
>>=20
>>                mutex_lock(&c->root->write_lock);
>> --
>> 2.25.1
>>=20

