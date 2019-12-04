Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7630A1122AD
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 06:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfLDF5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 00:57:52 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:51566 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfLDF5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 00:57:52 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id xB45vfEV000828; Wed, 4 Dec 2019 14:57:41 +0900
X-Iguazu-Qid: 34trMIO5KbHSsEZMoA
X-Iguazu-QSIG: v=2; s=0; t=1575439061; q=34trMIO5KbHSsEZMoA; m=V2vpPc3Sm8twmhncTu+7E1ruTxjV6fReYAEGcFjdpzc=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id xB45veRP011189;
        Wed, 4 Dec 2019 14:57:40 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xB45vecE019581;
        Wed, 4 Dec 2019 14:57:40 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xB45vdwX011619;
        Wed, 4 Dec 2019 14:57:40 +0900
Date:   Wed, 4 Dec 2019 14:57:38 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 024/321] net: fec: add missed clk_disable_unprepare
 in remove
X-TSB-HOP: ON
Message-ID: <20191204055738.nl5db2xtigoamtbk@toshiba.co.jp>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223428.376628375@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203223428.376628375@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Dec 03, 2019 at 11:31:30PM +0100, Greg Kroah-Hartman wrote:
> From: Chuhong Yuan <hslester96@gmail.com>
> 
> [ Upstream commit c43eab3eddb4c6742ac20138659a9b701822b274 ]
> 
> This driver forgets to disable and unprepare clks when remove.
> Add calls to clk_disable_unprepare to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


This commit also requires the following commit:

commit a31eda65ba210741b598044d045480494d0ed52a
Author: Chuhong Yuan <hslester96@gmail.com>
Date:   Wed Nov 20 09:25:13 2019 +0800

    net: fec: fix clock count mis-match

    pm_runtime_put_autosuspend in probe will call runtime suspend to
    disable clks automatically if CONFIG_PM is defined. (If CONFIG_PM
    is not defined, its implementation will be empty, then runtime
    suspend will not be called.)

    Therefore, we can call pm_runtime_get_sync to runtime resume it
    first to enable clks, which matches the runtime suspend. (Only when
    CONFIG_PM is defined, otherwise pm_runtime_get_sync will also be
    empty, then runtime resume will not be called.)

    Then it is fine to disable clks without causing clock count mis-match.

    Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
    Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
    Acked-by: Fugang Duan <fugang.duan@nxp.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


And this should also apply to 5.3.

Best regards,
  Nobuhiro
