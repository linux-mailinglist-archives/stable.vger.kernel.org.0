Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14A95FDFCB
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiJMR6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiJMR5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:57:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E81B5FED;
        Thu, 13 Oct 2022 10:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 927D4B82023;
        Thu, 13 Oct 2022 17:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C115C433D6;
        Thu, 13 Oct 2022 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683815;
        bh=y+nUBGq5tB1wZxetm97uvPW+VajTy591xqNbeojGCUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THRWMPZj1u71R105pw6mVhDwikvx7jgGOnyNJNAnA3Zr+5pfkVeNWLBpsPriyG3X+
         b5otynQ6faVOyuFlTq7g20RrfFiYXeCvupv29SkwvSgO66rlt8k3gIDB3XkbEOypOR
         petA2n6sNCk4ChfeRUizJmjynhR08hEhSTE4pkgtxjtdU5Bd81q36Iox5UZ1QowSAT
         sTC+5ajISnzlRyryrbrrEQ0zJnOJLUrxwrQlE5NKEbelOT+1MXN4xPolI7pG3H0vTK
         b6HoNuviF4tR/MYLicfdWo4EYnV8L5CfB94D0UcMLz+g3Hgb53KWYh+CURkVN9oMtJ
         JcBL2foHCXdmw==
Date:   Thu, 13 Oct 2022 13:56:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhang songyi <zhang.songyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 37/46] btrfs: remove the unnecessary result
 variables
Message-ID: <Y0hRZss8cOHw2vqa@sashalap>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-37-sashal@kernel.org>
 <20221012115418.GW13389@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221012115418.GW13389@suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 01:54:18PM +0200, David Sterba wrote:
>On Tue, Oct 11, 2022 at 10:50:05AM -0400, Sasha Levin wrote:
>> From: zhang songyi <zhang.songyi@zte.com.cn>
>>
>> [ Upstream commit bd64f6221a98fb1857485c63fd3d8da8d47406c6 ]
>>
>> Return the sysfs_emit() and iterate_object_props() directly instead of
>> using unnecessary variables.
>>
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Reviewed-by: Anand Jain <anand.jain@oracle.com>
>> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/btrfs/props.c |  5 +----
>>  fs/btrfs/sysfs.c | 10 ++--------
>>  2 files changed, 3 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index a2ec8ecae8de..055a631276ce 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -270,11 +270,8 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
>>  {
>>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>>  	u64 ino = btrfs_ino(BTRFS_I(inode));
>> -	int ret;
>> -
>> -	ret = iterate_object_props(root, path, ino, inode_prop_iterator, inode);
>>
>> -	return ret;
>> +	return iterate_object_props(root, path, ino, inode_prop_iterator, inode);
>
>Please drop the patch from stable queues, it's an obvious cleanup.

Ack, I'll drop this and the other btrfs commits you've pointed out.

-- 
Thanks,
Sasha
