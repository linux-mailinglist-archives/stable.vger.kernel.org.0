Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EFD4CEEEC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 01:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiCGAQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 19:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiCGAQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 19:16:51 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8446050E36;
        Sun,  6 Mar 2022 16:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1646612150;
        bh=+pec0/WewNJT9mGTJjFSdkotD4x7loRKWBwR+fZt/rU=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=AX+kPtRcGWaDyc0Tj4eSekGLL+1/hsN1uAky4af8+BnNpMcmgc3J7ODY+OGYGjy9J
         /rKmb58EkFBU+5OkkS3S7RYyk268CuA1wxJwq3Hv6lM5GB5mN1LSJlqoZFz+dELTLI
         YZmLbFm5cDXM272uQA3wq9rH4OqDlvHcoSNJwWdE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MXp9i-1nfHir25lM-00YC1H; Mon, 07
 Mar 2022 01:15:50 +0100
Message-ID: <d1a3f31f-2205-6dce-0f33-6611972e48cd@gmx.com>
Date:   Mon, 7 Mar 2022 08:15:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] btrfs: unlock the newly allocated extent buffer in
 btrfs_alloc_tree_block()
Content-Language: en-US
To:     Denis Efremov <denis.e.efremov@oracle.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Cc:     Hao Sun <sunhao.th@gmail.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20210914065759.38793-1-wqu@suse.com>
 <8fa2dbee-75a9-6194-05c6-3208e6be36dc@oracle.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <8fa2dbee-75a9-6194-05c6-3208e6be36dc@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ra3zRp0rvGWyaMAC/MRbCNFFXkbQob1Gsz2KJixPuiNLheTfHea
 ubtevvdgnDfyWyXdXY4aG/Ynw0HTBBBZap8mUQdGzzGVa5P+lVzkZfRMxTVtGBq7X9GuPzr
 c+kF1H9m4UKsJP0D9feWFGdYwdauIsBtyqXN7tQIB6AJ/JKsogusV+LY2cJl5v0a1rz59mr
 MoaNsmbNnyelgybXcfgtw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eXa6dWq99tQ=:6/IMvpfTCMawfOhRTZpnyc
 NhfJNeKbkza8gv6xtShx1UySOAxyKmhbauv2xUsduaGnlqVLXdDrt8eoMVfFBC5iQONYiKtCG
 +xmzFEK5qLWhS5TegZKM0liLL2+oQpwm1H1kL7jH3iUCgbhBz/krSoOF64cl2qzU2p8zKqW6c
 U3DHhurhOvQUsoV6ajfpWv6z7wlyas3rJvguTEQvTWCmBmqgJPt7yop6Xh6fNxTvlUKrmyIfd
 EEMTE5d6Zl0N1E6lK1Wo4WMKAzk2ZBkKHLwUPhlQBqhpeKyDLV+JgBfOWOmxaKM+pjNNpIBzN
 ju6MYg9KMd9cW5PyTzfY0vlYpB1rmuFLgvauNNjgmteBwWRSww61c1wpFbGd4LAjYIzk95oDY
 kMVolZAwrLPkIIs5S/WpX7fayuJ0SoP+evomwqfE6mZQ68YKt5f9IBWpz+doi3DQeqCSqi1PW
 26QJU0JWY94Uw0R50u5UA4xDIrlc3NPWnkfTX4pVSxSYtNfBE677jZrZ1S2f1e5QSp+E52j7z
 VhlW70h6oRvGSUOBiSRo37DoId3hwNK7HpWiHWSDWnX8YjW7MrfP/IErQq7YVPuBLgfD3xy4X
 3fssVO2oXUWyF9U92erNGtLPi29hmLaNYtjScm/Y34Ta5+j1AzRzDJ73gMmMcGZUOqVUgcE/n
 yz5W0Xm/HgShAEy2BT9v3Vsso4zMf1zYCLG/s1/zRwecJS/qmNXHqTEGyNax2XCq7RP6G499V
 t4zNTfwLmyQJ5rQVofDjAyWBp84vmLb6U1qN7D2ds/g9OPcWCo0ppawEabhSAyawXTLBvLMs3
 7OOeY7B5Eb2sbPBgqGgVQ7YZQINJX7uKBLJYUi8siE2jN97ManHvmVi+waL2czacva6FPXG4K
 S2OIEZ+tegsX7ZTTNSgU2ktT+1Rk4TZ7wcKK+my4Q6jctMKATXThJePKjr/6CeDcAM299sAIR
 9WlKmWRrtdEh7rkRQGzYtxb/dz/fzHygqAEMNXpq95qcf5fTsHhrqUgZtA1A2R49t4B3uaTJv
 qF5MA9Lof7njdUyTQScZiWK98FIB9mebHoou+8FeCLVk8rlOY0K/xWHgkzM2nJg8TAGhrt//b
 DfkywgTFIOcrm8=
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/3/7 00:36, Denis Efremov wrote:
> Hi,
>
>
> On 9/14/21 09:57, Qu Wenruo wrote:
>> [BUG]
> ...
>>
>>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>>    WARNING: lock held when returning to user space!
>>    5.15.0-rc1 #16 Not tainted
>>    ------------------------------------------------
>>    syz-executor/7579 is leaving the kernel with locks still held!
>>    1 lock held by syz-executor/7579:
>>     #0: ffff888104b73da8 (btrfs-tree-01/1){+.+.}-{3:3}, at:
>>    __btrfs_tree_lock+0x2e/0x1a0 fs/btrfs/locking.c:112
>>
>> [CAUSE]
>> In btrfs_alloc_tree_block(), after btrfs_init_new_buffer(), the new
>> extent buffer @buf is locked, but if later operations like adding
>> delayed tree ref fails, we just free @buf without unlocking it,
>> resulting above warning.
>
> This patch fixes CVE-2021-4149. Commit 19ea40dddf18
> "btrfs: unlock newly allocated extent buffer after error" upstream.
> The patch was backported to kernels 5.15, 5.10, 5.4 because it contains
> "CC: stable@vger.kernel.org # 5.4+" in the commit message.
>
> However, it looks to me like kernels 4.9, 4.14, 4.19 are also vulnerable=
.
> In v4.9 kernel there is btrfs_init_new_buffer() call:
> btrfs_alloc_tree_block(...)
> {
> 	...
> 	buf =3D btrfs_init_new_buffer(trans, root, ins.objectid, level);
> 	...
> out_free_buf:
>          free_extent_buffer(buf);
> 	...
> }
>
> and btrfs_init_new_buffer() contains btrfs_tree_lock(buf) inside it.
>
> The patch can be cherry-picked to v4.9 kernel without a conflict.
>
> Probably, the error was introduced in the commit 67b7859e9bfa
> "btrfs: handle ENOMEM in btrfs_alloc_tree_block" It's in the kernel
> since v4.1
>
> Can you confirm that kernels v4.9, 4.14, 4.19 are also vulnerable?

Oh, thanks for catching this, I'm never good at taking care of older
kernels.

But since those three are TLS kernels, they deserve the fix.

And yes, in those three versions, they have btrfs_tree_lock() called in
btrfs_init_new_buffer(), so they are also affected.

For the cause, your commit is completely correct.

So feel free to backport those patches to stable, with your new fixed-by
tag.

Thanks,
Qu
>
> Thanks,
> Denis
>
>>
>> [FIX]
>> Unlock @buf in out_free_buf: tag.
>>
>> Reported-by: Hao Sun <sunhao.th@gmail.com>
>> Link: https://lore.kernel.org/linux-btrfs/CACkBjsZ9O6Zr0KK1yGn=3D1rQi6C=
rh1yeCRdTSBxx9R99L4xdn-Q@mail.gmail.com/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/extent-tree.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index c88e7727a31a..8aa981ffe7b7 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4898,6 +4898,7 @@ struct extent_buffer *btrfs_alloc_tree_block(stru=
ct btrfs_trans_handle *trans,
>>   out_free_delayed:
>>   	btrfs_free_delayed_extent_op(extent_op);
>>   out_free_buf:
>> +	btrfs_tree_unlock(buf);
>>   	free_extent_buffer(buf);
>>   out_free_reserved:
>>   	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 0);
