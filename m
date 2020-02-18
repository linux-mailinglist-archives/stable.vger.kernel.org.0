Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C889616362E
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 23:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBRWda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 17:33:30 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35935 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgBRWda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 17:33:30 -0500
Received: by mail-pj1-f66.google.com with SMTP id gv17so1629186pjb.1;
        Tue, 18 Feb 2020 14:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ao1rrYj1H0zRksEUEqAme5C6lEjb904ensDRNheQK20=;
        b=vPmZ2aJ18jzSVQ8YIoEAysedZOU82k34+gaeB7WykgbG2teu7j+joqZllEOkppWT5i
         VFLVIRqlIwMK/fIGvbqTns/mHxwTxY7a9+PTIlWpSS6JzCU2EcYO0G1FT9+6rQ/ybtsQ
         T6sB4qLRVc2qoI/a2p0X8HHx8Smujml+K3fIL+fqzIqfTyx/mXQHtrjTqzihCVu9Te2Q
         +rcquj6uDJbQloNRyKSfNcfw7prEgGvEW4YiydcqCrliXLQn2eXfFsMkmaWpl7mx4/uu
         IF6LTK3YzgRp3tKgDu5VIkNRH168Wjlkxf+a+m2dEdLlIHX8MCamP8b8oruy0fDH6JWt
         bwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ao1rrYj1H0zRksEUEqAme5C6lEjb904ensDRNheQK20=;
        b=VQ88NdvKdKEiFBx3Q+eJi3nHemW4wlgiH+qxnKVrpPOH6arPTPVRtkoUOwLNTk60tP
         uuaCBZkKKBIP/azJzmN5KMjuzC3KN9gBlk0wkwz3CpaE6P5cop0Qso9ddOd9Q1x34ogR
         b+1lYFpI/ayilzR88jt4doz2cLoyGwSMGNs6ck3aZFZ987YR3jFocqF/f7tKFDjNUlhj
         b2D28xBhECzY9Tv5n7/uuMWD8sXcsODBx0fiVMXTfSkwyF3V2pr9ZK1n3x05gBiTCuOE
         Vuz9sMqvaQBO7Ipi4z0ndbwbdGcZjShijpir05j+YST0z07VHXEf/R2nBuhSYMi9izlE
         VXWw==
X-Gm-Message-State: APjAAAXGWewLg7yjH1zbCGAyF0CH8nHokb3ac8b/YD0lR5EjqxvdJvYj
        S6svpzKa72yH6E7JRX3Yodc=
X-Google-Smtp-Source: APXvYqx5Gf+hUMerX5qr+HlwdoEd+NvK/lpti4mRRuvDUzSNfzI14C1R1JMMJQAkkA6yDdtkN6SPoQ==
X-Received: by 2002:a17:902:7c88:: with SMTP id y8mr23321086pll.321.1582065208792;
        Tue, 18 Feb 2020 14:33:28 -0800 (PST)
Received: from gmail.com ([2620:0:1008:fd00:25a6:3140:768c:a64d])
        by smtp.gmail.com with ESMTPSA id l26sm5686616pgn.46.2020.02.18.14.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 14:33:27 -0800 (PST)
Date:   Tue, 18 Feb 2020 14:33:25 -0800
From:   Andrei Vagin <avagin@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
Message-ID: <20200218223325.GA143300@gmail.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
 <20200218182041.GB24185@bombadil.infradead.org>
 <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 10:28:23AM -0800, Linus Torvalds wrote:
> On Tue, Feb 18, 2020 at 10:20 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > You don't want to move wake_up_partner() up and call it from pipe_release()?
> 
> I was actually thinking of going the other way - two of three users of
> wake_up_partner() are redundantly waking up the wrong side, and the
> third user is pointlessly written too.
> 
> So I was _thinking_ of a patch like the appended (which is on top of
> the previous patch), but ended up not doing it. Until you brought it
> up.
> 
> But I won't bother committing this, since it shouldn't really matter.

I run CRIU tests on the kernel with both these patches. Everything work
as expected. Thank you for the fix.

> 
>                  Linus

>  fs/pipe.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 2144507447c5..79ba61430f9c 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1025,12 +1025,6 @@ static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
>  	return cur == *cnt ? -ERESTARTSYS : 0;
>  }
>  
> -static void wake_up_partner(struct pipe_inode_info *pipe)
> -{
> -	wake_up_interruptible_all(&pipe->rd_wait);
> -	wake_up_interruptible_all(&pipe->wr_wait);
> -}
> -
>  static int fifo_open(struct inode *inode, struct file *filp)
>  {
>  	struct pipe_inode_info *pipe;
> @@ -1078,7 +1072,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
>  	 */
>  		pipe->r_counter++;
>  		if (pipe->readers++ == 0)
> -			wake_up_partner(pipe);
> +			wake_up_interruptible_all(&pipe->wr_wait);
>  
>  		if (!is_pipe && !pipe->writers) {
>  			if ((filp->f_flags & O_NONBLOCK)) {
> @@ -1104,7 +1098,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
>  
>  		pipe->w_counter++;
>  		if (!pipe->writers++)
> -			wake_up_partner(pipe);
> +			wake_up_interruptible_all(&pipe->rd_wait);
>  
>  		if (!is_pipe && !pipe->readers) {
>  			if (wait_for_partner(pipe, &pipe->r_counter))
> @@ -1120,12 +1114,12 @@ static int fifo_open(struct inode *inode, struct file *filp)
>  	 *  the process can at least talk to itself.
>  	 */
>  
> -		pipe->readers++;
> -		pipe->writers++;
> +		if (pipe->readers++ == 0)
> +			wake_up_interruptible_all(&pipe->wr_wait);
> +		if (pipe->writers++ == 0)
> +			wake_up_interruptible_all(&pipe->rd_wait);
>  		pipe->r_counter++;
>  		pipe->w_counter++;
> -		if (pipe->readers == 1 || pipe->writers == 1)
> -			wake_up_partner(pipe);
>  		break;
>  
>  	default:

