Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED68E7DC5
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 02:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfJ2BJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 21:09:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45478 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfJ2BJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 21:09:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id y7so9395298edo.12;
        Mon, 28 Oct 2019 18:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0lphBL/5v2KmmoeRZ37w1s/D6Nv6IFE2uro0ev3xsvE=;
        b=jmQ7066HvOFeurUklvPjx05bSGn5LrGoSp3d0fJT4l+3AGxT8XLbStPkMu3b9g3exb
         j2+uTGePFYBt83TwsuKDfZ+BadB5ZgnrRF/vvopl2Kap6fSa9YMvhU+xX+DsABfuqZMf
         8zgNJ2MbbU+I7Cwgg1w0ZLR32IXBK2Q3Ry3LH5m6OnR8VGObUM4oLSYusyhzXAvRrxqY
         g7zN5RRzJ2VE7FZoEOej/QYuwV2DcQmsl5p4rBPkhtweSAXOfu83qil5KYlH7kOVZ+Qm
         +Fx92sXsPfi6nmh7Gc7KJIDcsHcffd+D6bnHJnOhyg4vTZ6KfYKB1gB1HmbNNxB+ftls
         WliA==
X-Gm-Message-State: APjAAAUnKhdNOSHUzJ93x/TNWWDZ2lgjarRp2IASmEUuucjnLM1be817
        detPx3caigolK2JvAjkcmxCCiDVwKvc=
X-Google-Smtp-Source: APXvYqxF9jxqghWtxD7VhiB6mn7H6YpYO7npwISe0WygREvp0q2HVM9SKQSsFy/YExKcUhn84XwMFg==
X-Received: by 2002:a17:906:c836:: with SMTP id dd22mr787346ejb.178.1572311389983;
        Mon, 28 Oct 2019 18:09:49 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id s20sm583170edq.44.2019.10.28.18.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 18:09:49 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id n15so11773212wrw.13;
        Mon, 28 Oct 2019 18:09:49 -0700 (PDT)
X-Received: by 2002:a05:6000:1252:: with SMTP id j18mr16938815wrx.23.1572311389338;
 Mon, 28 Oct 2019 18:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191028214914.3465156-1-megous@megous.com>
In-Reply-To: <20191028214914.3465156-1-megous@megous.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Tue, 29 Oct 2019 09:09:40 +0800
X-Gmail-Original-Message-ID: <CAGb2v67Vy=tD4dfSXD+=HS3B2tEE-bH2D++gx9Oa=P8n-012ew@mail.gmail.com>
Message-ID: <CAGb2v67Vy=tD4dfSXD+=HS3B2tEE-bH2D++gx9Oa=P8n-012ew@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH] ARM: sunxi: Fix CPU powerdown on A83T
To:     =?UTF-8?Q?Ond=C5=99ej_Jirman?= <megous@megous.com>
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 5:49 AM Ondrej Jirman <megous@megous.com> wrote:
>
> PRCM_PWROFF_GATING_REG has CPU0 at bit 4 on A83T. So without this
> patch, instead of gating the CPU0, the whole cluster was power gated,
> when shutting down first CPU in the cluster.
>
> Fixes: 6961275e72a8c1 ("ARM: sun8i: smp: Add support for A83T")
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> Cc: stable@vger.kernel.org

Acked-by: Chen-Yu Tsai <wens@csie.org>

Though I distinctly remember the BSP had some code dealing with chip
revisions in which the two bits were reversed. :(
