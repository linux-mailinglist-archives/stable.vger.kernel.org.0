Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A5F1C915
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 14:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfENM5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 08:57:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44253 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfENM5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 08:57:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id n134so384022lfn.11;
        Tue, 14 May 2019 05:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jYgL1RLJt9wtGNCMOIgU9rBpFFCNuNhhzqFQOumFLNg=;
        b=JhxB0EIAEhEzAEP1rckAD+fDPByUkgZCERNEj/M5sEkjNVbMXFaoVNofkSynAbheLB
         tFu7WPQ3v2Yiq4CxozczEHXDdtPtfoF+5/IWlumWqfuW3cX16+SNe7quCoT7PoAfRMxA
         MXCa7XlFjM91cTO8C/Iz7Npz/dLOyDmPTB7fmcASlNd5VswyH7mtzhMNFlauJw6LRj8z
         +bvcdM+KJ9i9iQeX2WCfPC10AxPMWP6BUL+ttyqObGm0S5wBDOiUgHXRLz+QH3LUKwF5
         PSvRKc6c72zUSoattRDnYWbBRB8fzB+hOwGfYM58qwQ6mbF2Uf2LZucYgi61uUc5gHDW
         vf4w==
X-Gm-Message-State: APjAAAUN+ZuQJEp51VkkFp+/vM2GylLFn52sd5vV7XxhFTzs7LAed7iK
        VJngWpubIM0fCdt9ASuFBz4=
X-Google-Smtp-Source: APXvYqxJWsUCoEuDB+D5JiE/3v213Y39jSCGXQQFI00oowJGkBu35edLPsJWkwsKIYHhfSV2qJ2QHA==
X-Received: by 2002:ac2:41da:: with SMTP id d26mr16529746lfi.34.1557838660737;
        Tue, 14 May 2019 05:57:40 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id q7sm3727592lje.41.2019.05.14.05.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 05:57:39 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hQWzw-00052I-S0; Tue, 14 May 2019 14:57:36 +0200
Date:   Tue, 14 May 2019 14:57:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190514125736.GA19293@localhost>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
 <20190513104339.GA9651@localhost>
 <20190513105606.GA21346@kroah.com>
 <20190513114601.GB9651@localhost>
 <20190513125131.GA7541@kroah.com>
 <20190513125909.GC9651@localhost>
 <20190514125353.GL11972@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514125353.GL11972@sasha-vm>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 08:53:53AM -0400, Sasha Levin wrote:
> On Mon, May 13, 2019 at 02:59:09PM +0200, Johan Hovold wrote:
> >On Mon, May 13, 2019 at 02:51:31PM +0200, Greg Kroah-Hartman wrote:
> >> On Mon, May 13, 2019 at 01:46:01PM +0200, Johan Hovold wrote:
> >
> >> > Thanks. The issue has been there since v3.3 so I guess you could queue
> >> > it for all stable trees.
> >>
> >> Doesn't apply cleanly for 4.4.y or 3.18.y, so if it's really worth
> >> adding there (and I kind of doubt it), I would need a backport :)
> >
> >Ah ok, just wasn't sure why you chose 4.9+.
> 
> On 4.4 and 3.18 it just had a contextual conflict because of
> 3161da970d38c ("USB: serial: use variable for status"), I can queue both
> 3161da970d38c and 3f5edd58d040b for 4.4 and 3.18.

Sounds good, thanks!

Johan
