Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2982508B34
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 16:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379785AbiDTOys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 10:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379801AbiDTOyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 10:54:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACF71CFD1
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2836A61647
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 14:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65009C385A1;
        Wed, 20 Apr 2022 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650466320;
        bh=8DA5FLSho/2WtPs3q8StbxgnOlNlAY2b/1d3nkWVBS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=macHe2rv+Pp0BmvQtysFlFKzQfFAO+oYm4cGndMsNZD+1NtW1isDkdAm8GRqiorAF
         vN/emwKDT5p+NKP+cGWjAi43ZbBZ/2f+EzfVhzzPtKfcrJfD/wHE8IvGUmum0mlCd6
         y2tnNtA3WS0Obnc7A6r4yDmuvXV7bPx5rfWtigDXYrJt6F2o0frZogvzyYNeFFcgiE
         HURkA/rtON08FfOKyrZaFlUYXemq1SlOYSEgbf4pCbiGajXvQzMqDI42THpsQ/OQX4
         XnL7BbyrGQtdlXLi6qQx6/0E5o5SoSbZ9hXHCS/ZFeNwkh1QIvWeG+BqCPZ80yvGPM
         rbivGM4XyyXaw==
Date:   Wed, 20 Apr 2022 10:51:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: 5.15 request: properly backport VFS/XFS syncfs error handling
Message-ID: <YmAeD6UEfO/Zebrv@sashalap>
References: <8997252f-0196-97aa-659e-34524b7b3593@applied-asynchrony.com>
 <Yl1PQkQDfnA0Jauv@kroah.com>
 <20220418203146.GB17059@magnolia>
 <25475a69-e31b-f51e-69a6-ac06adc6d4ac@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25475a69-e31b-f51e-69a6-ac06adc6d4ac@applied-asynchrony.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 11:52:47PM +0200, Holger Hoffstätte wrote:
>On 2022-04-18 22:31, Darrick J. Wong wrote:
>>On Mon, Apr 18, 2022 at 01:45:06PM +0200, Greg KH wrote:
>>>On Fri, Apr 15, 2022 at 02:10:46PM +0200, Holger Hoffstätte wrote:
>>>>
>>>>I noticed that our autobot recently backported parts of a series which
>>>>fixed XFS syncfs error handling [1]. Unfortunately - due to missing
>>>>requirements - it only managed to merge those patches which do not
>>>>actually fix anything.
>>>>
>>>>This can be repaired by applying the prerequisites and then the missing
>>>>parts of the original series, namely in order:
>>>>
>>>>   9a208ba5c9af fs: remove __sync_filesystem
>>>>   70164eb6ccb7 block: remove __sync_blockdev
>>>>   1e03a36bdff4 block: simplify the block device syncing code
>>>>   5679897eb104 vfs: make sync_filesystem return errors from ->sync_fs
>>>>   2d86293c7075 xfs: return errors in xfs_fs_sync_fs
>>>>
>>>>With all that we could also put a cherry on top and merge:
>>>>
>>>>   b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount
>>>>
>>>>but that's just a touchup and not a real bugfix, so probably optional.
>>>
>>>Can we get an ack from the XFS developers that this is ok to do?
>>>Without that, we can't apply xfs patches to the stable trees.
>>
>>You might consider adding these two other patches:
>>
>>2719c7160dcf ("vfs: make freeze_super abort when sync_filesystem returns error")
>>dd5532a4994b ("quota: make dquot_quota_sync return errors from ->sync_fs")
>>
>>to the pile, but otherwise that looks ok to me.
>>
>>--D
>
>Those two are the ones from the series that were already merged into 5.15.x,
>some time back in February. Looks like we have them all.

Queued up, thanks.

-- 
Thanks,
Sasha
