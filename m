Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0023E11EB3A
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 20:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfLMTtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 14:49:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:57540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728942AbfLMTtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 14:49:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76B8EAF65;
        Fri, 13 Dec 2019 19:49:44 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 36FA41E0609; Fri, 13 Dec 2019 20:49:43 +0100 (CET)
Date:   Fri, 13 Dec 2019 20:49:43 +0100
From:   Jan Kara <jack@suse.cz>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Phong Tran <tranmanphong@gmail.com>, Jan Kara <jack@suse.cz>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        rcu <rcu@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH V2] ext4: use rcu API in debug_print_tree
Message-ID: <20191213194943.GA959@quack2.suse.cz>
References: <20191213113510.GG15474@quack2.suse.cz>
 <20191213153306.30744-1-tranmanphong@gmail.com>
 <CAEXW_YQwrM6=u1gsij-5SL5+2n9Pk9HFEYdF_JWYjitLvr7Dcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YQwrM6=u1gsij-5SL5+2n9Pk9HFEYdF_JWYjitLvr7Dcg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 13-12-19 10:11:50, Joel Fernandes wrote:
> On Fri, Dec 13, 2019 at 7:39 AM Phong Tran <tranmanphong@gmail.com> wrote:
> >
> > struct ext4_sb_info.system_blks was marked __rcu.
> > But access the pointer without using RCU lock and dereference.
> > Sparse warning with __rcu notation:
> >
> > block_validity.c:139:29: warning: incorrect type in argument 1 (different address spaces)
> > block_validity.c:139:29:    expected struct rb_root const *
> > block_validity.c:139:29:    got struct rb_root [noderef] <asn:4> *
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> 
> Thanks Phong! Looks like a real bug fix caught thanks to Sparse. So
> let us mark for stable as well?

Well, not really. The code is active only with CONFIG_EXT4_DEBUG enabled
and in this case there's no race with remount (and thus sbi->system_blks
changing) possible. So the change is really only to silence the sparse
warning.

								Honza

> 
> - Joel
> 
> > ---
> >  fs/ext4/block_validity.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > ---
> > change log:
> > V2: Add Reviewed-by: Jan Kara <jack@suse.cz>
> >
> > diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
> > index d4d4fdfac1a6..1ee04e76bbe0 100644
> > --- a/fs/ext4/block_validity.c
> > +++ b/fs/ext4/block_validity.c
> > @@ -133,10 +133,13 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
> >  {
> >         struct rb_node *node;
> >         struct ext4_system_zone *entry;
> > +       struct ext4_system_blocks *system_blks;
> >         int first = 1;
> >
> >         printk(KERN_INFO "System zones: ");
> > -       node = rb_first(&sbi->system_blks->root);
> > +       rcu_read_lock();
> > +       system_blks = rcu_dereference(sbi->system_blks);
> > +       node = rb_first(&system_blks->root);
> >         while (node) {
> >                 entry = rb_entry(node, struct ext4_system_zone, node);
> >                 printk(KERN_CONT "%s%llu-%llu", first ? "" : ", ",
> > @@ -144,6 +147,7 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
> >                 first = 0;
> >                 node = rb_next(node);
> >         }
> > +       rcu_read_unlock();
> >         printk(KERN_CONT "\n");
> >  }
> >
> > --
> > 2.20.1
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
