Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E8C42C5D1
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhJMQHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbhJMQHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:07:54 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CADEC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 09:05:51 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o204so4413079oih.13
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 09:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rpopLFh8ojCGcqr8NWLhMV5N3onX0hCvDnlEQaTzyE=;
        b=h3qrFhA+2rg0TgahrCMTHhOw1HgJdaTVrlZjujHkW+/iJc6zdwGMb6fBSCRs2n0TPk
         yGCuLVN/Wg0YVJgBywyHEQLsK5GYS1o7R4vBd5o5iKuYWu0HRdUU+IKYWbbFy0xsMfTX
         sFRamZ1FSZ/c+Pl/YOtvayK489b8SPzJ0kTDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rpopLFh8ojCGcqr8NWLhMV5N3onX0hCvDnlEQaTzyE=;
        b=Lir8cQ6KSKvl2mjC4nnDSjCDko3zLZYkVMJjp0gF2k2p2dGFlDOrMzJehe6Er8Pnf7
         W7nf6kTb84ksVq0zoyv5vfZ3fBZ2bX540DCcoL3ubNNEVZ8n2ZjXi8+pG16Tbum5EGEE
         7U+lINMNqCIiMMRcKjq2XJG8OqpHp1GaZlsmcwPJmCCl2vgv9qD9cRncHN72ePHn1/0v
         gyeDZ3uYEvbo3osCLk1aO1AwOMDPZrkwdtv5pU+LrTr8Q4K8E6hAIYWFjQpXPnyxCRkY
         HxlFzoF6nhd0ziblxAnM8cA03z/l5gXCEg87cGWE+g+vGx+lVoj1sJxvTxSLwoQ7abjV
         Hk7Q==
X-Gm-Message-State: AOAM531BK++QGZ0b2QCV0GftM9rLf57v0wUp7OKy6PdfTheeoBtoVXTj
        PQQvPiV7Up//W870VFXTiPZf12/HhtVZt3RdMJR13w==
X-Google-Smtp-Source: ABdhPJxborwmSSryJNf+y7Lh2rI3AlZYNyWpXCj/OdJxJslsqMv8BF6Ub2c+ZcfYLl4bmrZdCBy65HXkm/vBopjQkY0=
X-Received: by 2002:aca:af91:: with SMTP id y139mr1995oie.7.1634141150292;
 Wed, 13 Oct 2021 09:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211013081656.16494-1-sreekanth.reddy@broadcom.com> <YWaXmqGGOtJaRbOk@kroah.com>
In-Reply-To: <YWaXmqGGOtJaRbOk@kroah.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 13 Oct 2021 21:35:39 +0530
Message-ID: <CAK=zhgo4CThfpRf37J3wufSjVByErdriBFpjMeBx2EumiRhR=A@mail.gmail.com>
Subject: Re: [PATCH] mpi3mr: Fix duplicate device entries when scan through sysfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 1:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 13, 2021 at 01:46:56PM +0530, Sreekanth Reddy wrote:
> > When the user scans the devices through 'scan' sysfs using below
> > command then the user will observe duplicate device entries
> > in lsscsi command output.
> > echo "- - -" > /sys/class/scsi_host/host0/scan
> >
> > Fix is to set the shost's max_channel to zero.
> >
> > Cc: stable@vger.kernel.org #v5.14.11+
>
> Please tag this based on a release of Linus's, or better yet, provide a
> "Fixes:" commit so that the stable people know exactly where to backport
> it to.
Thanks, Shall I resend the patch with proper "Fixes:" commit ID.

>
> As this is, we do not take patches only for stable kernels...
This fix applies for the mainline kernel as well.

Thanks,
Sreekanth
>
> thanks,
>
> greg k-h
