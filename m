Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E694BAA04
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiBQTmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:42:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiBQTmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:42:14 -0500
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F210193F4;
        Thu, 17 Feb 2022 11:41:58 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5b07e69a.dip0.t-ipconnect.de [91.7.230.154])
        by mail.itouring.de (Postfix) with ESMTPSA id 3B5AD11DD47;
        Thu, 17 Feb 2022 20:41:52 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id C767DF01601;
        Thu, 17 Feb 2022 20:41:51 +0100 (CET)
Subject: Re: [PATCH for v5.15 1/2] btrfs: don't hold CPU for too long when
 defragging a file
To:     Greg KH <gregkh@linuxfoundation.org>, Qu Wenruo <wqu@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
References: <cover.1644994950.git.wqu@suse.com>
 <67dd6f0e69c59a8554d7a2977939f94221af00c1.1644994950.git.wqu@suse.com>
 <Yg6bcq2stNcvDLOv@kroah.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <60159313-2228-77e1-3748-97891a8e8f2e@applied-asynchrony.com>
Date:   Thu, 17 Feb 2022 20:41:51 +0100
MIME-Version: 1.0
In-Reply-To: <Yg6bcq2stNcvDLOv@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-02-17 20:01, Greg KH wrote:
> On Wed, Feb 16, 2022 at 03:09:07PM +0800, Qu Wenruo wrote:
>> commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b upstream.
> 
> This commit is already in 5.15.22.

It most certainly is not, since it applies cleanly in 5.15.24.
The correct upstream commit of this patch is ea0eba69a2a8125229b1b6011644598039bc53aa

cheers,
Holger

>>
>> There is a user report about "btrfs filesystem defrag" causing 120s
>> timeout problem.
>>
>> For btrfs_defrag_file() it will iterate all file extents if called from
>> defrag ioctl, thus it can take a long time.
>>
>> There is no reason not to release the CPU during such a long operation.
>>
>> Add cond_resched() after defragged one cluster.
>>
>> CC: stable@vger.kernel.org # 5.15
>> Link: https://lore.kernel.org/linux-btrfs/10e51417-2203-f0a4-2021-86c8511cc367@gmx.com
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>   fs/btrfs/ioctl.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 6a863b3f6de0..38a1b68c7851 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1581,6 +1581,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>>   				last_len = 0;
>>   			}
>>   		}
>> +		cond_resched();
>>   	}
>>   
>>   	ret = defrag_count;
>> -- 
>> 2.35.1
>>
> 
> The original commit looks nothing like this commit at all.  Are you sure
> you got this correct?
> 
> confused,
> 
> greg k-h
> 

