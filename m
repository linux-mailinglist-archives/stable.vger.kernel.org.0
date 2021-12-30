Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBBA481DC9
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 16:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbhL3Pom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 10:44:42 -0500
Received: from mail-qv1-f44.google.com ([209.85.219.44]:35730 "EHLO
        mail-qv1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhL3Pom (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 10:44:42 -0500
Received: by mail-qv1-f44.google.com with SMTP id kj16so22411686qvb.2;
        Thu, 30 Dec 2021 07:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z1Q52cq0OKcWOUis5rQNrlqR1ugktQWsBqg6wjrO+qY=;
        b=SvRdQ6mNvkFnKy8w7lyKBTFDTXhTlQren8Z9sn6NZekDECx8liMpkOYUvPuxIVPL0p
         FqfC3HphLhCk9f3etjyfUsSzvVqeEH+6Y4iDBhuRv8yqdBaC+bGdbdB6G/DOSOR4EeNJ
         qS6aYLWu4gCLLYbLjS8flv6UP/vQMNAALa9shSnUkuFabGYneZdhIT1MGPjdkOj2HXpt
         eJpeO7dZJkKvppady+iSok90Gi6f86R0uRVI6wi64tYyFrvDL2hpUT4y4LoKfyNDcIiV
         eo+QrLShNGkyzspznuCWNHT/a4L1IfaXSolqDf2DdKKvYj6O8b4Crp5/XB6oryweGkwG
         18LQ==
X-Gm-Message-State: AOAM5315YUP1o67Y4DZadO9KTL7156wxsPofx+CrSotLoalL2nKX0CWf
        wqN7y/khPak4pWgwqoxCiH0M2BFWzbtNRSiZv5JecyVX
X-Google-Smtp-Source: ABdhPJzmk7onV+onWk5XDeZZ8tgDir5l1ZpXYgH9AjtsQG4BOtAn4J/vjxeSr3fFlPuxOmuXTXJPlCJFyZIx3pNU/84=
X-Received: by 2002:ad4:5cec:: with SMTP id iv12mr13283996qvb.130.1640879081349;
 Thu, 30 Dec 2021 07:44:41 -0800 (PST)
MIME-Version: 1.0
References: <20211223094236.15179-1-sumeet.r.pawnikar@intel.com> <2b55b71aaa89e9010d58f5b3c7f5823782ab760c.camel@linux.intel.com>
In-Reply-To: <2b55b71aaa89e9010d58f5b3c7f5823782ab760c.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 30 Dec 2021 16:44:30 +0100
Message-ID: <CAJZ5v0hj83Bmw0-Yhb22xQHGauRWL-RADkiKQRuvcpYi3A45WA@mail.gmail.com>
Subject: Re: [PATCH v2] thermal/drivers/int340x: Fix RFIM mailbox write commands
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 4:31 PM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Thu, 2021-12-23 at 15:12 +0530, Sumeet Pawnikar wrote:
> > The existing mail mechanism only supports writing of workload types.
> > But mailbox command for RFIM (cmd = 0x08) also requires write operation
> > which was ignored. This results in failing to store RFI restriction.
> > This requires enhancing mailbox writes for non workload commands also.
> > So, remove the check for MBOX_CMD_WORKLOAD_TYPE_WRITE in mailbox write,
> > with this other write commands also can be supoorted. But at the same
> > time, we have to make sure that there is no impact on read commands,
> > by not writing anything in mailbox data register.
> > To properly implement, add two separate functions for mbox read and
> > write
> > command for processor thermal workload command type. This helps to
> > differentiate the read and write workload command types while sending
> > mbox
> > command.
> >
> > Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal:
> > Export additional attributes")
> > Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> > Cc: stable@vger.kernel.org # 5.14+
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Applied (with some edits in the changelog) as 5.17 material, thanks!
