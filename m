Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F163CDBF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 04:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiK3DUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 22:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiK3DUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 22:20:16 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ED6201A6;
        Tue, 29 Nov 2022 19:20:14 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NMPZT2PVMzHtck;
        Wed, 30 Nov 2022 11:19:29 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 11:20:11 +0800
Message-ID: <a448e298-dffd-e2f5-79b9-3997a4f53c92@huawei.com>
Date:   Wed, 30 Nov 2022 11:20:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>
CC:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Baokun Li <libaokun1@huawei.com>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de> <Y2cAiLNIIJhm4goP@mit.edu>
 <Y2piZT22QwSjNso9@suse.de> <Y4U18wly7K87fX9v@mit.edu>
 <d357e15b-e44a-1e3b-41c3-0b732e4685ed@huawei.com> <Y4Zy2HHOmak3k637@mit.edu>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <Y4Zy2HHOmak3k637@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/11/30 5:00, Theodore Ts'o wrote:
> On Tue, Nov 29, 2022 at 11:18:34AM +0800, Baokun Li wrote:
>> In my opinion, the s_journal_inum should not be modified when the
>> file system is mounted, especially after we have successfully loaded
>> and replayed the journal with the current s_journal_inum. Even if
>> the s_journal_inumon the disk is modified, we should use the current
>> one. This is how journal_devnum is handled in ext4_load_journal():
>>
>>           if (!really_read_only && journal_devnum &&
>>               journal_devnum != le32_to_cpu(es->s_journal_dev)) {
>>                   es->s_journal_dev = cpu_to_le32(journal_devnum);
>>
>>                   /* Make sure we flush the recovery flag to disk. */
>>                   ext4_commit_super(sb);
>>           }
>>
>> We can avoid this problem by adding a similar check for journal_inum in
>> ext4_load_journal().
> This check you've pointed out wasn't actually intended to protect
> against the problem where the journal_inum is getting overwritten by
> the journal replay.  The s_journal_dev field is a hint about where to
> find the external journal.  However, this can change over time --- for
> example, if a SCSI disk is removed from the system, so /dev/sdcXX
> becomes /dev/sbdXX.  The official way to find the journal device is
> via the external journal's UUID.  So userspace might use a command
> like:
>
>    mount -t ext4 -o journal_path="$(blkid -U <journal uuid>)" UUID=<fs uuid> /mnt
>
> So s_journal_devnum might get updated, and we don't want the hint to
> get overwritten by the journal replay.  So that's why the code that
> you've quoted exists (and this goes all the way back to ext3).  It's a
> code path that can be quite legitimately triggered when the location
> of the external journal device changes (or when the device's
> major/minor numbers get renumbered).

I get it! Thank you very much for your patient and detailed explanation!

> Now, we *could* do something like this for s_journal_inum, but it
> would be for a different purpose.  In practice, this would never
> happen in real life due to random bit flips, since the journal is
> protected using checksum.  It can only happen when there are
> deliberately, maliciously fuzzed file system images, such as was the
> case here.
Totally agree! Because of this, we should intercept these anomalies in a 
simpler way
at a more peripheral location.

> And s_journal_inum is only one of any number of superblock
> fields that shouldn't ever be modified by the journal replay.  We have
> had previous failures caused by we validated the superblock fields to
> be valid, but then after that, we replay the journal, and then it
> turns out the superblock fields are incorrect.  (And then some Red Hat
> principal engineer will try to call it a high severity CVE, which is
> really bullshit, since if you allow random unprivileged processes to
> mount arbitrary file system images, you've got other problems.  Don't
> do that.)
Indeed, these fuzzy image problems are triggered by mounting first.
However, mounting an unchecked image and loose mounting permission
management are inherently problematic. But many times we can't ask too
much from users, because there are too many scenarios for linux.
>
> If we *really* cared about these sorts of problems, we should special
> case the journal replay of certain blocks, such as the superblock, and
> validate those blocks to make sure they are not crazy --- and if it is
> crazy, we should abort the journal replay right then and there.
>
> Alternatively, one *could* consider making a copy of certain blocks
> (in particular the superblock and block group descriptors), and then
> do a post-hoc validation of the superblock after the replay --- and if
> it is invalid, we could put the old superblock back.  But we need to
> remember that sometimes superblock fields *can* change.  For example,
> in the case of online resize, we can't just say that if the old
> superblock value is different from the new superblock value, something
> Must Be Wrong.  That being said, if the result of the journal replay
> ends up with a result where s_block_count is greater than the physical
> block device, *that's* something that is probably wrong.
>
> That being said, the question is whether all of this complexity is
> really all *that* necessary, since again, thanks to checksums, short
> of Malicious File System Fuzzing, this should never happen.  If all of
> this complexity is only needed to protect against malicious fuzzed
> file systems, then maybe it's not the worth it.

Yes, it's too complicated to fully check the data after journal replays.

> If we can protect against the problem by adding a check that has other
> value as well (such as making usre that when ext4_iget fetches a
> special inode, we enforce that i_links_couint must be > 0), maybe
> that's worth it.
Yes, but some special inodes allow i_links_couint to be zero,
such as the uninitialized boot load inode.
>
> So ultimately it's all a question of engineering tradeoffs.  Is it
> worth it to check for s_journal_inum changing, and changing it back?
> Meh.  At the very least we would want to add a warning, since this is
> only going happen in case of a malicious fuzzed file system.  And
> since we're only undoing the s_journal_inum update, there may be other
> superblock fields beyond s_journal_inum that could get modified by the
> malicious file system fuzzer.  So how many post hoc checks do we
> really want to be adding here?  Should we also do similar checks for
> s_blocks_per_group?  s_inodes_per_group?  s_log_block_size?
> s_first_ino?  s_first_data_block?  I realize this is a slipperly slope
> argument; but the bottom line that it's not immediately obvious that
> it's good idea to only worry about s_journal_inum.
>
> Cheers,
>
> 						- Ted
That's right! We don't have to divergence this problem, just focus on 
s_journal_inum.
We only need to ensure that the s_journal_inum on the disk is the same 
as that in use.
The s_journal_inum in use passes the check. In addition, the current 
journal is recorded
on the journal inode in use.

Thanks again for your patience!

-- 
With Best Regards,
Baokun Li
.
