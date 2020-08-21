Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB2924DF94
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgHUS3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 14:29:17 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:47008 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgHUS2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 14:28:19 -0400
Received: by mail-oi1-f193.google.com with SMTP id v13so2292587oiv.13;
        Fri, 21 Aug 2020 11:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rrbEBmcM/knK8k8TI6aBXuX0Dz97eQ0LcBffz+HMJ5Y=;
        b=QxJy92uRKnoR/QeQ+PhCUcynn3LCSvCGe7q9SUBwrnJ9UwtPHRYuXXIKa0b5ev+D1E
         jUXihwl1j8PEPEXcN20INlkH7XskfW7Lcic4kWxjyJ/EcK6A/pTDdXGU5RT2EiWt+6Zu
         Pq2txkGWzH3BN3uNJLl9KnU4ek362EKPD1y7d0vtDU/o66T9nM+0DcSmNhl4rp63vWo3
         QqO1eZhXVqHCbO7/NIZd8lW4DYJMp8mZgOtSg5Em9fViEYY/cN7uD+gyWDNoWYb7tutf
         m0squv7GhGenvazqC8qx1BT+SxThCEuD0T1vltXiQnM1qwMJw16Z1efhs/ih8xEZCXvJ
         3mow==
X-Gm-Message-State: AOAM532moCVDWBg4aPTMjGuvaXK7gTIw3lXaFnl0qhDB+Nzo+0xXw2Cl
        D9Z30ESbX/BmEI8wReNJTaPQ8J6hk3abFsm7r6ccvULV
X-Google-Smtp-Source: ABdhPJzNKD2ZAZ7mB6yq80T33UhaP85YEULyCQSgdRa/syBBH5JoPLZWFZe6IQ1DSoqX3Pw9f423tkgsOSvAQ2udgVQ=
X-Received: by 2002:a54:4f14:: with SMTP id e20mr2701389oiy.103.1598034498198;
 Fri, 21 Aug 2020 11:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200821105342.32368-1-heikki.krogerus@linux.intel.com>
In-Reply-To: <20200821105342.32368-1-heikki.krogerus@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 21 Aug 2020 20:28:07 +0200
Message-ID: <CAJZ5v0gfX4hqa7RREQX0+=CNCs=pt7bq1AZEMZwRAAzZfGbVsA@mail.gmail.com>
Subject: Re: [PATCH] device property: Fix the secondary firmware node handling
 in set_primary_fwnode()
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 12:53 PM Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
>
> When the primary firmware node pointer is removed from a
> device (set to NULL) the secondary firmware node pointer,
> when it exists, is made the primary node for the device.
> However, the secondary firmware node pointer of the original
> primary firmware node is never cleared (set to NULL).
>
> To avoid situation where the secondary firmware node pointer
> is pointing to a non-existing object, clearing it properly
> when the primary node is removed from a device in
> set_primary_fwnode().
>
> Fixes: 97badf873ab6 ("device property: Make it possible to use secondary firmware nodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/base/core.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index ac1046a382bc0..f6f620aa94086 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4264,9 +4264,9 @@ static inline bool fwnode_is_primary(struct fwnode_handle *fwnode)
>   */
>  void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
>  {
> -       if (fwnode) {
> -               struct fwnode_handle *fn = dev->fwnode;
> +       struct fwnode_handle *fn = dev->fwnode;
>
> +       if (fwnode) {
>                 if (fwnode_is_primary(fn))
>                         fn = fn->secondary;
>
> @@ -4276,8 +4276,12 @@ void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
>                 }
>                 dev->fwnode = fwnode;
>         } else {
> -               dev->fwnode = fwnode_is_primary(dev->fwnode) ?
> -                       dev->fwnode->secondary : NULL;
> +               if (fwnode_is_primary(fn)) {
> +                       dev->fwnode = fn->secondary;
> +                       fn->secondary = NULL;
> +               } else {
> +                       dev->fwnode = NULL;
> +               }
>         }
>  }
>  EXPORT_SYMBOL_GPL(set_primary_fwnode);
> --

Applied as 5.9-rc material, thanks!
