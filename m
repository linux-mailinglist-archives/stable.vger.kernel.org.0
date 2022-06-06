Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E3D53F228
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 00:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiFFWdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 18:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiFFWdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 18:33:18 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5459C4E86;
        Mon,  6 Jun 2022 15:33:17 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id n4so6127916vsm.6;
        Mon, 06 Jun 2022 15:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D8KYm/kXFbglcEhdYHRu8NlX+TPkOrBauKoCsP3TmCU=;
        b=T7NvrrV6YXfrlvmBM+FcjOW11Y/XovXaV1u5bl0dg/4MxX7XsVOSHPTeq1mP+vZl+4
         tu6H3Btu1/ATjMJRO/jxa272D1fcumI6TZoweGIhZeJlPe6wHESt06QgY7s6Faz5+l28
         d1GrPpjnOuDmL/xWkDA8QsGBE/oFZwBqmOfXdw/rtgb11uRzJMq1RW3sWSF3QTM0Y7Gj
         wX/O/Aqwbnb/Zl9yYzxHlOAc581qIKnVrHWFNHQH9jNdQs/S4TqXkDhdCN+Su/8MQoNj
         dnFZhEJKkkBZ+cFUcF8lQtkUpL//cmXN8qA3CKfcuXf388mSRHQRAOhVUm/e7jh9vNm1
         5z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D8KYm/kXFbglcEhdYHRu8NlX+TPkOrBauKoCsP3TmCU=;
        b=GhIyaklOCiYUyMdJ62idTvLTLq7Brtfivm396Tc3J9ZP9SrFMZkKuYZt2QRlmhDd3R
         KyFVWypHWJQbhpwuU6R13QQcZWbnHsDjR2gBQdbCxzNKcQp3picYxWr2hY9BwfaEnj+a
         1z1mbDjn6DGCx9Opod5onc8N90k6o03eIolxJ48AArPiDqHb8XOXbOnCL9ZDhWgyBwt7
         FaDKlNEquovneLKRD8MDyE9+m87Tl6WBP/CooJHvKHi6dSaFTjBmH8ieuc9yhAxEgm9G
         bGTlFkRvFzIkDwdg9mIeK5L7Xhgk5lbrzuKwj9V3RnpEG06JZfAfwQRwQiYJrWX1dU79
         tKKg==
X-Gm-Message-State: AOAM533QdYYcg4JrqKBHIEBLDShxupasbptwJYK3xOnzraI3tDVJTo4D
        Fie2JJ9soFzk+3YSyP66m+pCp8AuN/Ac0o/2PfgccE+nOZPI1g==
X-Google-Smtp-Source: ABdhPJxtpscOZWwUmHOABvSaWWFaqdtrAIUMLkl3j9GLceGZS3ENlfkI4O5sdrVA0IIG3Rtnqs3m3kv3E5gT5UO93KE=
X-Received: by 2002:a05:6102:32c3:b0:349:ec9b:4219 with SMTP id
 o3-20020a05610232c300b00349ec9b4219mr11165868vss.71.1654554796815; Mon, 06
 Jun 2022 15:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220606143255.685988-1-amir73il@gmail.com> <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area>
In-Reply-To: <20220606213042.GS227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Jun 2022 01:33:06 +0300
Message-ID: <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
To:     Dave Chinner <david@fromorbit.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
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

On Tue, Jun 7, 2022 at 12:30 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> >
> > xfs/538 on a 1kB block filesystem failed with this assert:
> >
> > XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
>
> You haven't mentioned that you combined a second upstream
> commit into this patch to fix the bug in this commit.....
>

I am confused.

patch [5.10 7/8] xfs: consider shutdown in bmapbt cursor delete assert
is the patch that I backported from 5.12 and posted for review.
This patch [5.10 8/8] is the patch from 5.19-rc1 that you pointed out
that I should take to fix the bug in patch [5.10 7/8].

The upstream commits correspond to the original commits each.

If I missed anything, please correct me and I will fix it.

Thanks,
Amir.
