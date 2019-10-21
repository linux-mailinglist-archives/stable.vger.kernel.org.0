Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D808DE72F
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfJUI4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:56:19 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46113 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfJUI4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 04:56:18 -0400
Received: by mail-lf1-f65.google.com with SMTP id t8so9382639lfc.13;
        Mon, 21 Oct 2019 01:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+TVhX0pj0cp6PSiJ52MPNmOFMdXEiWzFfisANukiR/A=;
        b=PzJcr1STgaFqPo9lnBj1xDOoCdd+IaDmTpZKkGoE62joTo/L8d81vrXVGmofFj6Uot
         nvp3OidK/Hia42ZnzZ9FcDr3sqXCTF/UbXSYxeoEBNoENocg0xBQRAJEB042NJ7kIiTK
         Kv/uPuW9HWC8FmnYVLN4UGwVqn8HLSzg348y+ZoZrxFJv3UsgnXhQ8m9cBukaSN7G344
         fy4w6oP4OkIi7jStuWCNqU+tpiW6xBNvukPr5L5gLlkMNxSO9ekYNlanx5mM9cPCpnxn
         ugGkKXKVBpu7gSXq6xuwZb4dadO3IlcHLMSmFVbzVJ3ePweviIjWBbPTcDG4SzwX8oHt
         mvnA==
X-Gm-Message-State: APjAAAUOW2F06NiP0FHmTS4Kdy0dmvHRmCkoA1eybGhcfGf/yEkx6ECB
        mMISpTFg2nYWG/nmWB5JNOsgUXiq
X-Google-Smtp-Source: APXvYqzquYpUqEiEGDWjfqxRoITpWOiOqXDPraMRA4C29J5VcB4j+QFSHJXDWaT43iL9bW95n09JWg==
X-Received: by 2002:a19:e018:: with SMTP id x24mr12198432lfg.191.1571648175037;
        Mon, 21 Oct 2019 01:56:15 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id c22sm453212lfj.28.2019.10.21.01.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 01:56:14 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iMTUJ-0008Gb-3L; Mon, 21 Oct 2019 10:56:27 +0200
Date:   Mon, 21 Oct 2019 10:56:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RFC v2 2/2] USB: ldusb: fix ring-buffer locking
Message-ID: <20191021085627.GD24768@localhost>
References: <20191018151955.25135-1-johan@kernel.org>
 <20191018151955.25135-3-johan@kernel.org>
 <20191018185458.GA1191145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018185458.GA1191145@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 11:54:58AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Oct 18, 2019 at 05:19:55PM +0200, Johan Hovold wrote:
> > The custom ring-buffer implementation was merged without any locking
> > whatsoever, but a spinlock was later added by commit 9d33efd9a791
> > ("USB: ldusb bugfix").
> > 
> > The lock did not cover the loads from the ring-buffer entry after
> > determining the buffer was non-empty, nor the update of the tail index
> > once the entry had been processed. The former could lead to stale data
> > being returned, while the latter could lead to memory corruption on
> > sufficiently weakly ordered architectures.
> 
> Ugh.
> 
> This almost looks sane, but what's the odds there is some other issue in
> here as well?  Would it make sense to just convert the code to use the
> "standard" ring buffer code instead?

Yeah, long term that may be the right thing to do, but I wanted a
minimal fix addressing the issue at hand without having to reimplement
the driver and fix all other (less-critical) issues in there...

For the ring-buffer corruption / info-leak issue, these two patches
should be sufficient though.

Copying the ring-buffer entry to a temporary buffer while holding the
lock might still be preferred to avoid having to deal with barrier
subtleties. But unless someone speaks out against 2/2, I'd just go ahead
and apply it.

Johan
