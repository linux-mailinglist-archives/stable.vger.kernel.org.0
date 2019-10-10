Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719DFD27B2
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 13:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbfJJLF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 07:05:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40077 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJLF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 07:05:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so5727391ljw.7;
        Thu, 10 Oct 2019 04:05:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yLh7JEosc8/YKKoaccAHxQzNNxp98VnrY6lbzw+kJRs=;
        b=qr5EPNo7ZkhpwbsGkeHyNZvsBplGInueGpUZ7ij8Dt3SfC9LQ4BaMiFFkwSOAf3wrT
         jkCxvAqEil6tYsMN3I1myALGWg+QLgOX61NRihxqYAL+MvTXVDPQGGrwBOOJC3a8rZuT
         CHcutgcGJm8xIN06OyuXTHZ6UE+cYsg1d7/1HdFJXXqgu6z3y7qnFic2gz/V7/MYm7xp
         mEPobvEQTHq0uiLlKHKbOhvI7Dke60Iefk/WShnFvHZAUCk0/LdC58RmfknhaFsIwRSa
         r3qdpzZmf8l5LervNSIC7Bpu2Rl2iPwL7Jmg8uv1g6oHLPaKVyFr4fkKB/ipvP7j4R+k
         lUVA==
X-Gm-Message-State: APjAAAXW9B6c4Yijdzk+sUdc5XjKHbVWLOnoQU9+Ub21Bdy5Ou2Nh1+O
        mGoBMfUm5KbKWla1R6FEzLVMd1j9
X-Google-Smtp-Source: APXvYqwz1Yqb8r9cXYFSQdXswbWtcpUhvmcXZwCDeMeaxjbyS0doU8s7n8yAs35jBKDdLFa3ThljQg==
X-Received: by 2002:a2e:9913:: with SMTP id v19mr5768557lji.234.1570705523271;
        Thu, 10 Oct 2019 04:05:23 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id q124sm1133987ljb.28.2019.10.10.04.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 04:05:22 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iIWGC-0003MM-LN; Thu, 10 Oct 2019 13:05:32 +0200
Date:   Thu, 10 Oct 2019 13:05:32 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] USB: yurex: fix NULL-derefs on disconnect
Message-ID: <20191010110532.GC27819@localhost>
References: <20191009153848.8664-1-johan@kernel.org>
 <20191009153848.8664-6-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009153848.8664-6-johan@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 05:38:48PM +0200, Johan Hovold wrote:
> The driver was using its struct usb_interface pointer as an inverted
> disconnected flag, but was setting it to NULL without making sure all
> code paths that used it were done with it.
> 
> Before commit ef61eb43ada6 ("USB: yurex: Fix protection fault after
> device removal") this included the interrupt-in completion handler, but
> there are further accesses in dev_err and dev_dbg statements in
> yurex_write() and the driver-data destructor (sic!).
> 
> Fix this by unconditionally stopping also the control URB at disconnect
> and by using a dedicated disconnected flag.
> 
> Note that we need to take a reference to the struct usb_interface to
> avoid a use-after-free in the destructor whenever the device was
> disconnected while the character device was still open.
> 
> Fixes: aadd6472d904 ("USB: yurex.c: remove dbg() usage")
> Fixes: 45714104b9e8 ("USB: yurex.c: remove err() usage")
> Cc: stable <stable@vger.kernel.org>     # 3.5: ef61eb43ada6
> Signed-off-by: Johan Hovold <johan@kernel.org>

Greg, I noticed that you picked up all patches in this series except
this last one.

Was that one purpose or by mistake?

Johan
