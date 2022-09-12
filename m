Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D995B5D55
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiILPiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiILPiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22082DABE;
        Mon, 12 Sep 2022 08:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46B6061248;
        Mon, 12 Sep 2022 15:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A234C433D6;
        Mon, 12 Sep 2022 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662997080;
        bh=oxqqC71whU82K+lMvDngYtKvu3gWEOvauoFnwRSlPuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q6FnABTA5i4SLOkkHKAXSp6F7n8kO/2lwpfNaB/0kXGFyYWEq7OVQt4anSllmoc9A
         LnxmTDok5aY+mdK+LaovQaRACzxyahDDplVCpWqBYSm8pHozW1TgLfTg8nT2G9r2H/
         PG3VbZU2PIGx5VyUSi8iiaVjvGa1cEqyfOq1cQ+mKaYASiXPT7gM+4PM2GdbSSZ93T
         b0irWRDf8HkXgv9gvE+3qmvmpLmFcnH276eajOE60W8SuLQ3ckB0uDMVE3cpgttcfn
         0Ls63zOTnuSABq0VYuw/2prRE5ejjmmgkeh6lMyyg0VWhOImTwJRnmgjJQiRoCsqKP
         +w/QWGhyWAOlg==
Date:   Mon, 12 Sep 2022 08:37:58 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
Subject: Re: [PATCH] f2fs: fix to detect obsolete inner inode during
 fill_super()
Message-ID: <Yx9SVsxVzNErMDpv@google.com>
References: <20220908105334.98572-1-chao@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908105334.98572-1-chao@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/08, Chao Yu wrote:
> Sometimes we can get a cached meta_inode which has no aops yet. Let's set it
> all the time to fix the below panic.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> Mem abort info:
>   ESR = 0x0000000086000004
>   EC = 0x21: IABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
>   FSC = 0x04: level 0 translation fault
> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109ee4000
> [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
> Internal error: Oops: 86000004 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 1 PID: 3045 Comm: syz-executor330 Not tainted 6.0.0-rc2-syzkaller-16455-ga41a877bc12d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : 0x0
> lr : folio_mark_dirty+0xbc/0x208 mm/page-writeback.c:2748
> sp : ffff800012783970
> x29: ffff800012783970 x28: 0000000000000000 x27: ffff800012783b08
> x26: 0000000000000001 x25: 0000000000000400 x24: 0000000000000001
> x23: ffff0000c736e000 x22: 0000000000000045 x21: 05ffc00000000015
> x20: ffff0000ca7403b8 x19: fffffc00032ec600 x18: 0000000000000181
> x17: ffff80000c04d6bc x16: ffff80000dbb8658 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> x11: ff808000083e9814 x10: 0000000000000000 x9 : ffff8000083e9814
> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : ffff0000cbb19000 x4 : ffff0000cb3d2000 x3 : ffff0000cbb18f80
> x2 : fffffffffffffff0 x1 : fffffc00032ec600 x0 : ffff0000ca7403b8
> Call trace:
>  0x0
>  set_page_dirty+0x38/0xbc mm/folio-compat.c:62
>  f2fs_update_meta_page+0x80/0xa8 fs/f2fs/segment.c:2369
>  do_checkpoint+0x794/0xea8 fs/f2fs/checkpoint.c:1522
>  f2fs_write_checkpoint+0x3b8/0x568 fs/f2fs/checkpoint.c:1679
> 
> The root cause is, quoted from Jaegeuk:
> 
> It turned out there is a bug in reiserfs which doesn't free the root
> inode (ino=2). That leads f2fs to find an ino=2 with the previous
> superblock point used by reiserfs. That stale inode has no valid
> mapping that f2fs can use, result in kernel panic.
> 
> This patch adds sanity check in f2fs_iget() to avoid finding stale
> inode during inner inode initialization.
> 
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Chao Yu <chao@kernel.org>
> ---
>  fs/f2fs/inode.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index ccb29034af59..df1a82fbfaf2 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -493,6 +493,17 @@ struct inode *f2fs_iget_inner(struct super_block *sb, unsigned long ino)
>  	struct inode *inode;
>  	int ret = 0;
>  
> +	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi) ||
> +					ino == F2FS_COMPRESS_INO(sbi)) {
> +		inode = ilookup(sb, ino);
> +		if (inode) {
> +			iput(inode);
> +			f2fs_err(sbi, "there is obsoleted inner inode %lu cached in hash table",
> +					ino);
> +			return ERR_PTR(-EFSCORRUPTED);

Well, this does not indicate f2fs is corrupted. I'd rather expect to fix
reiserfs instead of f2fs workaround which hides the bug.

> +		}
> +	}
> +
>  	inode = iget_locked(sb, ino);
>  	if (!inode)
>  		return ERR_PTR(-ENOMEM);
> -- 
> 2.25.1
