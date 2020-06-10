Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA6F1F5A4B
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 19:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgFJR1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 13:27:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:33312 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgFJR1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 13:27:21 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 05AHQhK3016288
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 10 Jun 2020 10:26:43 -0700 (PDT)
Received: from yow-pgortmak-d1.corp.ad.wrs.com (128.224.56.57) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Wed, 10 Jun 2020 10:26:31 -0700
Received: by yow-pgortmak-d1.corp.ad.wrs.com (Postfix, from userid 1000)        id
 CC0452E0378; Wed, 10 Jun 2020 13:26:30 -0400 (EDT)
Date:   Wed, 10 Jun 2020 13:26:30 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: Possible linux-stable mis-backport in ethernet/mellanox/mlx5
Message-ID: <20200610172630.GA29331@windriver.com>
References: <20200607203425.GD23662@windriver.com>
 <20200609172907.GA873279@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200609172907.GA873279@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Re: Possible linux-stable mis-backport in ethernet/mellanox/mlx5] On 09/06/2020 (Tue 19:29) Greg Kroah-Hartman wrote:

> On Sun, Jun 07, 2020 at 04:34:25PM -0400, Paul Gortmaker wrote:
> > I happened to notice this commit:
> > 
> > 9ca415399dae - "net/mlx5: Annotate mutex destroy for root ns"
> > 
> > ...was backported to 4.19 and 5.4 and v5.6 in linux-stable.
> > 
> > It patches del_sw_root_ns() - which only exists after v5.7-rc7 from:
> > 
> > 6eb7a268a99b - "net/mlx5: Don't maintain a case of del_sw_func being
> > null"
> > 
> > which creates the one line del_sw_root_ns stub function around
> > kfree(node) by breaking it out of tree_put_node().
> > 
> > In the absense of del_sw_root_ns - the backport finds an identical one
> > line kfree stub fcn - named del_sw_prio from this earlier commit:
> > 
> > 139ed6c6c46a - "net/mlx5: Fix steering memory leak"  [in v4.15-rc5]
> > 
> > and then puts the mutex_destroy() into that (wrong) function, instead of
> > putting it into tree_put_node where the root ns case used to be handled.
> 
> Ugh, good catch.  I'll go revert this from everywhere.  If you could,
> can you provide a working backport?

Maybe the simplest option is to just forget the commit, now that
you reverted the mis-applied version.  In doing so, we are assuming
mutex_destroy is just a trap for future bugs/issues and not really a
run-time bug-fix (it is a no-op unless CONFIG_DEBUG_MUTEXES=y).

Or, if you want a valid backport I'd suggest the following:

Patching tree_put_node() in-place with the mutex_destroy results in long
lines, and isn't very future-proof if there are future mellanox backports
looking for del_sw_root_ns() -- and IIRC, the mellanox stuff does seem to
see a higher than average number of stable backports.

Instead as indicated below, establishing del_sw_root_ns() in the various
currently active stable versions can be achieved w/o any real runtime
impact - thus allowing for any future backports to have a higher
probability of applying, and applying properly.

I've read the code, and compile tested the below on x86-64 allmodconfig,
but I'm not familiar with the code and don't have the hardware, so I
defer to the Mellanox guys to double check on what I've outlined below.

Hope this helps,
Paul.

v5.6
=====
-apply 6eb7a268a99b so there is now a del_sw_root_ns().  [applies as-is]
This commit claims that it "Fixes: 2cc43b494a6c" [v4.5-rc1] but my
reading of the commit just says to me that it simplifies the code by
assigning the root ns a trivial delete so it doesn't have to be
special-cased.  Runtime doesn't appear to change IMHO.

-now apply 9ca415399dae - the original mutex_destroy() commit, and it
will apply as-is, and in the right function this time.`

v5.4
=====
-apply 476a028f0a2d ("net/mlx5: Fix cleaning unmanaged flow tables").
While it claims that it "Fixes: 5281a0c90919" [v5.6-rc1] - and I'm
assuming that is true, but what it really does is remove all the fragile
assumptions about who has a parent and how that translates to being the
root ns or not -- and simply replaces it with the more logical "if you
have a delete function, then I'll use it."

-now you can do the v5.6 steps above.

v4.19
=====
-two choices here, because v4.19 doesn't have 476d61b783e5 ("net/mlx5:
Add a locked flag to node removal functions") [v5.1-rc1] which does:
   -static void down_write_ref_node(struct fs_node *node)
   +static void down_write_ref_node(struct fs_node *node, bool locked)
...and the same for up.

Choice one is to strip the ", locked" from the commits used above in
v5.4/5.6; choice #2 is to simply apply this 476d61 as it applies as is
with only one minor fuzz warn, and as the commit says itself, it is inert
since "locked == false" at this stage of development.

-I went with #2 and then the steps above in v5.4 went "hands-free"

--
> 
> thanks,
> 
> greg k-h
