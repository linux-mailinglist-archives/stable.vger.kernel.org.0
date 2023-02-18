Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576B869BAA1
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 16:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBRPWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 10:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBRPWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 10:22:43 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A3E15561;
        Sat, 18 Feb 2023 07:22:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EB86E5C36E;
        Sat, 18 Feb 2023 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676733760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xye6gPQJHl4LmfMpByxV9dVR125DxOfSWBzG2GD7TZA=;
        b=r7k+YImFY4mBYZoImr3TxTQFit+sKo4XHVGwT+wRaGe9apSIQvgrekOZi3/g4AWVExyRsq
        sVTBXVIQDKHMUZSNKn3YDDSm9qqu5r5CNNKov9Y+ZmvLL4VmvnkXlME3w6OzzsLdd6Yc6a
        8SaAPs2FirC+VdFT0ah0a/kZPzDMEMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676733760;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xye6gPQJHl4LmfMpByxV9dVR125DxOfSWBzG2GD7TZA=;
        b=bbIdku5iS8v5RX/+vmvnA+cuXkMvc/hq1bTEr3+YI1f73VxBNifX5ZzebjAdxZo43MYtM8
        IeFMqgg1J9VKSHCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39BA113921;
        Sat, 18 Feb 2023 15:22:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R/b/AD/t8GPPagAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 18 Feb 2023 15:22:39 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [RESEND PATCH v3] bcache: Fix __bch_btree_node_alloc to make the
 failure  behavior consistent
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230218072335.1537099-1-zyytlz.wz@163.com>
Date:   Sat, 18 Feb 2023 23:22:26 +0800
Cc:     Zheng Hacker <hackerzheng666@gmail.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex000young@gmail.com, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <05D7778B-6B00-468B-983D-B00619FA337D@suse.de>
References: <20230218072335.1537099-1-zyytlz.wz@163.com>
To:     Zheng Wang <zyytlz.wz@163.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 18, 2023 at 03:23:35PM +0800, Zheng Wang wrote:
> In some specific situation, the return value of __bch_btree_node_alloc =
may
> be NULL. This may lead to poential NULL pointer dereference in caller
> function like a calling chaion :
> btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.
>=20
> Fix it by initialize return value in __bch_btree_node_alloc before =
return.
>=20
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>

Thanks, I will add this series to my for-next testing queue.

Coly Li

> ---
> v3:
> - Add Cc: stable@vger.kernel.org suggested by Eric
> v2:
> - split patch v1 into two patches to make it clearer suggested by Coly =
Li
> ---
> drivers/md/bcache/btree.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..cae25e74b9e0 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct =
cache_set *c, struct btree_op *op,
> 				     struct btree *parent)
> {
> 	BKEY_PADDED(key) k;
> -	struct btree *b =3D ERR_PTR(-EAGAIN);
> +	struct btree *b;
>=20
> 	mutex_lock(&c->bucket_lock);
> retry:
> +	/* return ERR_PTR(-EAGAIN) when it fails */
> +	b =3D ERR_PTR(-EAGAIN);
> 	if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
> 		goto err;
>=20
> --=20
> 2.25.1
>=20
