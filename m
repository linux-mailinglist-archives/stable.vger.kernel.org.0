Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D826F2CF150
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgLDPyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729461AbgLDPyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 10:54:54 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1EDC061A4F;
        Fri,  4 Dec 2020 07:54:13 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cm17so6341213edb.4;
        Fri, 04 Dec 2020 07:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zO/lnZ8NaZABQdMJqO7ITwA6pWKefST87nWhdVmyakI=;
        b=IxQD4YqX2O/E37H5J516Q0NE5nfMAFOISY4o5aasgRcfTvRiDXtMYzGR6qb1UzxKYp
         7Y831iudbYXWZWJ+DVuaaki2gU4mS7fut1NFh83NIHvaN2Od+egrwNmYvstfkffYuIoZ
         SDOisZDuQF0S+dfSPi/KztBznH+aZUEiSnmcpXbAU/yM9eWeL9auQRdK1BvW4gD+YRdg
         oQoK4ta1zJR7oZJxsvlbLozNRF31eUTbkecHftm+u383brvcu+C4Kq7tenjJtrXVDOmV
         pStedE6trccaxDDr6x6PexJWrObxXl4GuBhNZ7qQa3cy9MtNU+C3yqVYDgkD8mIrvPnC
         H71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zO/lnZ8NaZABQdMJqO7ITwA6pWKefST87nWhdVmyakI=;
        b=JSsgQt5CgNUO0z7ogEX7g+FuOKJOcnySBmT9l9L0TNKtQJskQupYA3f6dIdA7w/L6p
         DmUHthZI4UXjVn+kvhjbMBMFDy7wQ2pQhvJI4/tkWWmEJ4jr+yAVdION/tYwQlDFET0T
         u2pYM/UKy+Of/fXN7op1dY+KedT3VkwvUDowZDjfjDLPpcntA6PSQNJCWnOAifCqxvBI
         VC/BlZZ1S0oClkAMpONIWwCu8PMrxktXL+74+TzrKGkNOj7oVunkip4qj25F1/bauWVN
         59cj448szKBdf+dvrCvAC0GL5529EacBZEwseicQMC6ysUgcwgfYD5M7aUxi8A5XSkAj
         Q9Ww==
X-Gm-Message-State: AOAM530M1maiN8AdmC4i0RnTdgSw8H10O7rWWxQAcmTxtxsjkDqzPxgc
        c00GhRxPkvRL8STFnrKbUVQ=
X-Google-Smtp-Source: ABdhPJyM+KQHySOyIZXJe/8GqKh7MhmWLNPzDyCGt734EGEbZ3fTdnQMGcEicy1GjbqoHoFlmFQs1Q==
X-Received: by 2002:a05:6402:202e:: with SMTP id ay14mr8484994edb.102.1607097252620;
        Fri, 04 Dec 2020 07:54:12 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id q23sm3545652edt.32.2020.12.04.07.54.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Dec 2020 07:54:12 -0800 (PST)
Message-ID: <26b88b53116e1ec34384f49461e8e3bda36dec7f.camel@gmail.com>
Subject: Re: [PATCH] mmc: block: Let CMD13 polling only for MMC IOCTLS with
 the R1B response
From:   Bean Huo <huobean@gmail.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "(Exiting) Baolin Wang" <baolin.wang@linaro.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        =?UTF-8?Q?=E5=BD=AD=E6=B5=A9=28Richard=29?= <richard.peng@oppo.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zliua@micron.com,
        "Zoltan Szubbocsev (zszubbocsev)" <zszubbocsev@micron.com>,
        "# 4.0+" <stable@vger.kernel.org>
Date:   Fri, 04 Dec 2020 16:54:09 +0100
In-Reply-To: <CAPDyKFpq-45z4MdMek0jGjR88QuG8PangcHRV+CJ4u57EcSqzg@mail.gmail.com>
References: <20201202202320.22165-1-huobean@gmail.com>
         <CAPDyKFpq-45z4MdMek0jGjR88QuG8PangcHRV+CJ4u57EcSqzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-12-04 at 15:38 +0100, Ulf Hansson wrote:
> > There is no need to poll device status through CMD13.
> > 
> > Meanwhile, based on the original change commit (mmc: block: Add
> > CMD13 polling
> > for MMC IOCTLS with R1B response), and comment in
> > __mmc_blk_ioctl_cmd(),
> > current code is not in line with its original purpose. So fix it
> > with this patch.
> > 
> > Fixes: a0d4c7eb71dd ("mmc: block: Add CMD13 polling for MMC IOCTLS
> > with R1B response")
> > Cc: stable@vger.kernel.org
> > Reported-by: Zhan Liu <zliua@micron.com>
> > Signed-off-by: Zhan Liu <zliua@micron.com>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> 
> Applied for fixes, thanks!
> 
> Note, I took the liberty to rephrase the commit message (and the
> header) to clarify things a bit more.
> 

Uffe,
Nice, thanks a lot.

Bean

