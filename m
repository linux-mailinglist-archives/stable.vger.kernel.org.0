Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB105BF34B
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 04:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIUCH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 22:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIUCHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 22:07:55 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B3852467;
        Tue, 20 Sep 2022 19:07:53 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28L27baS018728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 22:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1663726059; bh=3ohc6YQiQrAmEO861AamUK/Zf3us3MNirXCnBSsXsbs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=UwUFSoEld8CG3BMMq8pop268EWXXWl1XoEpBqoW1h2Y3/OKaqBVVcY4ZnsdCIzpNg
         h91S3bupRx2elhJ4ZQ6C0hp9VDHoFtPW2Oy0X6VrfLIVrchUdGneOAqyJXXm29c8nm
         mgcVntkBtXyVfij06N60RpPVhHasNL+35Jh4Bv4rnkeCF3qB9zV3syjd2LkRR9AHjL
         MrAyZW7TXxLPZRNiUUW9P5RqmUoaIZjmBUO1ywCFx4IHVhviS6hMIz0MERfAoKKHjx
         Tg7YAFofyCxkThZCoIF0UJ6MIkPpZgwgtoz4H50gdVn3yXr/Gscphzhe0ClioeRmZV
         SOVmGH29H2w4w==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 166A815C526C; Tue, 20 Sep 2022 22:07:37 -0400 (EDT)
Date:   Tue, 20 Sep 2022 22:07:37 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
Message-ID: <Yypx6VQRbl3bFP2v@mit.edu>
References: <28460B7B-F66E-4BDC-9F6E-B7E77A3FEE83@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28460B7B-F66E-4BDC-9F6E-B7E77A3FEE83@amazon.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 19, 2022 at 03:06:46PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> Hey Team,
> 
> 
>   *   I am sending this e-mail to report a performance regression that’s caused by commit 244adf6426(ext4: make dioread_nolock the default) , I am listing the performance regression symptoms below & our analysis for the reported regression.

Performance regressions are always tricky; dioread_nolock improves on
some workloads, and can cause regressions for others.  In this
particular case, the choice to make it the default was to also fix a
direct I/O vs. writeback race which can result in stale data being
revealed (which is a security issue).

That being said...

1)  as you've noted, this commit has been around since 5.6.

2)  as you noted,

    Increasing the journal size from ext4 128 MiB to 1GiB will also
    fix the problem .

Since 2016, the commit bbd2f78cf63a ("libext2fs: allow the default
journal size to go as large as a gigabyte") has been in e2fsprogs
v1.43.2 and newer (the current version of e2fsprogs v1.46.5; v1.43.2
was released in September 2016, six years ago).  Quoting the commit
description:

    Recent research has shown that for a metadata-heavy workload, a 128 MB
    is journal be a bottleneck on HDD's, and that the optimal journal size
    is proportional to number of unique metadata blocks that can be
    modified (and written into the journal) in a 30 second window.  One
    gigabyte should be sufficient for most workloads, which will be used
    for file systems larger than 128 gigabytes.

So this should not be a problem in practice, and if there are users
who are using antedeluvian versions of e2fsprogs, or who have old file
systems which were created many years ago, it's quite easy to adjust
the journal size.  For example, to adjust the journal to be 2GiB (2048
MiB), just run the commands:

   tune2fs -O ^has_journal /dev/sdXX
   tune2fs -O has_journal -J size=2048 /tmp/sdXX

Hence, I disagree that we should revert commit 244adf6426.  It may be
that for your workload and your file system configuration, using the
mount option nodioread_nolock (or dioread_lock), may make sense.  But
there were also workloads for which using dioread_nolock improved
benchmark numbers, so the question of which is the better default is
not at all obvious.

That being said, I do have plans for a new writeback scheme which will
replace dioread_nolock *and* dioread_lock, and which will hopefully be
faster than either approach.

						- Ted

P.S.  I'm puzzled by your comment, "we have to note that this should
be only beneficial with extent-based files" --- while this is true,
why does this matter?  Unless you're dealing with an ancient file
system that was originally created as ext2 or ext3 and then converted
to ext4, *all* ext4 files should be extent-based...
