Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC8011E9DD
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfLMSMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 13:12:02 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39579 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728626AbfLMSMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 13:12:02 -0500
Received: by mail-qk1-f193.google.com with SMTP id c16so318690qko.6
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 10:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYPYNQC53+CxeOZMSLaSXNleC2alunHbsG33GQacSz4=;
        b=VoZOlw8aTRJ5130OpGd/2QPPeJVLXlpFsO6lMnt0ZVol+swiG2OufkT5eZ5bZNX1t7
         6uq3Wh9ztEg6X4u9wTAPnozLL7VzKAPoXn1vpSn2db+we4rYrwIknRm5sY6suY68VX6z
         qT12MybJIwhfdsNBRT2iKWvDh8hJH5RCDmfsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYPYNQC53+CxeOZMSLaSXNleC2alunHbsG33GQacSz4=;
        b=oXFSUPLbaCgXfSGeEXqHRC+MXJA0cXJnNMbakiXxbCFzEsIA/A82rEMDCDO7KhT89H
         Axg+Sa2XE86h5RkB+1+5xCz4Sq0CSadaAAFLxc9mXwON/pYi+7ZYUyVKs/+L1UhiMgZJ
         XKsXkR6IFVDKEsGjrT2M7tnIV+aDphiIuIua1lY5oieLqT7QG3b9Shr8IHRSItWS0+wl
         jWt95pRlzS18fzm33pqZi0RzXdZ9XpM7gxlXgBPghvp85P4FE+mrfl0QDl3ws5049aSR
         Q9NcXP2fjRDxR39cmxk2HoMByrtsebWjXXeF5BhF7MrbwjRJ3JTj2QCKXBQ+aQITGSzC
         Bh8Q==
X-Gm-Message-State: APjAAAVB06Cym2dKd/ekQBLPGTjmpWG1BZQOoueo2ggTb/GxeAE/u/Z1
        VtuBqrHpvpxfWq67VH8T+nfwTN2yYKzEWfF1+iQ1+nJr
X-Google-Smtp-Source: APXvYqyenKHhwGviYc0bhj1kkNQB0iXKYg0CMjzjCOLDKyeheouOTpWir748zTNRkxFY2sr98wCfcLVq/vHGlgYTv1g=
X-Received: by 2002:a37:514:: with SMTP id 20mr14328531qkf.321.1576260721379;
 Fri, 13 Dec 2019 10:12:01 -0800 (PST)
MIME-Version: 1.0
References: <20191213113510.GG15474@quack2.suse.cz> <20191213153306.30744-1-tranmanphong@gmail.com>
In-Reply-To: <20191213153306.30744-1-tranmanphong@gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 13 Dec 2019 10:11:50 -0800
Message-ID: <CAEXW_YQwrM6=u1gsij-5SL5+2n9Pk9HFEYdF_JWYjitLvr7Dcg@mail.gmail.com>
Subject: Re: [PATCH V2] ext4: use rcu API in debug_print_tree
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        adilger.kernel@dilger.ca, "Paul E. McKenney" <paulmck@kernel.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        rcu <rcu@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 13, 2019 at 7:39 AM Phong Tran <tranmanphong@gmail.com> wrote:
>
> struct ext4_sb_info.system_blks was marked __rcu.
> But access the pointer without using RCU lock and dereference.
> Sparse warning with __rcu notation:
>
> block_validity.c:139:29: warning: incorrect type in argument 1 (different address spaces)
> block_validity.c:139:29:    expected struct rb_root const *
> block_validity.c:139:29:    got struct rb_root [noderef] <asn:4> *
>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Thanks Phong! Looks like a real bug fix caught thanks to Sparse. So
let us mark for stable as well?

- Joel

> ---
>  fs/ext4/block_validity.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> ---
> change log:
> V2: Add Reviewed-by: Jan Kara <jack@suse.cz>
>
> diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
> index d4d4fdfac1a6..1ee04e76bbe0 100644
> --- a/fs/ext4/block_validity.c
> +++ b/fs/ext4/block_validity.c
> @@ -133,10 +133,13 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
>  {
>         struct rb_node *node;
>         struct ext4_system_zone *entry;
> +       struct ext4_system_blocks *system_blks;
>         int first = 1;
>
>         printk(KERN_INFO "System zones: ");
> -       node = rb_first(&sbi->system_blks->root);
> +       rcu_read_lock();
> +       system_blks = rcu_dereference(sbi->system_blks);
> +       node = rb_first(&system_blks->root);
>         while (node) {
>                 entry = rb_entry(node, struct ext4_system_zone, node);
>                 printk(KERN_CONT "%s%llu-%llu", first ? "" : ", ",
> @@ -144,6 +147,7 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
>                 first = 0;
>                 node = rb_next(node);
>         }
> +       rcu_read_unlock();
>         printk(KERN_CONT "\n");
>  }
>
> --
> 2.20.1
>
