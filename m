Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB516E829A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 22:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjDSUZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 16:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjDSUY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 16:24:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AE56A63;
        Wed, 19 Apr 2023 13:23:49 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b16so1421662ejz.3;
        Wed, 19 Apr 2023 13:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681935828; x=1684527828;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ie7ojqVlC084Bty1bR6GGnt8vvylG5tNuIi+VkkSW3w=;
        b=G+h7MW+Q3rFjFvws9QajrLOIpIPKSpAH7CNtC1de2/hZ7Z2H2s/Kou4atnXeXk1yCR
         oN5cfAD5Oo6XZps5+jDvuZIf34TzZxUUFsfAGMQmQxwN8ORyJvIj2YcMKg5NhaAUfk9G
         30HCnP6wjhrcPRVYilqylnBM9GB4ORlyJkRSPC+EyZNcOqcp/9rt72eB7drfGKm74UFV
         M4o1CCxjS2gFVfGzrJsPlZSV/H/+smM3PTcy6BgXwZ6aSugWfHw6TGIs7fg252ajHQrj
         e5WhOaNQlyvlPoB9Z+0sespwyw3NnGVzts3+hWDiXml/gUurRiNlAQe5O4OwHO0dKfHW
         Yeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681935828; x=1684527828;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ie7ojqVlC084Bty1bR6GGnt8vvylG5tNuIi+VkkSW3w=;
        b=VZtsiK9b6C9Xb53H3nd+gXt6pH5Sy41lRfzc2H9jvtSNA+5bVBgbaTTFxn3y5RQJBN
         /hf3TLeU4K86hdsaIqysYEXKIlSJjSrhkfAN5ebl1eeJbMj2eqKZSk/QkEbGYsJhbwqd
         27bC+Nfl0odzA1y9WvN9GQqjfw3UAwWRI12yIi4/4mw2VmkfsVKrbLVWUbd3XS6761p0
         PnQZoXBz4FXlDF4V6pQPgX81T+1grl5El8YvCezghCB413O0EpesM1lvqAT4aTUsLwvm
         HVNRYZUA0TI4LRv2drd1wXOXLANcSQcEvLF2tbxEnhEkFdRqjsTNA+21s22U5AKcWO/F
         RmxA==
X-Gm-Message-State: AAQBX9eYnLHyQNgqhOJc6R5PeijyrXMk3LpdxNJEYKR6sC1U16oNakuh
        GElw6DIljXqNYIpHXcwfvDVANRVS3TcmIwhy9PsIwIaLk+ceDXJmyAI=
X-Google-Smtp-Source: AKy350Ywk26OwR/hLmkwfSe7E7PWTCGkyZuEJNeX+WnwDMmOso8cE6MocwkFyKDQZnY4t7gK4OjoJmNFuXoqx0TzhgM=
X-Received: by 2002:a17:906:57d5:b0:94e:dd1c:dc78 with SMTP id
 u21-20020a17090657d500b0094edd1cdc78mr16617639ejr.69.1681935827506; Wed, 19
 Apr 2023 13:23:47 -0700 (PDT)
MIME-Version: 1.0
From:   Torstein Eide <torsteine@gmail.com>
Date:   Wed, 19 Apr 2023 22:23:33 +0200
Message-ID: <CAL5DHTEcqoUnbMLVgEEPr21zLqj+FSVckPepxxL-Gg9yhkGNvA@mail.gmail.com>
Subject: Re: [PATCH pre-6.4] btrfs: dev-replace: error out if we have
 unrepaired metadata error during
To:     anand.jain@oracle.com
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is for pre-6.4 kernels, as scrub code goes through a huge rework.
>
> [BUG]
> Even before the scrub rework, if we have some corrupted metadata failed
> to be repaired during replace, we still continue replace and let it
> finish just as there is nothing wrong:
>
>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>   BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>   BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad bytenr, has 0 want 5578752
>   BTRFS error (device dm-4): unable to fixup (regular) error at logical 5578752 on dev /dev/mapper/test-scratch1
>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 finished
>
> This can lead to unexpected problems for the result fs.
>
> [CAUSE]
> Btrfs reuses scrub code path for dev-replace to iterate all dev extents.
>
> But unlike scrub, dev-replace doesn't really bother to check the scrub
> progress, which records all the errors found during replace.
>
> And even if we checks the progress, we can not really determine which
> errors are minor, which are critical just by the plain numbers.
> (remember we don't treat metadata/data checksum error differently).
>
> This behavior is there from the very beginning.
>
> [FIX]
> Instead of continue the replace, just error out if we hit an unrepaired
> metadata sector.
>
> Now the dev-replace would be rejected with -EIO, to inform the user.
> Although it also means, the fs has some metadata error which can not be
> repaired, the user would be super upset anyway.

If one sector is bad in metadata how much secondary data is damaged?

As someone who recently had to remove, and currently replace a disk.
it is upsetting, if it stopped if we stopped because 0,01% of data is
unrepairable, if we can save the other 99,99%. Can we have it
continue, print an error message to standard out, and a way for the
user to delete or copy it (with som option like -force-delete or
--force-copy) with the error to the new disk?
"Metadata at block 5578752 is damaged and unrepaired. Skipping. Read
`man btrfs-replace` for more info. "
At the end if possible, list files affected by the damaged metadata blocks.

In man answer:
How can the user know what files are connected to the metadata?
How can a user decide what to do with the damaged metadata?


At minimum,  can there be some useful info to the info to the error output? like
"Replace has stopped, due to reading unrepaired metadata block, was
working on block 5578752, se `dmesg` for more details. (\s Sorry but
you are currently f..k)"



>
> The new dmesg would look like this:
>
>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS error (device dm-4): unable to fixup (regular) error at logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
>   BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>   BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>   BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata sector at 5578752
>   BTRFS error (device dm-4): btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, /dev/mapper/test-scratch2) failed -5
>
> CC: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> I'm not sure how should we merge this patch.
>
> The misc-next is already merging the new scrub code, but the problem is
> there for all old kernels thus we need such fixes.
>
> Maybe we can merge this fix before the scrub rework, then the rework,
> and finally the better fix using reworked interface?
> ---
>   fs/btrfs/scrub.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ef4046a2572c..71f64b9bcd9f 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -195,6 +195,7 @@ struct scrub_ctx {
>   struct mutex            wr_lock;
>   struct btrfs_device     *wr_tgtdev;
>   bool                    flush_all_writes;
> + bool has_meta_failed;
>
>   /*
>   * statistics
> @@ -1380,6 +1381,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   btrfs_err_rl_in_rcu(fs_info,
>   "unable to fixup (regular) error at logical %llu on dev %s",
>   logical, btrfs_dev_name(dev));
> + if (is_metadata)
> + sctx->has_meta_failed = true;
>   }
>
>   out:
> @@ -3838,6 +3841,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>
>   blk_finish_plug(&plug);
>
> + /*
> + * If we have metadata unable to be repaired, we should error
> + * out the dev-replace.
> + */
> + if (sctx->is_dev_replace && sctx->has_meta_failed && ret >= 0)
> + ret = -EIO;
>   if (sctx->is_dev_replace && ret >= 0) {
>   int ret2;
>


-- 
Torstein Eide
Torsteine@gmail.com
