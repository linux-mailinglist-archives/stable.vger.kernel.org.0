Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F815485B1A
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 22:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiAEVw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 16:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244600AbiAEVwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 16:52:11 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72401C061212;
        Wed,  5 Jan 2022 13:52:10 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b13so1827078edd.8;
        Wed, 05 Jan 2022 13:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjB/Zn0uKKBu8yfN2dleBmwCa7tAycjeqrCCen9R2Cw=;
        b=b/qmShWmOlCqy6QMXlTvASUJddaI5zI/6aasF937ZZK8GAZfDjfsdL6yKNyEt6/RkH
         iJlxLpLLr5Q+SwswJnZp9Z6Kf6ZkDR6HLcoVuW729au4Rsd/9u/IxAicbiYz/LZgz79L
         GdS6DjbKZFWX9APSwNY2L6Xwcv6bLRLPwnbKS3AyZSMel4MOgl00C3E8ylvqFJBIwfiO
         Kc6dXVU/6CbfFG0TsMc1hAm5eAaOj5h0Jiy7pDA628SPqrFPjg+WyCiGwEpJKmiaEU9B
         KRIeAPI+FaOTMyZfdiSwMtbT4GpNaelDJVcz4qOt2Fx+3O97Y08gm2DkeYlXIwxFJmgW
         sITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjB/Zn0uKKBu8yfN2dleBmwCa7tAycjeqrCCen9R2Cw=;
        b=OG0bSNEQulyCdqrsvH8M+YmrIg6IRmBf417XPVEagVUICTt57pM6BWrO6ueUFP82AS
         43Zl5HdsRYKdKRgRET8Prqq1qqfoFdJOmJ4hOvY6Mt8fDn+KsCUpOw7jgkIK+KrOZLD5
         7cQ36cQhWef/8PiuIguB+o/ZAf6cues+9ktfLXV2rWU0+ol1zf5HViwaXHDhjD2N5O5i
         LGdJVmMBHiuvD+Pg9kep/zXEarLu7OA5rXj6ThR8WCfBX/p5kqgciIG0kRyYPJ65dxOO
         +gjSpVtGOqvcKohxb0NPjl6/cDmIJAhG4FCdAN0voSqqwsjWozCxZkoWXHl7b2A3GgIv
         2Isg==
X-Gm-Message-State: AOAM531LwlVfTKm9vap//IVypWOP2ClzfmpVkifISNO6eivOtWB2RrhD
        a1XCMwCK3LTZuxK3Atv7+1pUtmmDbG1WEhylCg0=
X-Google-Smtp-Source: ABdhPJwLfQRw8pC3JV+6Qx5qoGjNdZEjOwnd3EUlmiwp8FgXYbFvx6A04tcHF77/pjpG2dpE3fekXYJMyL5ND9OZCyI=
X-Received: by 2002:a50:d710:: with SMTP id t16mr55428708edi.50.1641419528997;
 Wed, 05 Jan 2022 13:52:08 -0800 (PST)
MIME-Version: 1.0
References: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com> <1641368602-20401-6-git-send-email-hongxing.zhu@nxp.com>
In-Reply-To: <1641368602-20401-6-git-send-email-hongxing.zhu@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 5 Jan 2022 18:51:58 -0300
Message-ID: <CAOMZO5AqgOOo3+r3yQSsfaNxW9eHXhCi=m+mqR=sf=K6dXA8tw@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] PCI: imx6: Fix the regulator dump when link never
 came up
To:     Richard Zhu <hongxing.zhu@nxp.com>
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Brown <broonie@kernel.org>, lorenzo.pieralisi@arm.com,
        jingoohan1@gmail.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Richard,

On Wed, Jan 5, 2022 at 5:12 AM Richard Zhu <hongxing.zhu@nxp.com> wrote:
>
> When PCIe PHY link never came up and vpcie regulator is present, there
> would be following dump when try to put the regulator.
> Add a new host_exit() callback for i.MX PCIe driver to disable this
> regulator and fix this dump when link never came up.
>
> The driver should undo any enables it did itself, and not undo any
> enables that anything else did which means it should never be basing
> decisions on regulator_is_enabled().
>
> To keep usage counter balance of the clocks, powers and so on. Do the
> clock disable in the error handling after host_init too.
>
>   imx6q-pcie 33800000.pcie: Phy link never came up
>   imx6q-pcie: probe of 33800000.pcie failed with error -110

Shouldn't we ignore the dw_pcie_wait_for_link() error?

At least, this was the intention of 886a9c134755 ("PCI: dwc: Move link
handling into
common code").

>   ------------[ cut here ]------------
>   WARNING: CPU: 3 PID: 119 at drivers/regulator/core.c:2256 _regulator_put.part.0+0x14c/0x158
>   Modules linked in:

My concern is that this issue is still present in 5.15, which is LTS.

You only address this problem in 5/6 and I am not sure if the previous
patches could be applied to stable as they are cleanups.

How can we fix this for 5.15 stable?

Could you make a minimal fix as the first patch of the series and
cleanup patches later?
