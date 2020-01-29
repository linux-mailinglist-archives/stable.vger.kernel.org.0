Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C577414D1D2
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 21:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgA2UUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 15:20:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37600 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgA2UT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 15:19:59 -0500
Received: by mail-lj1-f195.google.com with SMTP id v17so804373ljg.4;
        Wed, 29 Jan 2020 12:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBAvgEILNC/DpIEeIO9O9bZop1LPit11TI5TK6r2sd0=;
        b=f6HglhEYBtGlI+1MJLA1H4Vfw050nUY3c/mP1sFKr8Wb9XRxK7dw1/gnSfQDg06rRT
         0t8ti8HFq9tZ3Jx3f/U1S+AUYfBV98K2Vf5Tjm9hW+c23UxJNS76DfzgOyoNHuvGx+zN
         sXZWQY857pdIbKJ3bDqFr7UmhBFUETm66k9viw7YDkQ7/BuPNp+720SCEP1STs2CDdko
         Ubjko+gAGEcIcIKdQdA3I6wNiIpQPIq/tdqPgKS03xo+OvvCVKoEETeJEHbByswy7sid
         mK/nuxs14s0PqRbndIF4OxzPgDBL8JMwoqSQpFOLGhlaz/k0PLpe9/UAWs48Rq3olRho
         dzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBAvgEILNC/DpIEeIO9O9bZop1LPit11TI5TK6r2sd0=;
        b=bHhIm1111hndF0w9rruS6EnEivohnUZvTeCSxsD8zwZwSNgLhW6BQto0MaiQ8byycr
         iHSUkSDGIBogOz8ZHCsa2+Jyf2bMD/y6oih/lsiXG+yxg4BOxaGqPlkq1zAWuPqWItEQ
         kY/TrNPVvGV6/DUciY0iHmGaqrDU/6ez+HgaaKsCrWjlC3Q9efcJKKuLAol/iybaLX0+
         Rql1ObyB1LbTNIej7aLRAK0f0mcCYB/iO+q1pff9+L2BbRzK71vAzZxSSrLfvXFeN57K
         wKYpLGNGm/vjWv2NbwdIg5Ny8hjY5/vz0mj6komZCB/rRr+UmA/uh6ERV7D5vIiDpcIx
         5Pcw==
X-Gm-Message-State: APjAAAXUWBg2U7dvXmC06qGW9bCKCW4NCydF7ya+RhUtfCZ8zkO4ML6i
        g8ixfSPGUsytqJK6JLcnKnifNiQwYXSXm+zoJ1U=
X-Google-Smtp-Source: APXvYqzuA9WbX+X2q0ILY1NfmpmvLlSyBrUHhpaWuevXJtsv/YP7zNE3FxI6k3UU76WiAjiLa4NEUjWGR9uylY0tU6c=
X-Received: by 2002:a2e:5056:: with SMTP id v22mr557613ljd.164.1580329196994;
 Wed, 29 Jan 2020 12:19:56 -0800 (PST)
MIME-Version: 1.0
References: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1580305274-27274-1-git-send-email-martin.fuzzey@flowbird.group>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 29 Jan 2020 17:19:45 -0300
Message-ID: <CAOMZO5AFJvEdWNSsnsRW70_M6rzyvO4ip3zJHET2Gc2Wzj5RPQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: imx-sdma: fix context cache
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc:     dmaengine@vger.kernel.org, stable <stable@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Martin,

Thanks for the fix.

On Wed, Jan 29, 2020 at 10:41 AM Martin Fuzzey
<martin.fuzzey@flowbird.group> wrote:
>
> There is a DMA problem with the serial ports on i.MX6.
>
> When the following sequence is performed:
>
> 1) Open a port
> 2) Write some data
> 3) Close the port
> 4) Open a *different* port
> 5) Write some data
> 6) Close the port
>
> The second write sends nothing and the second close hangs.
> If the first close() is omitted it works.
>
> Adding logs to the the UART driver shows that the DMA is being setup but
> the callback is never invoked for the second write.
>
> This used to work in 4.19.
>
> Git bisect leads to:
>         ad0d92d: "dmaengine: imx-sdma: refine to load context only once"
>
> This commit adds a "context_loaded" flag used to avoid unnecessary context
> setups.
> However the flag is only reset in sdma_channel_terminate_work(),
> which is only invoked in a worker triggered by sdma_terminate_all() IF
> there is an active descriptor.
>
> So, if no active descriptor remains when the channel is terminated, the
> flag is not reset and, when the channel is later reused the old context
> is used.
>
> Fix the problem by always resetting the flag in sdma_free_chan_resources().
>
> Fixes: ad0d92d: "dmaengine: imx-sdma: refine to load context only once"

Nit: in the Fixes tag we use 12 digits for the commit ID and the
Subject is enclosed by parenthesis.

The preferred format would be:

Fixes: ad0d92d7ba6a ("dmaengine: imx-sdma: refine to load context only once")

Reviewed-by: Fabio Estevam <festevam@gmail.com>

Thanks
