Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8309E494CB2
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 12:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiATLTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 06:19:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:59984 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiATLTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 06:19:09 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 54F201F3A9;
        Thu, 20 Jan 2022 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642677548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7AZa5VRmcpWHj6hCOAWHbSa52oxF6GD2dL5tDTIevTM=;
        b=DL+XbIJotgeulUmQOzrGxR9u33IGoZYj70aVix56xvBQvcsvDVuXVMWnckk7+ooyBI+/50
        8flxdCwHlmx/xhG41t0Rk9NgyO44ErTF5GZy4zlUHeWws1PHK6RPZBcSUDSs2d3a/EzKNf
        F4/Lxva0aLGAaEs95BPwpCANwAgqGw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642677548;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7AZa5VRmcpWHj6hCOAWHbSa52oxF6GD2dL5tDTIevTM=;
        b=ioFCMBj/FkHn26vm+77ZgKfz3L60dzCc2DPf8RW1I4Potl1g8Eo+cifsl1VibswrBwE72x
        ox8I0LyLc1JA5zBg==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6635DA3B83;
        Thu, 20 Jan 2022 11:19:02 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 09A1CA05D9; Thu, 20 Jan 2022 12:19:08 +0100 (CET)
Date:   Thu, 20 Jan 2022 12:19:08 +0100
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] udf: Restore i_lenAlloc when inode expansion fails
Message-ID: <20220120111908.yurtt6drlo3w5uhf@quack3.lan>
References: <20220118095449.2937-1-jack@suse.cz>
 <20220118095753.627-2-jack@suse.cz>
 <Yekl+0/fagqyUNin@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yekl+0/fagqyUNin@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 20-01-22 01:06:03, Christoph Hellwig wrote:
> On Tue, Jan 18, 2022 at 10:57:48AM +0100, Jan Kara wrote:
> > When we fail to expand inode from inline format to a normal format, we
> > restore inode to contain the original inline formatting but we forgot to
> > set i_lenAlloc back. The mismatch between i_lenAlloc and i_size was then
> > causing further problems such as warnings and lost data down the line.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, how did the reported even hit that failure in a way where the
> file system continues working?  If we fail to write back data we'd
> probably better stop modifying anything and bail out..

We can fail the expansion from inline to out-of-line format e.g. when the
filesystem is full (ENOSPC). So we have to handle that case gracefully and
the filesystem should be fully operational after this.

Thanks for review!


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
