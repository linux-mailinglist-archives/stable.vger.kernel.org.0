Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7910C334B1
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 18:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfFCQRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 12:17:11 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35651 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfFCQRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 12:17:11 -0400
Received: by mail-yb1-f194.google.com with SMTP id v17so2468352ybm.2;
        Mon, 03 Jun 2019 09:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vwn4Z2ztJedleCGX20UEn2VsU1XB4LmwboMJgUz2yo=;
        b=ZYfS3VNXXEWUABUMQJ/TjINAkdSdp8IBPmagt/GdfF5JqK+Zi0NVsDaQkTM+Qn39aW
         3Uev1K7wpMO5U5evuaMrhyvOPZHe752h5As+ux1Vd4u6PF2498pnWSsqcWkKcy2QHvMF
         hNLui/nEQmRzaEpCyBloAWoL/8erPZgPQkjfxkGe+FhidgGF2X61TLK+83xLubiTNJ2A
         ceMOtBkUuL3GDLyZ9AyTOL8iYPEFv/t8BXfHE0etnqoEfLo1rVXDZ2MpNALp3bVurE9w
         AnbpReb3sA6vYuD9LWL9davHbsLR3yZBBVqbQw1c5nUfTJ1zUSJozYm+J+fyTmAU8rZN
         trBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vwn4Z2ztJedleCGX20UEn2VsU1XB4LmwboMJgUz2yo=;
        b=W15e1aR8EmWMRUyRnjWfCB7TroCAxrxXSfusQa25CtELfbZXMlurG7TdJ8AZ/JYX+B
         8GG5UDQwzjRWwq0ueN3y30hkch10bc9yBOYTmrEs4kf1789TJs2FUzsIofS/1yCdg3SD
         sCgsjlAl4TH1IkhxJnDahjqfVnQt2xxJcjxaPB4sKsWjB3Z4I12xPy4krowMgM5AO0FA
         ygWCWIhmn5uAKnzsxjMs2IXthL3Ks2L1qU/C/Jhb/Qic8biyhAv6HNIYexjEHNlzKbFr
         Z2WBQiTB6Z4MXy9VMlEC4yj7PxqdNrwwVCggNQf5joOLN3Hw3v95c4jzcUyCs+q3qdMa
         q+8w==
X-Gm-Message-State: APjAAAXHw6BpzX6SnhLhAe3bLLp/yh09CNTeSm+iwSQ8jZndciEDFGjR
        fRZGbdohyguYRCsrIX2teqZH8zAMMeq8slqrpsc=
X-Google-Smtp-Source: APXvYqzqL+1Lx2eYJaPhlgbT9M0UeUWaXHu/OpxdA4VNRqNEaWRPgs9CCWtY53KomQTg4/HQKPv5CsrZvecAtsm0Uw8=
X-Received: by 2002:a05:6902:4c3:: with SMTP id v3mr12322868ybs.144.1559578630535;
 Mon, 03 Jun 2019 09:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190603132155.20600-1-jack@suse.cz> <20190603132155.20600-2-jack@suse.cz>
In-Reply-To: <20190603132155.20600-2-jack@suse.cz>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 3 Jun 2019 19:16:59 +0300
Message-ID: <CAOQ4uxibr6_k2T_0BeC7XAOnuX1PHmEmBjFwfzkVJVh17YAqrw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Add readahead file operation
To:     Jan Kara <jack@suse.cz>
Cc:     Ext4 <linux-ext4@vger.kernel.org>, Ted Tso <tytso@mit.edu>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 3, 2019 at 4:22 PM Jan Kara <jack@suse.cz> wrote:
>
> Some filesystems need to acquire locks before pages are read into page
> cache to protect from races with hole punching. The lock generally
> cannot be acquired within readpage as it ranks above page lock so we are
> left with acquiring the lock within filesystem's ->read_iter
> implementation for normal reads and ->fault implementation during page
> faults. That however does not cover all paths how pages can be
> instantiated within page cache - namely explicitely requested readahead.
> Add new ->readahead file operation which filesystem can use for this.
>
> CC: stable@vger.kernel.org # Needed by following ext4 fix
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/fs.h |  5 +++++
>  include/linux/mm.h |  3 ---
>  mm/fadvise.c       | 12 +-----------
>  mm/madvise.c       |  3 ++-
>  mm/readahead.c     | 26 ++++++++++++++++++++++++--
>  5 files changed, 32 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f7fdfe93e25d..9968abcd06ea 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1828,6 +1828,7 @@ struct file_operations {
>                                    struct file *file_out, loff_t pos_out,
>                                    loff_t len, unsigned int remap_flags);
>         int (*fadvise)(struct file *, loff_t, loff_t, int);
> +       int (*readahead)(struct file *, loff_t, loff_t);

The new method is redundant, because it is a subset of fadvise.
When overlayfs needed to implement both methods, Miklos
suggested that we unite them into one, hence:
3d8f7615319b vfs: implement readahead(2) using POSIX_FADV_WILLNEED

So you can accomplish the ext4 fix without the new method.
All you need extra is implementing madvise_willneed() with vfs_fadvise().

Thanks,
Amir.
