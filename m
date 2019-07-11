Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC465BA4
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 18:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfGKQjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 12:39:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40250 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbfGKQjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 12:39:17 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so4937733qtn.7
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 09:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mj93UacmkzQe96ed++HjZVIA+pCGmuSxqYKJ2BWCrk0=;
        b=Fa0qunXPrrvUdJqQlSgGirR3Zr+WVsVhNsR+rmMcf3D5BamxiQBpIYX65/x01QkMXp
         /Mc/0ba/+7YGrfOkAyoEbnxD2c7Acd6DNyFTqeo7zi6+nl/CIf4+8/auhuzEajAwsLQB
         UGt3/rRSC/G7JoxdNuEiJ+FuQ4ut6RRCdTeG8NmEFAyeO7zv87RCw+BTuvY6UG/lW3NF
         wu3DwtoN+a+EO8C/dJxo9r/9GmbFrBE1t5Y7TCE/XKioP01CcI799uUjDtbMFkOrWUtt
         c+EscNf6f9P49QWOaYT3P35eNQ4w+Fzuxfh3uolb/r+cJo4Bg8M2zVEj33O9alrDK/Rk
         lROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mj93UacmkzQe96ed++HjZVIA+pCGmuSxqYKJ2BWCrk0=;
        b=qQZIi/luiSaUuythhd2JsxBUFGqZTO7mvJ0RjIRCbG0M35BpBfuITjIB52633FvEXJ
         shnr4YGvuzPr5AKwUgoJoY0oRemrwioHmrK+yceTBfMMpQEu6HyXpTC8/tIBqJu+7fW2
         EtMJP8JWmfD+Ikbvj1x2IRj9W1MWT2bsywHQCY8YNFriDGntPKg35k1bAZfd7PSxSxRz
         xGaeU6TdWf2aNYU+UuMuT0LJKVtE6i45OMge1PPnUEXBGtuY8L5k/ieoHYGHUXxyUOYr
         EhLvJEuMreHa4jnu6Iovr2wTkbHWhNcp/Tku8FnQVcNowczbz74uQF5xXpFO5orsN9yO
         b0Sw==
X-Gm-Message-State: APjAAAUYPPUeOKVbCY1jPUXwXPdG3jDSKW8gpUZ0mvp7cxMVzj9/7Jhk
        NvYtg5O3hLG4QqUxcg2VexIcwg==
X-Google-Smtp-Source: APXvYqzRA6gOJgy5jfVeGRE9t/Q0rKMwpDaSdQKc9GDPkpbiD9jd23Z8g2RuP9kl01lLIzgycVN08A==
X-Received: by 2002:a0c:df12:: with SMTP id g18mr2550145qvl.34.1562863156616;
        Thu, 11 Jul 2019 09:39:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id y3sm2453464qtj.46.2019.07.11.09.39.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jul 2019 09:39:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hlc6F-0007c3-Mh; Thu, 11 Jul 2019 13:39:15 -0300
Date:   Thu, 11 Jul 2019 13:39:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        gregkh@linuxfoundation.org, sukhomlinov@google.com,
        jarkko.sakkinen@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        Peter Huewe <peterhuewe@gmx.de>, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations
Message-ID: <20190711163915.GD25807@ziepe.ca>
References: <20190711162919.23813-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711162919.23813-1-dianders@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> From: Vadim Sukhomlinov <sukhomlinov@google.com>
> 
> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> 
> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> future TPM operations. TPM 1.2 behavior was different, future TPM
> operations weren't disabled, causing rare issues. This patch ensures
> that future TPM operations are disabled.
> 
> Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> [dianders: resolved merge conflicts with mainline]
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> This is the backport of the patch referenced above to 4.19 as was done
> in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> presumably applies to some older kernels.  NOTE that the problem
> itself has existed for a long time, but continuing to backport this
> exact solution to super old kernels is out of scope for me.  For those
> truly interested feel free to reference the past discussion [1].
> 
> Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> chip power gating out of tpm_transmit()") and commit 719b7d81f204
> ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> seem like a good idea to backport 17 patches to avoid the conflict.

Careful with this, you can't backport this to any kernels that don't
have the sysfs ops locking changes or they will crash in sysfs code.

Jason
