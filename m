Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E13663B411
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 22:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbiK1VQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 16:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiK1VQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 16:16:40 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E22BC1B;
        Mon, 28 Nov 2022 13:16:38 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2ASLGVLU009006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 16:16:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1669670193; bh=WWkh15qtsd9kIlSQdW+y9klv9CR+AgVRUGpFO6HDaZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=SZUSLUz5eCUygFHT8Sdy968xKVMfswLa999CwHr6kx3dROjFXxjfLaVxjcEBdowlx
         VyHzfbbe9k1QhW5LNy3fQLT4lhAKs/op7ETnq5e+XBXv8vSkm57Uz6PrPCKGt19Phm
         feKDIMw/URrVglp7Df0dT768zbF5GP9NVDdboOsYl6P5AS7Ig3unKQZ5aTihBy/eT7
         vwYs4tATsTJwekhf8GtsBj6+m9hnV1kIO1eu7cfcttwu43FN6Nn4Op2Ze1HSB3V/Pm
         Q7wSKnX6CAv6WJJVVqt5bPuEGBhfoxfZBUruXIO/JpG4Is6SimFhNoWR3GFEoYGVxA
         6yyjF1x5GcRAA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id BA29515C3AA6; Mon, 28 Nov 2022 16:16:31 -0500 (EST)
Date:   Mon, 28 Nov 2022 16:16:31 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+a22dc4b0744ac658ed9b@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: Add extend check to prevent BUG() in ext4_es_end
Message-ID: <Y4UlL1UH1ks1iKOz@mit.edu>
References: <20220930202536.697396-1-tadeusz.struk@linaro.org>
 <e1e227a4-4f71-3a01-2bd1-beaf6c52e02a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1e227a4-4f71-3a01-2bd1-beaf6c52e02a@linaro.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 11:38:37AM -0700, Tadeusz Struk wrote:
> On 9/30/22 13:25, Tadeusz Struk wrote:
> > Syzbot reported an issue with ext4 extents. The reproducer creates
> > a corrupted ext4 fs image in memory, and mounts it as a loop device.
> > It invokes the ext4_cache_extents() and ext4_find_extent(), which
> > eventually triggers a BUG() in ext4_es_end() causing a kernel crash.
> > It triggers on mainline, and every kernel version back to v4.14.
> > Add a call ext4_ext_check_inode() in ext4_find_extent() to prevent
> > the crash.
> > 
> > To: "Theodore Ts'o"<tytso@mit.edu>
> > Cc: "Andreas Dilger"<adilger.kernel@dilger.ca>
> > Cc:<linux-ext4@vger.kernel.org>
> > Cc:<linux-kernel@vger.kernel.org>
> > Cc:<stable@vger.kernel.org>
> > 
> > Link:https://syzkaller.appspot.com/bug?id=641e7a4b900015c5d7a729d6cc1fba7a928a88f9
> > Reported-by:syzbot+a22dc4b0744ac658ed9b@syzkaller.appspotmail.com
> > Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>
> 
> Any comments/feedback on this one?

Hi, I can't replicate the problem using the syzkaller repro:

root@kvm-xfstests:/vdc# /vtmp/repro 
[   14.840406] loop0: detected capacity change from 0 to 1051
[   14.840965] EXT4-fs (loop0): ext4_check_descriptors: Checksum for group 0 failed (60935!=0)
[   14.841468] EXT4-fs error (device loop0): ext4_ext_check_inode:520: inode #2: comm repro: pblk 0 bad header/extent: invalid magic - magic 9fe4, entries 42, max 0(0), depth 0(0)
[   14.842188] EXT4-fs (loop0): get root inode failed
[   14.842401] EXT4-fs (loop0): mount failed

And by inspection, if there is a corrupted inode, it should have been
caught much sooner, in ext4_iget():

	} else if (!ext4_has_inline_data(inode)) {
		/* validate the block references in the inode */
		if (!(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY) &&
			(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
			(S_ISLNK(inode->i_mode) &&
			!ext4_inode_is_fast_symlink(inode)))) {
			if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
				ret = ext4_ext_check_inode(inode);
			else
				ret = ext4_ind_check_inode(inode);
		}
	}
	if (ret)
		goto bad_inode;

... and this check has been around for quite some time.

It's much more efficient to check for a corrupted inode data structure
at the time when the inode is read into memory, as opposed to every
single time we try to lookup a logical->physical block map, in
ext4_find_extent().

If you can reproduce a failure on a modern kernel, please let me know,
but it looks like syzkaller had only reported it on androd-54,
android-5-10, linux-4.14, and linux-4.19 in any case.

Cheers,

						- Ted
