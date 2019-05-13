Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22C11B436
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 12:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfEMKnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 06:43:47 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45757 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbfEMKnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 06:43:47 -0400
Received: by mail-lj1-f193.google.com with SMTP id r76so10437417lja.12;
        Mon, 13 May 2019 03:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h4/ZkVCc1t3s7E6eepp7k0TrGVSnDFGVQyOK9iwfzs8=;
        b=mNvQTLDcbNKERdiRT9zaG3Hk9rT18jP/4RI3x7Fr4UE7xttkvbyoZAgUUOMpmGCU4O
         +CzT7KbssQqj8q8ra+jiizMRCf0eHE5kITVBBHJWqd3hf6cINrdXx7r3RKTgQwfldzw2
         ErF7B6gYiYB7GEYGSuHvQTp4h/yRBY/7jgkuVE/EldnrK7wMDHVZfGTbIN6tOE7HI8e8
         VjOr7dtXdjHywYlcW0l04lchkiLkD0Wy1PtgTtu1pKiCTI8AJ2Ya/Vjxnx44fig1aByr
         PpCFQeVfkrhGu9Pw6cQYiDuFsM+s4EaPsbnM2rm8r/kJn5l/PLsym6u3nNacYZFxQfOH
         UF3w==
X-Gm-Message-State: APjAAAWQ7uJkp+W9xhLSY32sxJ/H4qfu4cKej+lCUAO0g4rAxyTqVgxR
        Lvq4AR001bydqvhwW4E1vGchzdn1
X-Google-Smtp-Source: APXvYqwUz/Xx0PO8e//1chpDexhPeQK89cUWDoVhyJEM9iWDe8xB/TG+oRs+jx6xcy5fMi40In2JYg==
X-Received: by 2002:a2e:8654:: with SMTP id i20mr12977051ljj.26.1557744224751;
        Mon, 13 May 2019 03:43:44 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id 78sm3663179lje.81.2019.05.13.03.43.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 03:43:43 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hQ8Ql-0007Tr-6A; Mon, 13 May 2019 12:43:39 +0200
Date:   Mon, 13 May 2019 12:43:39 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190513104339.GA9651@localhost>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425160540.10036-2-johan@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 25, 2019 at 06:05:36PM +0200, Johan Hovold wrote:
> Fix two long-standing bugs which could potentially lead to memory
> corruption or leave the port throttled until it is reopened (on weakly
> ordered systems), respectively, when read-URB completion races with
> unthrottle().
> 
> First, the URB must not be marked as free before processing is complete
> to prevent it from being submitted by unthrottle() on another CPU.
> 
> 	CPU 1				CPU 2
> 	================		================
> 	complete()			unthrottle()
> 	  process_urb();
> 	  smp_mb__before_atomic();
> 	  set_bit(i, free);		  if (test_and_clear_bit(i, free))
> 	  					  submit_urb();
> 
> Second, the URB must be marked as free before checking the throttled
> flag to prevent unthrottle() on another CPU from failing to observe that
> the URB needs to be submitted if complete() sees that the throttled flag
> is set.
> 
> 	CPU 1				CPU 2
> 	================		================
> 	complete()			unthrottle()
> 	  set_bit(i, free);		  throttled = 0;
> 	  smp_mb__after_atomic();	  smp_mb();
> 	  if (throttled)		  if (test_and_clear_bit(i, free))
> 	  	  return;			  submit_urb();
> 
> Note that test_and_clear_bit() only implies barriers when the test is
> successful. To handle the case where the URB is still in use an explicit
> barrier needs to be added to unthrottle() for the second race condition.
> 
> Fixes: d83b405383c9 ("USB: serial: add support for multiple read urbs")
> Signed-off-by: Johan Hovold <johan@kernel.org>

Greg, I noticed you added a stable tag to the corresponding cdc-acm fix
and think I should have added on one from the start to this one as well.

Would you mind queuing this one up for stable?

Upstream commit 3f5edd58d040bfa4b74fb89bc02f0bc6b9cd06ab.

Thanks,
Johan
