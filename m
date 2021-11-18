Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DC3455456
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 06:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242431AbhKRFjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 00:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243126AbhKRFjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 00:39:39 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81124C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 21:36:39 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so4595430pjb.5
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 21:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FbuwZKVsrv5z7nlTKq0LmNN6MMfMZu2th2nFb15pjzA=;
        b=AJUetIn2CxkX08LKpKBMbWWeacA13Lk76/yK4b1UDaXe3SDbJXzRC0WRkh/mYB7AJ6
         Fztb6W0vWtUdWmcue+S2/u3OO40kSeo+bEQYj3UgAsmZdIDzjT/vXrQ/59W++PqY9zLk
         Z/nFvCwYvKMtgwYN2s1+rAv6b6KYa+fXwPiUNHqPin2YMU4MaKF7udhcpBvSIBBDnHtN
         wb3C8WCAnvC0EHJ+E0zhQC488oAng3rttbyDCedLuqv8opqhZOVGZa91CQrR/uXvYCd9
         MkEOYeuXCtjxGBKzNWEPlse8RDLDC8aBM+zUc1D593k7SOgOfafW42rQXw1kuWA6NwC5
         U4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FbuwZKVsrv5z7nlTKq0LmNN6MMfMZu2th2nFb15pjzA=;
        b=ddwa2v2iDuKqGeqXI+1EBBh0YK7GtiStK5NqXXg2ofH2KK61JkSxc/XrptSjLIVqsA
         YRJetejqKxVXlIKDBxOE6JN/+I8Ki8qywvylw7+HTPK5bw3qm4fqZADFvHHkKQOGARiI
         nla1tjqq7Vm0Q7p8rAGd4lBT+rTY3/AQNgubHrvMD7N/Wx4ZKvw81XcK6SHbxaztRgON
         TS5kUaHlkxoz+ICqxA+euWyGI+ZaO9G/GhRtgfkosfMBiRtelwRRa2gL4qUIBGcDYwOp
         0MBEpaChQneXfDxdv1GLlMzmo3nezobMTizmIZBh3kh6ivKT0YnSHNzfiEVaM/3EExZZ
         UBrw==
X-Gm-Message-State: AOAM530COaqn19JK4qQ2hEIZnwvCXdFimDUOpiIYKT7ffUQUTziYmGa1
        YWixCgM6rYJRFtq7AwQRenlO
X-Google-Smtp-Source: ABdhPJxGM6F34J820TI7ruuMkReQsl49kgk0My/vvRDdqnNnCHdcQRqtX9s+CNtgoMxxIK8wd+LXFg==
X-Received: by 2002:a17:90a:c58f:: with SMTP id l15mr7054840pjt.168.1637213798998;
        Wed, 17 Nov 2021 21:36:38 -0800 (PST)
Received: from thinkpad ([117.202.188.63])
        by smtp.gmail.com with ESMTPSA id w5sm1519177pfu.219.2021.11.17.21.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 21:36:38 -0800 (PST)
Date:   Thu, 18 Nov 2021 11:06:33 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     Jeffrey Hugo <quic_jhugo@quicinc.com>, mhi@lists.linux.dev,
        aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: mhi: Fix race while handling SYS_ERR at power up
Message-ID: <20211118053633.GA6461@thinkpad>
References: <20211108174954.60569-1-manivannan.sadhasivam@linaro.org>
 <51338f3b-4c85-17b6-971b-44a50d59a262@codeaurora.org>
 <c6fd34ff-7f19-2ab1-ee3c-f6be178bf9a2@quicinc.com>
 <53240ad1-06e0-fdec-c8f6-33a83e6ae2af@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53240ad1-06e0-fdec-c8f6-33a83e6ae2af@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 12:20:34PM -0800, Hemant Kumar wrote:
> 
> 
> On 11/17/2021 9:24 AM, Jeffrey Hugo wrote:
> > On 11/8/2021 12:06 PM, Hemant Kumar wrote:
> > > Adding same comment in v2
> > > On 11/8/2021 9:49 AM, Manivannan Sadhasivam wrote:
> > > > Some devices tend to trigger SYS_ERR interrupt while the host handling
> > > > SYS_ERR state of the device during power up. This creates a race
> > > > condition and causes a failure in booting up the device.
> > > > 
> > > > The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> > > > handling in mhi_async_power_up(). Once the host detects that the device
> > > > is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> > > > process the reset request. During this time, the device triggers SYS_ERR
> > > Device is not triggering the SYS_ERR interrupt, interrupt was
> > > triggered due to MHI RESET was getting cleared by device.
> > 
> > Shouldn't the device state be RESET and not SYS_ERR at that point?
> > 
> > The device will enter SYS_ERR (and trigger an interrupt for that).  Host
> > issues MHI_RESET.  Device is expected to clear SYS_ERR and enter the
> > RESET state.  Then the device clears MHI_RESET.  Device can then trigger
> > an interrupt to signal the state change (per the updated spec).
> Dmesg log was showing first sys err was triggered by device, as part of sys
> error handling host was setting MHI_RESET and expecting to get BHI Intvec.
> When BHI intvec was triggered by device, host handled it by checking the MHI
> status register. MHi status was still showing SYS_ERR being set (which was
> supposed to get cleared after host issuing MHI RESET). Due to that host side
> bhi intvec threaded handler took diff path to handle sys error again. This
> is what we are trying to avoid as we think for some reason device is not
> behaving as per spec and either setting sys err again or not clearing it by
> the time bhi intvec (for reset clear) is handled by host.

If you look at the initial log shared by Aleksander you can see that there was
no IRQ from device until the host resets the device during powerup.

[    7.060730] mhi-pci-generic 0000:01:00.0: MHI PCI device found: sierra-em919x
[    7.067906] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
0x600000000-0x600000fff 64bit]
[    7.076455] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
[    7.083277] mhi-pci-generic 0000:01:00.0: using shared MSI
[    7.089508] mhi mhi0: Requested to power ON
[    7.094080] mhi mhi0: Attempting power on with EE: PASS THROUGH,
state: SYS ERROR
[    7.180371] mhi mhi0: local ee: INVALID_EE state: RESET device ee:
PASS THROUGH state: SYS ERROR

So once the host detects that the device is in SYS_ERR state (might have
happended during the warm reboot and the device went to a bad state), host
resets the device.

I'm going by the powerup scenario and in that case, the commit description is
valid.

Thanks,
Mani

> > 
> > I was going to add my reviewed-by, but I'm confused by your comment.
> > 
> [..]
> 
> Thanks,
> Hemant
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a
> Linux Foundation Collaborative Project
