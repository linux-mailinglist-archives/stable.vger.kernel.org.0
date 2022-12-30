Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BCA6597D1
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 12:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiL3Lmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 06:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiL3Lmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 06:42:51 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B2C1ADAE
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 03:42:48 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z11so14308298ede.1
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 03:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4XZfky7ZSwtH3alzjfLBlx9hAVIUDjxRPNok440Sk+w=;
        b=fo/vXSou4JSqxx8vcwAPesM454BTBJhoV6lGb88gUySkdzf4qnR0pRqWscfRtiFMyH
         o4AjUoVprkjEJ5OlbqSR6vHl86s8BjWa2411ePcroa90sXOPeCBJ3SuItl0SpP75VL3K
         /0SYrBPsMU4nVdG6+0tQ+2n0IFJZuy5RSnG71K33ytux7c0AWrTWcDNMOgfX0FSDzdex
         tBXdfkkgYxAnAtjfekWcXdQRDVgTlqS/4K7RQN4aJlqTuYBK2s4dbYHFXP02LckTshku
         fGy4azuB0sdHwXkAxO9eK0gJCvX3wyiVlg2TPV93ci7AqKgwnO6uOh8cb5iRRlXp0sCP
         JBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4XZfky7ZSwtH3alzjfLBlx9hAVIUDjxRPNok440Sk+w=;
        b=7JexuQSb5JFAM9wT/+PDW4+Mi4MRFBlZZKFnIUOVLqxufAyqAEEptdyhkNCUsOs0fa
         wo6SP4NmF5+N5dh88FFHBVLkVuGANfEiMU0kEL0I4JMaQzjoETzaLGHe1EA6o15YVRBX
         9gMYT/6FJEy5oGZDul9tBAJN649VvgQryqxTL7lPxYTqJvoljxlTd+ysd5RDR4zSoH1p
         NgrUajuhiOZqmupnIk4mWFDO4izsz477QBUN4/EWLARkvQDZTUQSoWzZvzQIq+gwp4sM
         QPpE4xrF9rvQ6TM1of3NTnI4ByU1yflph9U2a4VGQO07ZqpCeQs9vs91eUvwKHxoJlwD
         Wurw==
X-Gm-Message-State: AFqh2kqfn9LTY+QcaXoUJiSYMlMOaZ7oAwpyU9ARIcg6kcK2qqgHXWX4
        2XDrYh8qfvNH1vK2gaK79PQjspk/GiHwDkp8
X-Google-Smtp-Source: AMrXdXv2+CCza+mBMX/e9kIDh3cAH6mehWrO1R9BTPaxD1+4+Mq5EGKbz7scpWSzOSZwqLRazygTaw==
X-Received: by 2002:aa7:d996:0:b0:46c:857d:6778 with SMTP id u22-20020aa7d996000000b0046c857d6778mr28340940eds.5.1672400567392;
        Fri, 30 Dec 2022 03:42:47 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id p25-20020aa7cc99000000b004678b543163sm9209631edt.0.2022.12.30.03.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 03:42:47 -0800 (PST)
Message-ID: <cf1be149-392d-afa0-092a-c3426868f852@linaro.org>
Date:   Fri, 30 Dec 2022 13:42:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] ext4: Fix possible use-after-free in ext4_find_extent
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com,
        syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
 <Y66LkPumQjHC2U7d@sol.localdomain>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <Y66LkPumQjHC2U7d@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Eric,

On 30.12.2022 08:56, Eric Biggers wrote:
> On Fri, Dec 30, 2022 at 08:29:31AM +0200, Tudor Ambarus wrote:
>> syzbot reported a use-after-free Read in ext4_find_extent that is hit when
>> using a corrupted file system. The bug was reported on Android 5.15, but
>> using the same reproducer triggers the bug on v6.2-rc1 as well.
>>
>> Fix the use-after-free by checking the extent header magic. An alternative
>> would be to check the values of EXT4_{FIRST,LAST}_{EXTENT,INDEX} used in
>> ext4_ext_binsearch() and ext4_ext_binsearch_idx(), so that we make sure
>> that pointers returned by EXT4_{FIRST,LAST}_{EXTENT,INDEX} don't exceed the
>> bounds of the extent tree node. But this alternative will not squash
>> the bug for the cases where eh->eh_entries fit into eh->eh_max. We could
>> also try to check the sanity of the path, but costs more than checking just
>> the header magic, so stick to the header magic sanity check.
>>
>> Link: https://syzkaller.appspot.com/bug?id=be6e90ce70987950e6deb3bac8418344ca8b96cd
>> Reported-by: syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
>> ---
>> v2: drop wrong/uneeded le16_to_cpu() conversion for eh->eh_magic
>>
>>   fs/ext4/extents.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 9de1c9d1a13d..bedc8c098449 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -894,6 +894,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
>>   		gfp_flags |= __GFP_NOFAIL;
>>   
>>   	eh = ext_inode_hdr(inode);
>> +	if (eh->eh_magic != EXT4_EXT_MAGIC) {
>> +		EXT4_ERROR_INODE(inode, "Extent header has invalid magic.");
>> +		ret = -EFSCORRUPTED;
>> +		goto err;
>> +	}
>> +
> 
> This is (incompletely) validating the extent header in the inode.  Isn't that
> supposed to happen when the inode is loaded?  See how __ext4_iget() calls
> ext4_ext_check_inode().  Why isn't that working here?
> 

Seems that __ext4_iget() is not called on writes. You can find below the 
sequence of calls that leads to the bug. The debug was done on v6.2-rc1.
I assume the extents check is no longer done on writes since
commit 7a262f7c69163cd4811f2f838faef5c5b18439c9. The commit doesn't
specify the reason though.

Cheers,
ta

---
#20 0xffffffff85000087 in entry_SYSCALL_64 ()
     at /home/atudor/work/aosp/arch/x86/entry/entry_64.S:120
#19 do_syscall_64 (regs=0xffffc90001fbff58, nr=82542)
     at /home/atudor/work/aosp/arch/x86/entry/common.c:80
#18 0xffffffff84f27caf in do_syscall_x64 (regs=0xffffc90001fbff58, nr=82542)
     at /home/atudor/work/aosp/arch/x86/entry/common.c:50
#17 __x64_sys_write (regs=<optimized out>) at 
/home/atudor/work/aosp/fs/read_write.c:646
#16 __se_sys_write (fd=4, buf=536871424, count=0)
     at /home/atudor/work/aosp/fs/read_write.c:646
#15 0xffffffff81c668fb in __do_sys_write (fd=4, buf=0x20000200 
"threaded", count=0)
     at /home/atudor/work/aosp/fs/read_write.c:649
#14 0xffffffff81c66758 in ksys_write (fd=fd@entry=4, 
buf=buf@entry=0x20000200 "threaded",
     count=392007683) at /home/atudor/work/aosp/fs/read_write.c:637
#13 vfs_write (file=file@entry=0xffff8881352f9900, buf=<optimized out>,
     buf@entry=0x20000200 "threaded", count=<optimized out>, 
count@entry=392007683,
     pos=<optimized out>, pos@entry=0xffffc90001fbfe80)
     at /home/atudor/work/aosp/fs/read_write.c:584
#12 new_sync_write (filp=<optimized out>, buf=0x20000200 "threaded", 
len=392007683,
     ppos=0xffffc90001fbfe80) at /home/atudor/work/aosp/fs/read_write.c:491
#11 0xffffffff81c65ba5 in call_write_iter (file=0xffff8881352f9900, 
kio=<optimized out>,
     iter=<optimized out>) at /home/atudor/work/aosp/include/linux/fs.h:2186
#10 0xffffffff81f11e78 in ext4_file_write_iter (iocb=<optimized out>,
     from=0xffffc90001fbfd70) at /home/atudor/work/aosp/fs/ext4/file.c:700
#9  0xffffffff81f148ff in ext4_buffered_write_iter (iocb=0xffffc90001fbfd20,
     from=from@entry=0xffffc90001fbfd70) at 
/home/atudor/work/aosp/fs/ext4/file.c:285
#8  0xffffffff81a4aef4 in generic_perform_write 
(iocb=iocb@entry=0xffffc90001fbfd20,
     i=<optimized out>, i@entry=0xffffc90001fbfd70)
     at /home/atudor/work/aosp/mm/filemap.c:3772
#7  0xffffffff81f682b9 in ext4_da_write_begin (file=<optimized out>,
     mapping=<optimized out>, pos=<optimized out>, len=<optimized out>,
     pagep=<optimized out>, fsdata=<optimized out>)
     at /home/atudor/work/aosp/fs/ext4/inode.c:3082
#6  0xffffffff81f66995 in ext4_block_write_begin 
(page=page@entry=0xffffea0004859500,
     pos=pos@entry=32768, len=len@entry=4096,
     get_block=0xffffffff81f47b10 <ext4_da_get_block_prep>)
     at /home/atudor/work/aosp/fs/ext4/inode.c:1098
#5  ext4_da_get_block_prep (inode=0xffff888117bbe7a8, iblock=16, 
bh=0xffff888117b5db28,
     create=<optimized out>) at /home/atudor/work/aosp/fs/ext4/inode.c:1870
#4  ext4_da_map_blocks (inode=0xffff888117bbe7a8, iblock=16, 
bh=0xffff888117b5db28,
     map=<optimized out>) at /home/atudor/work/aosp/fs/ext4/inode.c:1806
#3  0xffffffff81f48526 in ext4_insert_delayed_block 
(inode=0xffff888117bbe7a8,
     lblk=<optimized out>) at /home/atudor/work/aosp/fs/ext4/inode.c:1696
#2  0xffffffff81ef9b96 in ext4_clu_mapped 
(inode=inode@entry=0xffff888117bbe7a8, lclu=1)
     at /home/atudor/work/aosp/fs/ext4/extents.c:5809
#1  ext4_find_extent (inode=inode@entry=0xffff888117bbe7a8, block=16,
     orig_path=orig_path@entry=0x0 <fixed_percpu_data>, flags=flags@entry=0)
     at /home/atudor/work/aosp/fs/ext4/extents.c:931
#0  ext4_ext_binsearch_idx (path=0xffff888136ad3800, block=16, 
inode=<optimized out>)
     at /home/atudor/work/aosp/fs/ext4/extents.c:768
