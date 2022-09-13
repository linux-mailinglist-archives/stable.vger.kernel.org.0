Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC57A5B659F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 04:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiIMCdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 22:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiIMCdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 22:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3E452E5D;
        Mon, 12 Sep 2022 19:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD413612FE;
        Tue, 13 Sep 2022 02:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C51C433C1;
        Tue, 13 Sep 2022 02:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663036416;
        bh=ZDvCgiFrql+qDgOo1QGy7zMojVL4tdh1vZx8YEL/VII=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=redTRotvVXGPYvrWNBYIzMaT+xVKiI/0oYKvSZQR775pTGflycJSTD7HjXbEnCXCW
         BhBdvyNb1aVlCWPgPIHy1GitaiL+KS4EKiQUxbYBHELneFnWzi/DFB2LP2tdK+6F/F
         n2XkZsN60cEyJjtvZ53PRhW3OAybAQm7Fqt9caxzwOjbEt9q2SGpwEoaJe/6H6ZXRB
         mU8Af3azOrHMLVFcZsotx2nHNv43VMgi+ly9YpA6vCTTDj0ZBhp2WInexEf3j+AnNp
         ZbSjfmKVM8Osoqx1htTn45w7OEPEwqTa0uf2WlqenQEwvGrqD6/JJLDO/STCa8Sex6
         wgPax2UYgH8Sw==
Message-ID: <a03417f6-e4fa-2b1a-34f8-bd5d52c1e853@kernel.org>
Date:   Tue, 13 Sep 2022 10:33:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] f2fs: fix to detect obsolete inner inode during
 fill_super()
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
References: <20220908105334.98572-1-chao@kernel.org>
 <Yx9SVsxVzNErMDpv@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <Yx9SVsxVzNErMDpv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/9/12 23:37, Jaegeuk Kim wrote:
> On 09/08, Chao Yu wrote:
>> Sometimes we can get a cached meta_inode which has no aops yet. Let's set it
>> all the time to fix the below panic.
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
>> Mem abort info:
>>    ESR = 0x0000000086000004
>>    EC = 0x21: IABT (current EL), IL = 32 bits
>>    SET = 0, FnV = 0
>>    EA = 0, S1PTW = 0
>>    FSC = 0x04: level 0 translation fault
>> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109ee4000
>> [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
>> Internal error: Oops: 86000004 [#1] PREEMPT SMP
>> Modules linked in:
>> CPU: 1 PID: 3045 Comm: syz-executor330 Not tainted 6.0.0-rc2-syzkaller-16455-ga41a877bc12d #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
>> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : 0x0
>> lr : folio_mark_dirty+0xbc/0x208 mm/page-writeback.c:2748
>> sp : ffff800012783970
>> x29: ffff800012783970 x28: 0000000000000000 x27: ffff800012783b08
>> x26: 0000000000000001 x25: 0000000000000400 x24: 0000000000000001
>> x23: ffff0000c736e000 x22: 0000000000000045 x21: 05ffc00000000015
>> x20: ffff0000ca7403b8 x19: fffffc00032ec600 x18: 0000000000000181
>> x17: ffff80000c04d6bc x16: ffff80000dbb8658 x15: 0000000000000000
>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>> x11: ff808000083e9814 x10: 0000000000000000 x9 : ffff8000083e9814
>> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
>> x5 : ffff0000cbb19000 x4 : ffff0000cb3d2000 x3 : ffff0000cbb18f80
>> x2 : fffffffffffffff0 x1 : fffffc00032ec600 x0 : ffff0000ca7403b8
>> Call trace:
>>   0x0
>>   set_page_dirty+0x38/0xbc mm/folio-compat.c:62
>>   f2fs_update_meta_page+0x80/0xa8 fs/f2fs/segment.c:2369
>>   do_checkpoint+0x794/0xea8 fs/f2fs/checkpoint.c:1522
>>   f2fs_write_checkpoint+0x3b8/0x568 fs/f2fs/checkpoint.c:1679
>>
>> The root cause is, quoted from Jaegeuk:
>>
>> It turned out there is a bug in reiserfs which doesn't free the root
>> inode (ino=2). That leads f2fs to find an ino=2 with the previous
>> superblock point used by reiserfs. That stale inode has no valid
>> mapping that f2fs can use, result in kernel panic.
>>
>> This patch adds sanity check in f2fs_iget() to avoid finding stale
>> inode during inner inode initialization.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>> Signed-off-by: Chao Yu <chao@kernel.org>
>> ---
>>   fs/f2fs/inode.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
>> index ccb29034af59..df1a82fbfaf2 100644
>> --- a/fs/f2fs/inode.c
>> +++ b/fs/f2fs/inode.c
>> @@ -493,6 +493,17 @@ struct inode *f2fs_iget_inner(struct super_block *sb, unsigned long ino)
>>   	struct inode *inode;
>>   	int ret = 0;
>>   
>> +	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi) ||
>> +					ino == F2FS_COMPRESS_INO(sbi)) {
>> +		inode = ilookup(sb, ino);
>> +		if (inode) {
>> +			iput(inode);
>> +			f2fs_err(sbi, "there is obsoleted inner inode %lu cached in hash table",
>> +					ino);
>> +			return ERR_PTR(-EFSCORRUPTED);
> 
> Well, this does not indicate f2fs is corrupted. I'd rather expect to fix
> reiserfs instead of f2fs workaround which hides the bug.

Well, is there a fixing patch for reiserfs? If not, how about applying this
patch first, later, we can revert it after reiserfs has been fixed.

Thanks,

> 
>> +		}
>> +	}
>> +
>>   	inode = iget_locked(sb, ino);
>>   	if (!inode)
>>   		return ERR_PTR(-ENOMEM);
>> -- 
>> 2.25.1
