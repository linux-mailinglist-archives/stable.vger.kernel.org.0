Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7AACF9A3
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 14:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfJHMTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 08:19:51 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:46337 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfJHMTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 08:19:50 -0400
Received: by mail-oi1-f179.google.com with SMTP id k25so14534067oiw.13
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 05:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mvista-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GIG3/erJQ11vZy1ZvW+DrK2VeOVE/GSaMMKgSlpyZZM=;
        b=twHANZAsI9ZGdyC0yiVIfRbHW/uHdB0ek8OO8I2YmwQCSctRjQmyKBPDcbgdQ/wnLz
         yDO7ZIuyUhSw6BH/VLK1JibAbSABc+fANVOqVHyvPe/RYjnuZBZm9UKwdEkCpj4FWSIF
         aY3ItNY+ZlOYc9llnQn5NOFZQHY3+KmYar8KfgA8a8QOKX+krkY2xu1lb+GhHZDVUU+E
         1OTWdggfmkf7S4Lkf5nAjFWDeNmGlIEWSkCULequMVcaQmtP8kAHlRnAtsqlPODiBRrb
         8NyA2lYpOp9BAECCRhf3fvWGXhL7G/seuKALWC8vzgRJi7CARNelhQyTLIdq1v4uwF8B
         940g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GIG3/erJQ11vZy1ZvW+DrK2VeOVE/GSaMMKgSlpyZZM=;
        b=maCh0h2pmyCxgSZ5YTFBB5+q9oGTWo31npx2rqcgtprJPqxYhkxd6rVPPWG2UZtkC5
         TsjoaY704shvxezuiSPGqH3xzemeg4b9OzNNfMLqEixsItvZ6+fmn0WXfOZr/ClFAKOz
         BR4IcrFNdSNHG//171RHKrGdFYgkbLOxSuPMh5yj3E7gzX0c1fTRY8N/W7tbEEeCs10Z
         /WZTFFk6XXYL8gqSha4Lk0jnTy+ena6agGtKzuuXafTCFZhXG+WJ+R1d4gfJTw75LrSW
         fNYvUD69q7zgDBmtG7AqwlbaGMrqNh2OEVOC+WVfTxqY+LPfWhu2qgCEJytkBFX2nYc+
         q0Pw==
X-Gm-Message-State: APjAAAUXkGbtgyDH8+ciuddsDs/xdZ3QFwL3YYe2hDDbkHU4OjB+9eTG
        4pzXPOf8nImKkBuDPRxGlIN6oA==
X-Google-Smtp-Source: APXvYqyJ7UdWwBKkU/Iyie1JZFv08c9kyvlVoDj56G9F1U7knWplJ8VJuoRWovvihxy2D0npliNXtg==
X-Received: by 2002:a05:6808:4c3:: with SMTP id a3mr3708645oie.82.1570537183673;
        Tue, 08 Oct 2019 05:19:43 -0700 (PDT)
Received: from t560 ([47.184.136.59])
        by smtp.gmail.com with ESMTPSA id g8sm5115524otp.42.2019.10.08.05.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Oct 2019 05:19:42 -0700 (PDT)
Date:   Tue, 8 Oct 2019 07:19:41 -0500
From:   Corey Minyard <cminyard@mvista.com>
To:     Pavel Machek <pavel@denx.de>, Tejun Heo <tj@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/106] ipmi_si: Only schedule continuously in the
 thread in maintenance mode
Message-ID: <20191008121941.GA14232@t560>
Reply-To: cminyard@mvista.com
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171130.485953894@linuxfoundation.org>
 <20191008094915.GC608@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008094915.GC608@amd>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 11:49:15AM +0200, Pavel Machek wrote:
> Hi!
> 
> > @@ -1013,11 +1016,20 @@ static int ipmi_thread(void *data)
> >  		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
> >  		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
> >  						  &busy_until);
> > -		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
> > +		if (smi_result == SI_SM_CALL_WITHOUT_DELAY) {
> >  			; /* do nothing */
> > -		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
> > -			schedule();
> > -		else if (smi_result == SI_SM_IDLE) {
> > +		} else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait) {
> > +			/*
> > +			 * In maintenance mode we run as fast as
> > +			 * possible to allow firmware updates to
> > +			 * complete as fast as possible, but normally
> > +			 * don't bang on the scheduler.
> > +			 */
> > +			if (smi_info->in_maintenance_mode)
> > +				schedule();
> > +			else
> > +				usleep_range(100, 200);
> > +		} else if (smi_result == SI_SM_IDLE) {
> 
> This is quite crazy code. usleep() will need to do magic with high
> resolution timers to provide 200usec sleep... when all you want to do
> is unload the scheduler.
> 
> cond_resched() should be okay to call in a loop, can the code use that
> instead?

According to Tejun Heo, spinning in a loop sleeping was causing all
sorts of issues with banging on scheduler locks on systems with lots of
cores.  I forgot to add him to the CC on the patch, adding him now
for comment.

If cond_resched() would work, though, I'd be happy with that, it's
certainly simpler.

-corey

> 
> Best regards,
> 									Pavel
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


