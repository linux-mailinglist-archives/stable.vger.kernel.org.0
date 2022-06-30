Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A569C561E19
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbiF3OhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiF3Ogz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:36:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D08F2182E
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 07:32:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 056411F95F;
        Thu, 30 Jun 2022 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656599546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFrSb5rn5sze93pxbnnBv+DOcO7ZLxJVgw5Dy19x62A=;
        b=gs/1nfDFnam6XeZfVO5JVEj7tTwziKErf6uHQm1MWjXbiYWZ+BUY/k9GzExc8YC2KRo5an
        fMFuD2oYEWFzPLOK/D/M9XDss5balEH+wLTgdeNDinnptZJ4GjwEsS69TpxO+eehrmHnda
        X+kGD6QD6QSy813+mYt01cVack2wlDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656599546;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFrSb5rn5sze93pxbnnBv+DOcO7ZLxJVgw5Dy19x62A=;
        b=NTn6uEPW3ib5NvFtVmNGE2pusw49pXiw8qL8pAO4cdouaaeLtW4xsBMgaEfYBJ5/ugTwS5
        PrZdxUPiS7iwSDDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E538413A5C;
        Thu, 30 Jun 2022 14:32:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qhnNKfizvWJhbAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 30 Jun 2022 14:32:24 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/1] bcache: memset on stack variables in
 bch_btree_check() and bch_sectors_dirty_init()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <Yr2GnxhFasAHbfy2@kroah.com>
Date:   Thu, 30 Jun 2022 22:32:21 +0800
Cc:     stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F9E8F4F8-DD48-4949-B8C7-C1737693CF21@suse.de>
References: <20220628084933.8713-1-colyli@suse.de>
 <20220628084933.8713-2-colyli@suse.de> <YrrFaU+eWk37JtFd@kroah.com>
 <FD321F11-8639-48E9-8208-A5A3EAB5CACE@suse.de> <Yr2GnxhFasAHbfy2@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8830=E6=97=A5 19:18=EF=BC=8CGreg KH =
<gregkh@linuxfoundation.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Jun 28, 2022 at 05:29:44PM +0800, Coly Li wrote:
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8828=E6=97=A5 17:10=EF=BC=8CGreg KH =
<gregkh@linuxfoundation.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Tue, Jun 28, 2022 at 04:49:33PM +0800, Coly Li wrote:
>>>> The local variables check_state (in bch_btree_check()) and state =
(in
>>>> bch_sectors_dirty_init()) should be fully filled by 0, because =
before
>>>> allocating them on stack, they were dynamically allocated by =
kzalloc().
>>>>=20
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> Link: =
https://lore.kernel.org/r/20220527152818.27545-2-colyli@suse.de
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>> drivers/md/bcache/btree.c     | 1 +
>>>> drivers/md/bcache/writeback.c | 1 +
>>>> 2 files changed, 2 insertions(+)
>>>>=20
>>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>>>> index 2362bb8ef6d1..e136d6edc1ed 100644
>>>> --- a/drivers/md/bcache/btree.c
>>>> +++ b/drivers/md/bcache/btree.c
>>>> @@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
>>>> 	if (c->root->level =3D=3D 0)
>>>> 		return 0;
>>>>=20
>>>> +	memset(&check_state, 0, sizeof(struct btree_check_state));
>>>> 	check_state.c =3D c;
>>>> 	check_state.total_threads =3D bch_btree_chkthread_nr();
>>>> 	check_state.key_idx =3D 0;
>>>> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
>>>> index 75b71199800d..d138a2d73240 100644
>>>> --- a/drivers/md/bcache/writeback.c
>>>> +++ b/drivers/md/bcache/writeback.c
>>>> @@ -950,6 +950,7 @@ void bch_sectors_dirty_init(struct =
bcache_device *d)
>>>> 		return;
>>>> 	}
>>>>=20
>>>> +	memset(&state, 0, sizeof(struct bch_dirty_init_state));
>>>> 	state.c =3D c;
>>>> 	state.d =3D d;
>>>> 	state.total_threads =3D bch_btre_dirty_init_thread_nr();
>>>> --=20
>>>> 2.35.3
>>>>=20
>>>=20
>>> What is the git commit id of this patch in Linus's tree?
>>=20
>>=20
>> Oops, the commit tag in email was filtered out. This patch in Linus =
tree is
>>=20
>> commit 7d6b902ea0e0 (=E2=80=9Cbcache: memset on stack variables in =
bch_btree_check() and bch_sectors_dirty_init()=E2=80=9D)
>=20
> Thanks, now queued up.

Nice, thank you for taking care of it :-)

Coly Li

