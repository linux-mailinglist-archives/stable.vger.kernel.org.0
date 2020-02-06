Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B6154B29
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 19:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBFSbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 13:31:51 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37755 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBFSbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 13:31:51 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so5994282iln.4;
        Thu, 06 Feb 2020 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4AhH/JP7ecaggoU/3Xca4yat7a+cC5Q5aOpBVAxftg=;
        b=C7BQaXnAOqM8Sok3R0FnFkyfrfBJxL6q0zntnFpQiJjEGiny8aewiRHNHohUZgEiqA
         jAk3icLackoSk6FTPJXKJUifNZkBaABbIx9yMRG1MMruhH3u7ebJhf5dRvkM/obW5Q9/
         Fmv41POi41mhPLWJI8+GKFLeLp6WrqUsK2EOlcr8K9VCv+QCrakqKJpgbeUgtH+XqXKH
         e61aDO+ia+mnO3CWqOop9PpP4te1O6UVMvr51ubAsltmiKNuAWutlkWtZ4tbiEkMTC6g
         1AtpdxdrG/tlliCMW8Xpx3vtgyxVmQA9nKb4YSJ7DiA8uxQkdGyZNFIowpGr5bc04Re5
         y71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4AhH/JP7ecaggoU/3Xca4yat7a+cC5Q5aOpBVAxftg=;
        b=oQCvIUmrej+BqMnNP7bUf2QKC/92rvdaMWJvwdwbgpFRDlqc7GYWv1kJH8wD/ltYDw
         4RWOSAFygM+cSqFKSr0XAQEEpjRax5AbDkZtJc9ypSEoPRL9H5JpB3nKZ9eo/ZjgY4tk
         vGvAmnculSQrYurB0o5+Dv1gngscViPdSC6x5XIg+q/aZnvpBK6oR9X6Wy1VB08S8GuY
         PGF/Cjn5YoIg8zpuPgrL4Dep4aYjIxBKKvwrshr6IWP+MImzlADhR4P3eHYZP0mtqQdr
         YiM+3xpaUP3GwGQIOSCTS+PadyMznn22jnMXlb2SkU98Jqzsj28L6/j3i8S0xxwnNhUX
         72Vg==
X-Gm-Message-State: APjAAAVl0Y/njNegYB9nuPQM///ncPLp7U6TL8hoQd6qHEDfFZZCZbqK
        5psH2ffkQzT1eUSU5mYns34YpCi7cy+mVUgUN/o=
X-Google-Smtp-Source: APXvYqy6gL7EK9zgzXgF7c65FiQ4qme7aF9GpykY4gKvlr8jcc8ohu2RAVZFHxAqFRXnilDmaDbtzExYKA14f1XJx+Y=
X-Received: by 2002:a92:290a:: with SMTP id l10mr5231623ilg.151.1581013910171;
 Thu, 06 Feb 2020 10:31:50 -0800 (PST)
MIME-Version: 1.0
References: <20200205194804.1647-1-mst@semihalf.com> <20200206092521.GM10400@smile.fi.intel.com>
In-Reply-To: <20200206092521.GM10400@smile.fi.intel.com>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu, 6 Feb 2020 10:31:39 -0800
Message-ID: <CAKdAkRS3enZEva4Q6w+Dm52S3QW8qmdzgTRqiw_WqyWUzr3k4A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation of
 ACPI GPIO numbers
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Michal Stanek <mst@semihalf.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, stanekm@google.com,
        "3.8+" <stable@vger.kernel.org>, mw@semihalf.com,
        Alex Levin <levinale@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 6, 2020 at 1:45 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Wed, Feb 05, 2020 at 08:48:04PM +0100, Michal Stanek wrote:
> > Dropping custom Linux GPIO translation caused some Intel_Strago based Chromebooks
> > with old firmware to detect GPIOs incorrectly. Add quirk which restores some code removed by
> > commit 03c4749dd6c7ff94 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation").
>
> And on top what Mika asked already, is it a real problem to update firmware?

Even if we qualify new firmware (which is an involved process) how do
you communicate to users that are not running Chrome OS that they need
to update firmware? So no, we have to work around issues in existing
firmware even if there is newer one that might address the issue.

Thanks.

--
Dmitry
