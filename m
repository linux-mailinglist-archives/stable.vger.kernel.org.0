Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0E8DC5F7
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 15:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410279AbfJRNZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 09:25:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35960 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfJRNZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 09:25:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id v24so6243744ljj.3;
        Fri, 18 Oct 2019 06:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lF1BtpGFJkCASpl5WSWPvr60tGpzDuIXmmIMMq39PQI=;
        b=rnmvCCNNWjE7wD3FgdVmW00kWt25xtwi4OglY6YgqfL4vRpG13U+cIvYKK4ki+hY81
         OASKWhDGIF6uHTu/t4KZvfIaeHC2965PeVcNmShf8ON0I9gbaFcRtb/QcYZAZu5KnYnj
         Gatt24gDlfNBbF04He18mskX5P2rU6kZOy1zbIX8pAz3kt1nB+6ogTCxuTBFKlsbA2/X
         gQSmM7mg7YTz1fuDsP16zZfuPOOCcT7bpU6BuX613QRHqhEKleE7u29NN8BLd/JLHrvm
         kh7XBbRXhFhWoHfqcMPw86u8OubxWPESpOyQFVF1eA6ZdWxWPxBcdfqgb5M7pPfRk8ys
         w4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lF1BtpGFJkCASpl5WSWPvr60tGpzDuIXmmIMMq39PQI=;
        b=tCGr8xeGftf+BHAaLK93J3VByaRoM0wELphdSKqWR2fEXgf+L8sPEzpJtepHHtit1G
         zBZrX6wD/dxyb9utzp02Jf+NJDChkjk/Sb6dfah+npfj72mKVnKBxR1ljmLHVpSrlTPR
         dddlB5kAWpHGOg4PvrelC740OOf6VvRRT9nUnmC+X02/TcRnHEFYFEkJ980yN75DmdxK
         zIEgnJExSg5UjQtnXYQ/amSKg337WIHJHCd3d0Xz+Y55XShNQB3aHlbSQLFz3vpkL9VY
         jCPRYr7oHeia4l70TX68apt7QjOpLYenSdCxjUiziQU6Xepsf2DGJsiE06yUFIOZJo/Z
         nu0g==
X-Gm-Message-State: APjAAAWD9rTlWDjkbJMhb4SZActqBc8zRWiqfvGvysdzbAP8TNw2fkWK
        aVgaFDfNVObo4Y7ca3b5rOq4lcuiGi8JkmiqWok=
X-Google-Smtp-Source: APXvYqxBWxZcbSmPnmp2TiOdZhdxUmFsCcBX+5WFJGNoV6aA5tYzjMdRq7eRtbqxUHM80PfUpkgNI/cW/JzO1C5ZYIA=
X-Received: by 2002:a2e:b4d5:: with SMTP id r21mr6084759ljm.149.1571405130323;
 Fri, 18 Oct 2019 06:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191018093934.29695-1-s.hauer@pengutronix.de>
In-Reply-To: <20191018093934.29695-1-s.hauer@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 18 Oct 2019 10:25:21 -0300
Message-ID: <CAOMZO5DUoj4xVZQSvk9Juw9z37UgrMn3g24h2_pAMxuTkBjw4g@mail.gmail.com>
Subject: Re: [PATCH] mmc: mxs: fix flags passed to dmaengine_prep_slave_sg
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sascha,

On Fri, Oct 18, 2019 at 6:39 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
> Since ceeeb99cd821 we no longer abuse the DMA_CTRL_ACK flag for custom
> driver use and introduced the MXS_DMA_CTRL_WAIT4END instead. We have not
> changed all users to this flag though. This patch fixes it for the
> mxs-mmc driver.

If I read this correctly, this patch is not the complete fix for all users.

Wouldn't it be better to revert the offending commit instead?
