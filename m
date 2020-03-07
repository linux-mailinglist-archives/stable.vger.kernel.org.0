Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE62E17CE55
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 14:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgCGNLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 08:11:41 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40668 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgCGNLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Mar 2020 08:11:41 -0500
Received: by mail-ot1-f65.google.com with SMTP id x19so5227669otp.7
        for <stable@vger.kernel.org>; Sat, 07 Mar 2020 05:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mvista-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J4p6CveRCCmA2UOrY+JX/CiuZIW93/gthzgtABNAuu0=;
        b=1/8MHk1O7FLY17YfXkC+nkMhj/pCDJQDaSXUX3nfjZ1VOTf+nyTAaJ94as4sPG+vXr
         zJ9Si1xqkRV0mX+f5k4aUstJVHiepuZEySL0zb5J9DL637dw+n2a7ESC4rZQExO6JHvv
         pX9L9QK2ZK/RH2ifCDy6iDNFzjzJlATTZggA0B7XFPGtGJeZwfx+k2O3dDCLsTmb1BcO
         Ouu5GQfqwz1hrDPc49OJedXO6nX5k1FkMHOHRe4VSUBxtC7ZU77g9hqsjqbL1FmVt0fz
         9QvSntzQky3OydY0/jyw4KxCShAH+cCEBY+af6bHZvkfiIVI6sR9iMG0W2kdv5WB+GhO
         jk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=J4p6CveRCCmA2UOrY+JX/CiuZIW93/gthzgtABNAuu0=;
        b=NyAZmrZ4izL6z0LZhrAvn7kG9N7cfg8XsU0hi4CHYup64yP0BST57ez8mLb0izSfxo
         vl9Hjno5avGOhMQgIxo3TCn+e/N9iesAQ+JN7tCdtLLEv4brooYfhR1mRnGPiQnMAW+E
         9DSiAwJAkMCysGi4CYuSJycDgEFKGz0CpliyHJ19jGSmw8Wpy+NX15lxe1Btis6ht9ZK
         tmfHLpVoNqhn2MXN23PvNDQIk3G/gQpMqhe3lxGdfNDzkptpeWKI/xqh/qA0orj7Es5P
         u19ZLEgCG8gwt0kla6GYAfrcXe+sOlCVBpQKxD19vDGFe8fvSVBShLMc5MXucKjHItAw
         FtjQ==
X-Gm-Message-State: ANhLgQ0mJ6HQa0l7XJXgr8tPmFkzMSGSyL7fU6vsp4EQJ9gfQJ9a6+K9
        pkisJvp9CqvprDFk0lKcY9msyQ==
X-Google-Smtp-Source: ADFU+vvVyZPXSmAxtQpvvaio/rX9SrEtO/27S7Qk9r3r3pkTzRT5RxNkJ+ip1g+0uhhEcY4rhK06VA==
X-Received: by 2002:a9d:7cd4:: with SMTP id r20mr6434214otn.148.1583586699738;
        Sat, 07 Mar 2020 05:11:39 -0800 (PST)
Received: from minyard.net ([2001:470:b8f6:1b:a549:b51b:bece:c41b])
        by smtp.gmail.com with ESMTPSA id o1sm12475012otl.49.2020.03.07.05.11.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 07 Mar 2020 05:11:38 -0800 (PST)
Date:   Sat, 7 Mar 2020 07:11:36 -0600
From:   Corey Minyard <cminyard@mvista.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     minyard@acm.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Adrian Reber <areber@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2] pid: Fix error return value in some cases
Message-ID: <20200307131136.GD2847@minyard.net>
Reply-To: cminyard@mvista.com
References: <20200306172314.12232-1-minyard@acm.org>
 <20200307110007.fmtaaqt2udsgohtp@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200307110007.fmtaaqt2udsgohtp@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 07, 2020 at 12:00:07PM +0100, Christian Brauner wrote:
> On Fri, Mar 06, 2020 at 11:23:14AM -0600, minyard@acm.org wrote:
> > From: Corey Minyard <cminyard@mvista.com>
> > 
> > Recent changes to alloc_pid() allow the pid number to be specified on
> > the command line.  If set_tid_size is set, then the code scanning the
> > levels will hard-set retval to -EPERM, overriding it's previous -ENOMEM
> > value.
> > 
> > After the code scanning the levels, there are error returns that do not
> > set retval, assuming it is still set to -ENOMEM.
> > 
> > So set retval back to -ENOMEM after scanning the levels.
> > 
> > Fixes: 49cb2fc42ce4 "fork: extend clone3() to support setting a PID"
> > Signed-off-by: Corey Minyard <cminyard@mvista.com>
> > Cc: <stable@vger.kernel.org> # 5.5
> > Cc: Adrian Reber <areber@redhat.com>
> > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> > Cc: Andrei Vagin <avagin@gmail.com>
> 
> Thanks! I've pulled the patch now and applied.
> 
> I think that restores the old behavior. If you don't mind, I'll add a
> comment on top of it saying something like:
> "ENOMEM is not the most obvious choice but it's the what we've been
>  exposing to userspace for a long time and it's also documented
>  behavior. So we can't easily change it to something more sensible."

That's great.  I was just looking through the code for another reason
and noticed the issue.  Every little thing counts for quality.

-corey

> 
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
