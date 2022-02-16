Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555684B87DA
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiBPMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:41:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiBPMl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:41:57 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05512AE02;
        Wed, 16 Feb 2022 04:41:45 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6B6831F383;
        Wed, 16 Feb 2022 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645015304;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jI0ny1M2K2fFZSuUHmmf+hQJDJhoxROJ6eE6z90nDO0=;
        b=ynwFiT6jdtW9FvIZy0EKQlpd6x4X/DyN0oxGCFa40QWuOARqq1/D8BBNwQMgpFTCPqmZG8
        bt+oyll6ySOrUNycvT08hLt5sbSVnXrGTOhU6y283L+Yi33/t+yiucSbnxoPLpnlutmszj
        9j5XdEzJ6qiNrlqm4DgEIZXb2Kad4VQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645015304;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jI0ny1M2K2fFZSuUHmmf+hQJDJhoxROJ6eE6z90nDO0=;
        b=XUWSiqKgAzp1SJ0/p+U9uyn/w9PsTx4WcA/2sKPI0+q3Y0LiLDZMmauMxkvtfFH+s+Wka/
        9AyLxL7Ov46xK7Bw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 63F9DA3B8E;
        Wed, 16 Feb 2022 12:41:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8FDEDA823; Wed, 16 Feb 2022 13:37:59 +0100 (CET)
Date:   Wed, 16 Feb 2022 13:37:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH for v5.15 2/2] btrfs: defrag: use the same cluster size
 for defrag ioctl and autodefrag
Message-ID: <20220216123759.GP12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1644994950.git.wqu@suse.com>
 <d2ce0079f3d2144876f019575858b392263089c4.1644994950.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2ce0079f3d2144876f019575858b392263089c4.1644994950.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 03:09:08PM +0800, Qu Wenruo wrote:
> No upstream commit.
> Since the bug only exists between v5.11 and v5.15. In v5.16 btrfs
> reworked defrag and no longer has this bug.

I'm not sure this will work as a stable patch. A backport of an existing
upstream patch that is only adapted to older stable code base is fine
but what is the counterpart of this patch?

> 
> [BUG]
> Since commit 7f458a3873ae ("btrfs: fix race when defragmenting leads to
> unnecessary IO") autodefrag no longer works with the following script:

The bug does no seem to be significant, autodefrag is basically a
heuristic so if it does not work perfectly in all cases it's still OK.
