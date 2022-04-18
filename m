Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B8E505EEA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbiDRUea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 16:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238666AbiDRUe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 16:34:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BD930F62
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 13:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B612B810BF
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 20:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A1EC385AA;
        Mon, 18 Apr 2022 20:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650313907;
        bh=E2ACkyAltZ+nxyuSG9gViJfWNAn+W7pUsaNGLXZWxNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nU31GdNQMUHus9SK4K6qQr4Vi3WTM8/vanfT5gO7LEU+u5+wTiOjXcaVZ3XxgValA
         C9mSMM0u3rxVvpPqwzTlFMux7BPn6fnE0vV+3tfZd6h6TqV2WxotvyJtJL9YPZRZat
         yGJ1iP7xqU49E05ixWxKJqUerczjVqD1zkhci9WWou4MUgeFmyDU85vn6Spsdree1E
         IPXyS5tebKNyeB9CDp7Sj90/H9/SoCkbA4k0MNjwG6k274OeFa9HvPukysrVHObXlH
         WR14F66+DZLop/JeO0LThxBAuu9mjWxCyBPDSttPVIheiF5N/+E4vKd60Dxa1FHEGt
         +czJodnTU4IMA==
Date:   Mon, 18 Apr 2022 13:31:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: 5.15 request: properly backport VFS/XFS syncfs error handling
Message-ID: <20220418203146.GB17059@magnolia>
References: <8997252f-0196-97aa-659e-34524b7b3593@applied-asynchrony.com>
 <Yl1PQkQDfnA0Jauv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yl1PQkQDfnA0Jauv@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 01:45:06PM +0200, Greg KH wrote:
> On Fri, Apr 15, 2022 at 02:10:46PM +0200, Holger Hoffstätte wrote:
> > 
> > I noticed that our autobot recently backported parts of a series which
> > fixed XFS syncfs error handling [1]. Unfortunately - due to missing
> > requirements - it only managed to merge those patches which do not
> > actually fix anything.
> > 
> > This can be repaired by applying the prerequisites and then the missing
> > parts of the original series, namely in order:
> > 
> >   9a208ba5c9af fs: remove __sync_filesystem
> >   70164eb6ccb7 block: remove __sync_blockdev
> >   1e03a36bdff4 block: simplify the block device syncing code
> >   5679897eb104 vfs: make sync_filesystem return errors from ->sync_fs
> >   2d86293c7075 xfs: return errors in xfs_fs_sync_fs
> > 
> > With all that we could also put a cherry on top and merge:
> > 
> >   b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount
> > 
> > but that's just a touchup and not a real bugfix, so probably optional.
> 
> Can we get an ack from the XFS developers that this is ok to do?
> Without that, we can't apply xfs patches to the stable trees.

You might consider adding these two other patches:

2719c7160dcf ("vfs: make freeze_super abort when sync_filesystem returns error")
dd5532a4994b ("quota: make dquot_quota_sync return errors from ->sync_fs")

to the pile, but otherwise that looks ok to me.

--D

> thanks,
> 
> greg k-h
