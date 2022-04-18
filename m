Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF85504F84
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 13:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiDRLrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 07:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbiDRLrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 07:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866B626ED
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2290260C3C
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4E3C385A8;
        Mon, 18 Apr 2022 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650282309;
        bh=iwBMXctKimIp5CrW3Yju0m6aARxJ8vCoagpXlpmrKQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aVmuAasBZ8IuNzlaggzWbnPsMkcu0XTWbTR8VxC8l5ItAJ79tImjgNQ+9qbTrmsTl
         MiRcEvmWdtgC9EP8BRmNfECspLEjBWu2uUZTyouqJCM853Bgx0hn0n6Ocj/qU4fv84
         6U5HnyasCmdocptlfvH0BYR+/TaGqbLF9acF6U7I=
Date:   Mon, 18 Apr 2022 13:45:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: 5.15 request: properly backport VFS/XFS syncfs error handling
Message-ID: <Yl1PQkQDfnA0Jauv@kroah.com>
References: <8997252f-0196-97aa-659e-34524b7b3593@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8997252f-0196-97aa-659e-34524b7b3593@applied-asynchrony.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 15, 2022 at 02:10:46PM +0200, Holger Hoffstätte wrote:
> 
> I noticed that our autobot recently backported parts of a series which
> fixed XFS syncfs error handling [1]. Unfortunately - due to missing
> requirements - it only managed to merge those patches which do not
> actually fix anything.
> 
> This can be repaired by applying the prerequisites and then the missing
> parts of the original series, namely in order:
> 
>   9a208ba5c9af fs: remove __sync_filesystem
>   70164eb6ccb7 block: remove __sync_blockdev
>   1e03a36bdff4 block: simplify the block device syncing code
>   5679897eb104 vfs: make sync_filesystem return errors from ->sync_fs
>   2d86293c7075 xfs: return errors in xfs_fs_sync_fs
> 
> With all that we could also put a cherry on top and merge:
> 
>   b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount
> 
> but that's just a touchup and not a real bugfix, so probably optional.

Can we get an ack from the XFS developers that this is ok to do?
Without that, we can't apply xfs patches to the stable trees.

thanks,

greg k-h
