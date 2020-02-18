Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D374162E51
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgBRSUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:20:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRSUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 13:20:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kldAGFAqkRNUcVcPcSVMxxc7zBAYVzPEee6iqrr/A2A=; b=M0Ix6aBhlR1JL9Jh4Codgz5/lz
        S5/eJYeeX78FIYgjw5xujOQCO6P5kq5RoK2lDnmGYua4mp5/tAzii3lSRua7FyMpVeAxd+cEg6cCn
        iLJtVD35w65dXNe2drF/A//h0VJMBwD8zgwCmCs9yMWjnfFw78g4gt0EaGeWPVBtm2xjAMeMCycsE
        b8vrVCp0wCVGkTcnxAkU/LILRtRdDqcWT4HcIA/iwrkJYUUNFcFKAwpI9OM2Wr6MmJQKMwzIn2m21
        N+qdq7BgcC5MOD7Q+y33WAu3G+oCt9UNdhT1C2fLNn4E5DoSc0kJWPSaKFVdgNY1U27K+P/SXyLRr
        c7jqJuJQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j47U9-0003c6-Cb; Tue, 18 Feb 2020 18:20:41 +0000
Date:   Tue, 18 Feb 2020 10:20:41 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrei Vagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
Message-ID: <20200218182041.GB24185@bombadil.infradead.org>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 10:17:30AM -0800, Linus Torvalds wrote:
> @@ -722,9 +722,10 @@ pipe_release(struct inode *inode, struct file *file)
>  	if (file->f_mode & FMODE_WRITE)
>  		pipe->writers--;
>  
> -	if (pipe->readers || pipe->writers) {
> -		wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM | EPOLLERR | EPOLLHUP);
> -		wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM | EPOLLERR | EPOLLHUP);
> +	/* Was that the last reader or writer, but not the other side? */
> +	if (!pipe->readers != !pipe->writers) {
> +		wake_up_interruptible_all(&pipe->rd_wait);
> +		wake_up_interruptible_all(&pipe->wr_wait);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>  	}
> @@ -1026,8 +1027,8 @@ static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
>  
>  static void wake_up_partner(struct pipe_inode_info *pipe)
>  {
> -	wake_up_interruptible(&pipe->rd_wait);
> -	wake_up_interruptible(&pipe->wr_wait);
> +	wake_up_interruptible_all(&pipe->rd_wait);
> +	wake_up_interruptible_all(&pipe->wr_wait);
>  }

You don't want to move wake_up_partner() up and call it from pipe_release()?

