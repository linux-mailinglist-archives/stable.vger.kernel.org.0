Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051334BB8CD
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 13:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbiBRMCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 07:02:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiBRMCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 07:02:32 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Feb 2022 04:02:15 PST
Received: from eu-shark2.inbox.eu (eu-shark2.inbox.eu [195.216.236.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A5620F42;
        Fri, 18 Feb 2022 04:02:14 -0800 (PST)
Received: from eu-shark2.inbox.eu (localhost [127.0.0.1])
        by eu-shark2-out.inbox.eu (Postfix) with ESMTP id 077E41E005B2;
        Fri, 18 Feb 2022 13:46:10 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.eu; s=20140211;
        t=1645184770; bh=TWX5DE7/6M1wbf9G5K6Mo9luL0SKZqEs1V53oV4Q540=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
         Content-Type:X-ESPOL:from:date:to:cc;
        b=Z1pZSnNw2tS1jSbNX3qZKpEOCaM4OHV8kduQUjJc0egJXb0RIKo0FtJj07aZjY1cF
         X99wdX272SHjeAYRtC2UgBMEKlI3jmCG8N76lGkhoHO1vjnZwUxk7kZpyNvIbclW+s
         iqjp8zMnznew5G/gaPY7OyuVX6/r6Alht9x2oYro=
Received: from localhost (localhost [127.0.0.1])
        by eu-shark2-in.inbox.eu (Postfix) with ESMTP id E643C1E005AB;
        Fri, 18 Feb 2022 13:46:09 +0200 (EET)
Received: from eu-shark2.inbox.eu ([127.0.0.1])
        by localhost (eu-shark2.inbox.eu [127.0.0.1]) (spamfilter, port 35)
        with ESMTP id dBWL_8A02l0l; Fri, 18 Feb 2022 13:46:09 +0200 (EET)
Received: from mail.inbox.eu (eu-pop1 [127.0.0.1])
        by eu-shark2-in.inbox.eu (Postfix) with ESMTP id 69C011E0058C;
        Fri, 18 Feb 2022 13:46:09 +0200 (EET)
References: <20220209184103.47635-1-sashal@kernel.org>
 <20220209184103.47635-16-sashal@kernel.org> <Yg92voqmS9jz/rI+@kroah.com>
User-agent: mu4e 1.7.0; emacs 27.2
From:   Su Yue <l@damenly.su>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 16/27] btrfs: tree-checker: check item_size
 for dev_item
Date:   Fri, 18 Feb 2022 19:25:20 +0800
In-reply-to: <Yg92voqmS9jz/rI+@kroah.com>
Message-ID: <1r00qtxj.fsf@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Virus-Scanned: OK
X-ESPOL: +dBm1NUOBk3XhyTBXxmtCA4rzV5EXevl+uWy0xxdmmeDUSOFfksTURS1g21yTGK6vzsX
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Fri 18 Feb 2022 at 11:36, Greg KH <greg@kroah.com> wrote:

> On Wed, Feb 09, 2022 at 01:40:52PM -0500, Sasha Levin wrote:
>> From: Su Yue <l@damenly.su>
>>
>> [ Upstream commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d ]
>>
>> Check item size before accessing the device item to avoid out 
>> of bound
>> access, similar to inode_item check.
>>
>> Signed-off-by: Su Yue <l@damenly.su>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/btrfs/tree-checker.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index d4a3a56726aa8..4a5ee516845f7 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -947,6 +947,7 @@ static int check_dev_item(struct 
>> extent_buffer *leaf,
>>  			  struct btrfs_key *key, int slot)
>>  {
>>  	struct btrfs_dev_item *ditem;
>> +	const u32 item_size = btrfs_item_size(leaf, slot);
>>
>>  	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
>>  		dev_item_err(leaf, slot,
>> @@ -954,6 +955,13 @@ static int check_dev_item(struct 
>> extent_buffer *leaf,
>>  			     key->objectid, 
>>  BTRFS_DEV_ITEMS_OBJECTID);
>>  		return -EUCLEAN;
>>  	}
>> +
>> +	if (unlikely(item_size != sizeof(*ditem))) {
>> +		dev_item_err(leaf, slot, "invalid item size: has 
>> %u expect %zu",
>> +			     item_size, sizeof(*ditem));
>> +		return -EUCLEAN;
>> +	}
>> +
>>  	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
>>  	if (btrfs_device_id(leaf, ditem) != key->offset) {
>>  		dev_item_err(leaf, slot,
>> --
>> 2.34.1
>>
>
> This adds a build warning, showing that the backport is not 
> correct, so
> I'll go drop this :(
>
And the warning is
========================================================================
arch/x86/kernel/head_64.o: warning: objtool: .text+0x5: 
unreachable instruction
fs/btrfs/tree-checker.c: In function 
\342\200\230check_dev_item\342\200\231:
fs/btrfs/tree-checker.c:950:53: warning: passing argument 2 of 
\342\200\230btrfs_item_size\342\200\231 makes pointer from integer 
without a cast [-Wint-conversion]
  950 |         const u32 item_size = btrfs_item_size(leaf, slot);
      |                                                     ^~~~
      |                                                     |
      |                                                     int
In file included from fs/btrfs/tree-checker.c:21:
fs/btrfs/ctree.h:1474:48: note: expected \342\200\230const struct 
btrfs_item *\342\200\231 but argument is of type 
\342\200\230int\342\200\231
 1474 |                                    const type *s) 
 \
      |                                    ~~~~~~~~~~~~^
fs/btrfs/ctree.h:1833:1: note: in expansion of macro 
\342\200\230BTRFS_SETGET_FUNCS\342\200\231
 1833 | BTRFS_SETGET_FUNCS(item_size, struct btrfs_item, size, 
 32);
      | ^~~~~~~~~~~~~~~~~~
========================================================================

The upstream patchset[1] merged in 5.17-rc1, changed second 
parameter
of btrfs_item_size() from btrfs_item * to int directly.
So yes, the backport is wrong.

I'm not familiar with stable backport progress. Should I file a 
patch
using btrfs_item *? Or just drop it?

The patch is related to  0c982944af27d131d3b74242f3528169f66950ad 
but
I wonder why the 0c98294 is not selected automatically.

Thanks.

[1]: 
https://patchwork.kernel.org/project/linux-btrfs/cover/cover.1634842475.git.josef@toxicpanda.com/
--
Su
> thanks,
>
> greg k-h
