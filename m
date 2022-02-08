Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B884AE3BB
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 23:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386743AbiBHWXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 17:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387142AbiBHWAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 17:00:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73012C0612BE
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 14:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644357633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7/XrpH//YwRO83/RuCZbVzbSGr6NZxZ5lE/266BDXk=;
        b=Rncly/6pYBVp8PCR6O7bNQQqEouVCBphJ1ckNmKUJV561a3SKuK1uDAYmGb1vyRyEWg/er
        LfDq7uOHVNcK/vII/CfwBuDtIe+YOFpKGyc0izU+LpKz2hOXPVzHeCC2hefc1w4xoKd2Xe
        9i5DrxIh/Fae0gLE4LkDPomlbHlyc38=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-KZ60NCEYOPOcbdd7OANyJA-1; Tue, 08 Feb 2022 17:00:32 -0500
X-MC-Unique: KZ60NCEYOPOcbdd7OANyJA-1
Received: by mail-qt1-f197.google.com with SMTP id g18-20020ac84b72000000b002cf274754c5so253390qts.14
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 14:00:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W7/XrpH//YwRO83/RuCZbVzbSGr6NZxZ5lE/266BDXk=;
        b=Ys2NuaLaQ+7wjLGrq78lSL58NngkOVBRd98thG9C/PKHq6VhAGqBqHgYExR+0e0Sql
         DY0yg/i3nb+3BlMBEb1W6KoBGpH+7/tusaBzd6ZXB/FW+eF06mdFyBUOvxFIGdY7kvYM
         XksYHUFnPeVFTVn6s6p+z9AOHbo+UcMp8Db4OLFmuHChZumLmabYSc40CVziCVz2T9MO
         M6dHI14+Xj3nKwyt7VR8Tz/ITl1papVgjAp7cojGWELh1m9pIRHj70IH93saYIuhgFam
         tzf4mcbQxZWpQXCIklBgW08E+vdCo9c/8KEcJwy4L/pZahrVEV1kYY6TlGOor0pxAlGE
         OADA==
X-Gm-Message-State: AOAM5313mMJotmnOkUgrlW6ET1a8FB3UWcoF/ILOvQqeZA1x1LXwcJLE
        cuOCSXHDsYQeie71k4WWdjpyYEndB8kLkACSpvQz5vCrfWFzeDqwrh/fs0cpqUZA2cMhQ4yNcEF
        3tqAnnRTGvpCWW6A=
X-Received: by 2002:ac8:578e:: with SMTP id v14mr4420848qta.45.1644357631271;
        Tue, 08 Feb 2022 14:00:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBmY5C/N/7k0llE16sNXZl2FnzqAvMcesorwNx/7mm5+uXx+1ySZbo16/w1a7eY8EuZv6V9Q==
X-Received: by 2002:ac8:578e:: with SMTP id v14mr4420827qta.45.1644357631012;
        Tue, 08 Feb 2022 14:00:31 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id h7sm8224485qtb.27.2022.02.08.14.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 14:00:30 -0800 (PST)
Date:   Tue, 8 Feb 2022 17:00:29 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     axboe@kernel.dk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm: revert partial fix for redundant
 bio-based IO accounting" failed to apply to 5.4-stable tree
Message-ID: <YgLn/Xax8fzFY5Z+@redhat.com>
References: <1643463094220106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643463094220106@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Turns out the fixes I marked for stable@ aren't actually fixing
anything (after applying the changes: code is cleaner but no
meaningful difference in IO stats).

That is because DM was already patching up the 'sectors' portion of
the stats after a split.  The other fields I documented in the
following header aren't tied to payload (see __part_start_io_acct).

So no _real_ need to backport to 5.4 or 5.10.  Sorry for the noise.

Mike

On Sat, Jan 29 2022 at  8:31P -0500,
gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:

> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From f524d9c95fab54783d0038f7a3e8c014d5b56857 Mon Sep 17 00:00:00 2001
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Fri, 28 Jan 2022 10:58:40 -0500
> Subject: [PATCH] dm: revert partial fix for redundant bio-based IO accounting
> 
> Reverts a1e1cb72d9649 ("dm: fix redundant IO accounting for bios that
> need splitting") because it was too narrow in scope (only addressed
> redundant 'sectors[]' accounting and not ios, nsecs[], etc).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Link: https://lore.kernel.org/r/20220128155841.39644-3-snitzer@redhat.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c0ae8087c602..9849114b3c08 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1442,9 +1442,6 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
>  	ci->sector = bio->bi_iter.bi_sector;
>  }
>  
> -#define __dm_part_stat_sub(part, field, subnd)	\
> -	(part_stat_get(part, field) -= (subnd))
> -
>  /*
>   * Entry point to split a bio into clones and submit them to the targets.
>   */
> @@ -1480,18 +1477,6 @@ static void __split_and_process_bio(struct mapped_device *md,
>  						  GFP_NOIO, &md->queue->bio_split);
>  			ci.io->orig_bio = b;
>  
> -			/*
> -			 * Adjust IO stats for each split, otherwise upon queue
> -			 * reentry there will be redundant IO accounting.
> -			 * NOTE: this is a stop-gap fix, a proper fix involves
> -			 * significant refactoring of DM core's bio splitting
> -			 * (by eliminating DM's splitting and just using bio_split)
> -			 */
> -			part_stat_lock();
> -			__dm_part_stat_sub(dm_disk(md)->part0,
> -					   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
> -			part_stat_unlock();
> -
>  			bio_chain(b, bio);
>  			trace_block_split(b, bio->bi_iter.bi_sector);
>  			submit_bio_noacct(bio);
> 

