Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF763C9F2
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 22:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiK2VA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 16:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiK2VA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 16:00:27 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4F264CD;
        Tue, 29 Nov 2022 13:00:25 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2ATL08E3022596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 16:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1669755611; bh=pHciYLh07bQD1b1G3RI+mlLVqqEtIIJEFswVqjuCe+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=AgG+7ayulcZenhhUWWs/6G1DFQaCoKm08nKkyZykr/43xtCOcVUAjvzxqOzEdkvNA
         yX8ZoEJp5S017zRKmrL/SWex5K12wvSafm2VXCQknI33p7YkT5b8lwO4vS3oIn2aNZ
         oureYRE44RWmUyXVVwaWrk9HvrjwZ7OKUWFdgUVE2vsqaTEF69z9v8Lh9+lRPzIWXA
         Zr3xBvz+gALUSCtuRIx71n1CpguzgrT2yrnBUAHp8UCM0GSmFlWasS/Gw9oPMgl2XR
         1kZoZl/oCgiytaKaQHY+Vjoc0JjiTLeVcIOR988gtUq2bs2OMqCIcyVYjKTkxhezgW
         lH9+R7+Iq95RQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C6D9115C00E4; Tue, 29 Nov 2022 16:00:08 -0500 (EST)
Date:   Tue, 29 Nov 2022 16:00:08 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Message-ID: <Y4Zy2HHOmak3k637@mit.edu>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de>
 <Y2cAiLNIIJhm4goP@mit.edu>
 <Y2piZT22QwSjNso9@suse.de>
 <Y4U18wly7K87fX9v@mit.edu>
 <d357e15b-e44a-1e3b-41c3-0b732e4685ed@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d357e15b-e44a-1e3b-41c3-0b732e4685ed@huawei.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 11:18:34AM +0800, Baokun Li wrote:
> 
> In my opinion, the s_journal_inum should not be modified when the
> file system is mounted, especially after we have successfully loaded
> and replayed the journal with the current s_journal_inum. Even if
> the s_journal_inumon the disk is modified, we should use the current
> one. This is how journal_devnum is handled in ext4_load_journal():
> 
>          if (!really_read_only && journal_devnum &&
>              journal_devnum != le32_to_cpu(es->s_journal_dev)) {
>                  es->s_journal_dev = cpu_to_le32(journal_devnum);
> 
>                  /* Make sure we flush the recovery flag to disk. */
>                  ext4_commit_super(sb);
>          }
> 
> We can avoid this problem by adding a similar check for journal_inum in
> ext4_load_journal().

This check you've pointed out wasn't actually intended to protect
against the problem where the journal_inum is getting overwritten by
the journal replay.  The s_journal_dev field is a hint about where to
find the external journal.  However, this can change over time --- for
example, if a SCSI disk is removed from the system, so /dev/sdcXX
becomes /dev/sbdXX.  The official way to find the journal device is
via the external journal's UUID.  So userspace might use a command
like:

  mount -t ext4 -o journal_path="$(blkid -U <journal uuid>)" UUID=<fs uuid> /mnt

So s_journal_devnum might get updated, and we don't want the hint to
get overwritten by the journal replay.  So that's why the code that
you've quoted exists (and this goes all the way back to ext3).  It's a
code path that can be quite legitimately triggered when the location
of the external journal device changes (or when the device's
major/minor numbers get renumbered).

Now, we *could* do something like this for s_journal_inum, but it
would be for a different purpose.  In practice, this would never
happen in real life due to random bit flips, since the journal is
protected using checksum.  It can only happen when there are
deliberately, maliciously fuzzed file system images, such as was the
case here.  And s_journal_inum is only one of any number of superblock
fields that shouldn't ever be modified by the journal replay.  We have
had previous failures caused by we validated the superblock fields to
be valid, but then after that, we replay the journal, and then it
turns out the superblock fields are incorrect.  (And then some Red Hat
principal engineer will try to call it a high severity CVE, which is
really bullshit, since if you allow random unprivileged processes to
mount arbitrary file system images, you've got other problems.  Don't
do that.)

If we *really* cared about these sorts of problems, we should special
case the journal replay of certain blocks, such as the superblock, and
validate those blocks to make sure they are not crazy --- and if it is
crazy, we should abort the journal replay right then and there.

Alternatively, one *could* consider making a copy of certain blocks
(in particular the superblock and block group descriptors), and then
do a post-hoc validation of the superblock after the replay --- and if
it is invalid, we could put the old superblock back.  But we need to
remember that sometimes superblock fields *can* change.  For example,
in the case of online resize, we can't just say that if the old
superblock value is different from the new superblock value, something
Must Be Wrong.  That being said, if the result of the journal replay
ends up with a result where s_block_count is greater than the physical
block device, *that's* something that is probably wrong.

That being said, the question is whether all of this complexity is
really all *that* necessary, since again, thanks to checksums, short
of Malicious File System Fuzzing, this should never happen.  If all of
this complexity is only needed to protect against malicious fuzzed
file systems, then maybe it's not the worth it.

If we can protect against the problem by adding a check that has other
value as well (such as making usre that when ext4_iget fetches a
special inode, we enforce that i_links_couint must be > 0), maybe
that's worth it.

So ultimately it's all a question of engineering tradeoffs.  Is it
worth it to check for s_journal_inum changing, and changing it back?
Meh.  At the very least we would want to add a warning, since this is
only going happen in case of a malicious fuzzed file system.  And
since we're only undoing the s_journal_inum update, there may be other
superblock fields beyond s_journal_inum that could get modified by the
malicious file system fuzzer.  So how many post hoc checks do we
really want to be adding here?  Should we also do similar checks for
s_blocks_per_group?  s_inodes_per_group?  s_log_block_size?
s_first_ino?  s_first_data_block?  I realize this is a slipperly slope
argument; but the bottom line that it's not immediately obvious that
it's good idea to only worry about s_journal_inum.

Cheers,

						- Ted
