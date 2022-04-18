Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E0C505F81
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 23:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiDRVza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 17:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiDRVza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 17:55:30 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBDC101E3
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 14:52:49 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id DD46A124EC0;
        Mon, 18 Apr 2022 23:52:47 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 9AA22F01601;
        Mon, 18 Apr 2022 23:52:47 +0200 (CEST)
Subject: Re: 5.15 request: properly backport VFS/XFS syncfs error handling
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <8997252f-0196-97aa-659e-34524b7b3593@applied-asynchrony.com>
 <Yl1PQkQDfnA0Jauv@kroah.com> <20220418203146.GB17059@magnolia>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <25475a69-e31b-f51e-69a6-ac06adc6d4ac@applied-asynchrony.com>
Date:   Mon, 18 Apr 2022 23:52:47 +0200
MIME-Version: 1.0
In-Reply-To: <20220418203146.GB17059@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-04-18 22:31, Darrick J. Wong wrote:
> On Mon, Apr 18, 2022 at 01:45:06PM +0200, Greg KH wrote:
>> On Fri, Apr 15, 2022 at 02:10:46PM +0200, Holger Hoffstätte wrote:
>>>
>>> I noticed that our autobot recently backported parts of a series which
>>> fixed XFS syncfs error handling [1]. Unfortunately - due to missing
>>> requirements - it only managed to merge those patches which do not
>>> actually fix anything.
>>>
>>> This can be repaired by applying the prerequisites and then the missing
>>> parts of the original series, namely in order:
>>>
>>>    9a208ba5c9af fs: remove __sync_filesystem
>>>    70164eb6ccb7 block: remove __sync_blockdev
>>>    1e03a36bdff4 block: simplify the block device syncing code
>>>    5679897eb104 vfs: make sync_filesystem return errors from ->sync_fs
>>>    2d86293c7075 xfs: return errors in xfs_fs_sync_fs
>>>
>>> With all that we could also put a cherry on top and merge:
>>>
>>>    b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount
>>>
>>> but that's just a touchup and not a real bugfix, so probably optional.
>>
>> Can we get an ack from the XFS developers that this is ok to do?
>> Without that, we can't apply xfs patches to the stable trees.
> 
> You might consider adding these two other patches:
> 
> 2719c7160dcf ("vfs: make freeze_super abort when sync_filesystem returns error")
> dd5532a4994b ("quota: make dquot_quota_sync return errors from ->sync_fs")
> 
> to the pile, but otherwise that looks ok to me.
> 
> --D

Those two are the ones from the series that were already merged into 5.15.x,
some time back in February. Looks like we have them all.

cheers
Holger
