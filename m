Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0F521733
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 12:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfEQKrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 06:47:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42941 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbfEQKrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 06:47:19 -0400
Received: by mail-lf1-f66.google.com with SMTP id y13so4972444lfh.9;
        Fri, 17 May 2019 03:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ku+cJ0KGPggfXsWsOEHqzdK2uKS13WYhdMXnkwa2J94=;
        b=YGWxc2NYkRjVCyVbQ1/3Kdezha005MkUtmDXwU3Dnn66C729JPxJ5OvZuYRVpCUFLQ
         KI/g4RjNq9uklOniZJlfGCrkHS6f7BQowB7XoHbyskPrUjX0322lL4+aTWQYJ58goKjC
         Nr8MEiMJgf1uRPnhX2KIVgij8d4p4vWRG2K9znhvAsxnCpJRLpKrFqTRMRtJPKPose6i
         8e6Ebfc7YHlS+BhHuTdAlgIhCSANHprdYIW29we064YDbWX5agWqW7MV99e5EwGERmeE
         kwdvEmsqol/i7mS05ECUsNyxXxOFpD2NR/JDj3vMIQodyzu1KyCNMyn2Ufc0ZcKM/WRd
         nDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ku+cJ0KGPggfXsWsOEHqzdK2uKS13WYhdMXnkwa2J94=;
        b=qM1WowCnZ7dMh/eaMrnYH4kZEYjLCZkGVUiYgHkpDEsqgG4ypokeS4LtcmP1Oo88eQ
         HGOzffGUa/vux1e+f/MpuIfWkyVlJa9DduooxxmaptstfVZKFqFDang5aGS0p7thE6MY
         QEVz4F+4FkyuZckhWjpfLsbL/wISNKIGQ5sdOEc/dFm5ZMtjz5/zXY7i4qYpsDGIEN38
         2vavsoe4UrHKBOH5tPKLwlPr0OVCR106thj92BeC4mFvJ5VcDiwv/3texIPgs3fkkwc/
         GeGroI8pgkFi2m6mjo6QUmvKwWvFzjxUdz818QgtBdaXL5Wv2ZlDFbBSmhee0FLAg3U6
         nryQ==
X-Gm-Message-State: APjAAAVsbps/B9X4VQOqZ7sr8MQmLRh46ckjs+mutsasOvSEhGiUoYSM
        5nIk947xnUIbSFJmZNRVNvhqxChA8/8DGDXJR1o=
X-Google-Smtp-Source: APXvYqxZ2MG2AQvc33D8SCatH+kfTvr7StGGJTsiwIzC3IiePbUuBCM66Lyp5YEs5ptkeASOwJL4u708VtTLT1yA9fA=
X-Received: by 2002:a19:c60f:: with SMTP id w15mr27524114lff.61.1558090037048;
 Fri, 17 May 2019 03:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190517074039.22614-1-peng.fan@nxp.com>
In-Reply-To: <20190517074039.22614-1-peng.fan@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 17 May 2019 07:47:08 -0300
Message-ID: <CAOMZO5CobB6oSKc9SY3LLdLc9+ZkfiZyYXyCQa5yR-Wwnv0OCQ@mail.gmail.com>
Subject: Re: [PATCH V2] clk: imx: imx8mm: fix int pll clk gate
To:     Peng Fan <peng.fan@nxp.com>
Cc:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 4:27 AM Peng Fan <peng.fan@nxp.com> wrote:
>
> Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for imx8mm")
> To Frac pll, the gate shift is 13, however to Int PLL the gate shift
> is 11.
>
> Cc: <stable@vger.kernel.org>

The Fixes tag should go here instead.

> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Reviewed-by: Jacky Bai <ping.bai@nxp.com>
