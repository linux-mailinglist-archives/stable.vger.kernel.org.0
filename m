Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830881E6766
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 18:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405030AbgE1Q1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 12:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404861AbgE1Q1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 12:27:44 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F7FF2071A;
        Thu, 28 May 2020 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590683263;
        bh=FXsa1IXEmq7ZbXD2Zo5pJa9s7kSrnXd/niS/9cKFOC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=janskBC84adnDeuh2KYcHkGpI8syj80yP9dQC6fIdlr0YXxzOcwttV/ekw2/bGyiC
         AjVzE07JuZUdKw2s5tjou4Y1nUke0Mt0Njn32qqSLyh2OklnM6/wL2wM9n42/7H+vr
         cXoiL5LTvjxSKxfs7Yf26gFFtQEPXChoB67wfk/s=
Date:   Thu, 28 May 2020 12:27:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.6.14-79935d9.cki (stable-queue)
Message-ID: <20200528162742.GA1407771@sasha-vm>
References: <cki.09562F3C51.NRM7O0HL2X@redhat.com>
 <1238663306.24257335.1590420227156.JavaMail.zimbra@redhat.com>
 <20200525154425.GB1016976@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525154425.GB1016976@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 05:44:25PM +0200, Greg KH wrote:
>On Mon, May 25, 2020 at 11:23:47AM -0400, Veronika Kabatova wrote:
>>
>>
>> ----- Original Message -----
>> > From: "CKI Project" <cki-project@redhat.com>
>> > To: "Linux Stable maillist" <stable@vger.kernel.org>
>> > Sent: Monday, May 25, 2020 5:22:14 PM
>> > Subject: ❌ FAIL: Test report for kernel 5.6.14-79935d9.cki (stable-queue)
>> >
>> >
>> > Hello,
>> >
>> > We ran automated tests on a recent commit from this kernel tree:
>> >
>> >        Kernel repo:
>> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> >             Commit: 79935d99370b - x86/unwind/orc: Fix
>> >             unwind_get_return_address_ptr() for inactive tasks
>> >
>> > The results of these automated tests are provided below.
>> >
>> >     Overall result: FAILED (see details below)
>> >              Merge: OK
>> >            Compile: FAILED
>> >
>> > All kernel binaries, config files, and logs are available for download here:
>> >
>> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/05/25/580491
>> >
>> > We attempted to compile the kernel for multiple architectures, but the
>> > compile
>> > failed on one or more architectures:
>> >
>> >            aarch64: FAILED (see build-aarch64.log.xz attachment)
>> >
>>
>> Hi,
>>
>> this looks like a bug in the revert.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.6&id=1d69ec1bac630983a00b62f155503c53559b3c14
>>
>> attempts to revert the following commit:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.6&id=5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f
>>
>> but the bus.c changes are not reverted, only bus.h.
>
>Yeah, that's not right, it should not be applied to the tree at that
>point in time.  I'll go drop it now, thanks.

I still can't explain this behavior:

$ git show a9d68cbd4f8834d126ebdd3097a1dee1c5973fdf
commit a9d68cbd4f8834d126ebdd3097a1dee1c5973fdf
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Apr 1 08:03:28 2020 +0200

     Revert "amba: Initialize dma_parms for amba devices"
     
     This reverts commit 5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f.  It still
     needs some more work and that will happen for the next release cycle,
     not this one.
     
     Cc: <stable@vger.kernel.org>
     Cc: Russell King <linux@armlinux.org.uk>
     Cc: Christoph Hellwig <hch@lst.de>
     Cc: Ludovic Barre <ludovic.barre@st.com>
     Cc: Linus Walleij <linus.walleij@linaro.org>
     Cc: Arnd Bergmann <arnd@arndb.de>
     Cc: Ulf Hansson <ulf.hansson@linaro.org>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 5e61783ce92d..fe1523664816 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -374,8 +374,6 @@ static int amba_device_try_add(struct amba_device *dev, struct resource *parent)
         WARN_ON(dev->irq[0] == (unsigned int)-1);
         WARN_ON(dev->irq[1] == (unsigned int)-1);
  
-       dev->dev.dma_parms = &dev->dma_parms;
-
         ret = request_resource(parent, &dev->res);
         if (ret)
                 goto err_out;
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 0bbfd647f5c6..26f0ecf401ea 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -65,7 +65,6 @@ struct amba_device {
         struct device           dev;
         struct resource         res;
         struct clk              *pclk;
-       struct device_dma_parameters dma_parms;
         unsigned int            periphid;
         unsigned int            cid;
         struct amba_cs_uci_id   uci;
$ git cherry-pick a9d68cbd4f8834d126ebdd3097a1dee1c5973fdf
Auto-merging drivers/amba/bus.c
[queue-5.6 f8d6a52860ef] Revert "amba: Initialize dma_parms for amba devices"
  Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
  Date: Wed Apr 1 08:03:28 2020 +0200
  1 file changed, 1 deletion(-)
$ git show
commit f8d6a52860ef85fdf14a06cf5429aea145bfb62e (HEAD -> queue-5.6)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Apr 1 08:03:28 2020 +0200

     Revert "amba: Initialize dma_parms for amba devices"
     
     This reverts commit 5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f.  It still
     needs some more work and that will happen for the next release cycle,
     not this one.
     
     Cc: <stable@vger.kernel.org>
     Cc: Russell King <linux@armlinux.org.uk>
     Cc: Christoph Hellwig <hch@lst.de>
     Cc: Ludovic Barre <ludovic.barre@st.com>
     Cc: Linus Walleij <linus.walleij@linaro.org>
     Cc: Arnd Bergmann <arnd@arndb.de>
     Cc: Ulf Hansson <ulf.hansson@linaro.org>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 0bbfd647f5c6..26f0ecf401ea 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -65,7 +65,6 @@ struct amba_device {
         struct device           dev;
         struct resource         res;
         struct clk              *pclk;
-       struct device_dma_parameters dma_parms;
         unsigned int            periphid;
         unsigned int            cid;
         struct amba_cs_uci_id   uci;

-- 
Thanks,
Sasha
