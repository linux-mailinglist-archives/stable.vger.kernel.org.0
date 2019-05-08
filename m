Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8658516E12
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEHAKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 20:10:40 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:59904 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEHAKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 20:10:40 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id x480AQ18030660; Wed, 8 May 2019 09:10:26 +0900
X-Iguazu-Qid: 34trPHnJtp4SJX7ZnU
X-Iguazu-QSIG: v=2; s=0; t=1557274226; q=34trPHnJtp4SJX7ZnU; m=GRuQWOFM8kgwiNxmUcKBoJxO6dGlsBq0CmDxg/ZAAZQ=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id x480AOWn008974;
        Wed, 8 May 2019 09:10:25 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id x480AOFV029282;
        Wed, 8 May 2019 09:10:24 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id x480AOm7022147;
        Wed, 8 May 2019 09:10:24 +0900
Date:   Wed, 8 May 2019 09:10:14 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 38/99] net: stmmac: use correct DMA buffer size in
 the RX descriptor
X-TSB-HOP: ON
Message-ID: <20190508001014.hlemsaqvir3umv2i@toshiba.co.jp>
References: <20190506143053.899356316@linuxfoundation.org>
 <20190506143057.399914447@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506143057.399914447@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, May 06, 2019 at 04:32:11PM +0200, Greg Kroah-Hartman wrote:
> [ Upstream commit 583e6361414903c5206258a30e5bd88cb03c0254 ]
> 
> We always program the maximum DMA buffer size into the receive descriptor,
> although the allocated size may be less. E.g. with the default MTU size
> we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> memory may get corrupted.
> 
> Fix by using exact buffer sizes.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../net/ethernet/stmicro/stmmac/descs_com.h   | 22 ++++++++++++-------
>  .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  2 +-
>  .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |  2 +-
>  .../net/ethernet/stmicro/stmmac/enh_desc.c    | 10 ++++++---
>  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  2 +-
>  .../net/ethernet/stmicro/stmmac/norm_desc.c   | 10 ++++++---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++--

This commit is incomplete and we need the following commit:

commit f87db4dbd52f2f8a170a2b51cb0926221ca7c9e2
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Wed Apr 17 09:49:39 2019 +0800

    net: stmmac: Use bfsize1 in ndesc_init_rx_desc

    gcc warn this:

    drivers/net/ethernet/stmicro/stmmac/norm_desc.c: In function ndesc_init_rx_desc:
    drivers/net/ethernet/stmicro/stmmac/norm_desc.c:138:6: warning: variable 'bfsize1' set but not used [-Wunused-but-set-variable]

    Like enh_desc_init_rx_desc, we should use bfsize1
    in ndesc_init_rx_desc to calculate 'p->des1'

    Fixes: 583e63614149 ("net: stmmac: use correct DMA buffer size in the RX descriptor")
    Signed-off-by: YueHaibing <yuehaibing@huawei.com>
    Reviewed-by: Aaro Koskinen <aaro.koskinen@nokia.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

And this fix is also needed for 5.0.14-rc.
Please apply this commit to 4.19.y-rc and 5.0.y-rc.

Best regards,
  Nobuhiro
