Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE99D10317B
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 03:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfKTCSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 21:18:42 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:42070 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKTCSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 21:18:42 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xAK2IWma031090; Wed, 20 Nov 2019 11:18:32 +0900
X-Iguazu-Qid: 34tri0Mt082SogzPLH
X-Iguazu-QSIG: v=2; s=0; t=1574216312; q=34tri0Mt082SogzPLH; m=luvDoeALb1HlBxIQtq0OD8ulvd3UP5QOufXziv5U2MI=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1511) id xAK2IVhk028623;
        Wed, 20 Nov 2019 11:18:31 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xAK2IVXi029867;
        Wed, 20 Nov 2019 11:18:31 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xAK2IVag029743;
        Wed, 20 Nov 2019 11:18:31 +0900
Date:   Wed, 20 Nov 2019 11:18:28 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 034/422] tee: optee: take DT status property into
 account
X-TSB-HOP: ON
Message-ID: <20191120021828.hwtwxfby3myn7mnh@toshiba.co.jp>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051402.211777274@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119051402.211777274@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Nov 19, 2019 at 06:13:51AM +0100, Greg Kroah-Hartman wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> [ Upstream commit db878f76b9ff7487da9bb0f686153f81829f1230 ]
> 
> DT nodes may have a 'status' property which, if set to anything other
> than 'ok' or 'okay', indicates to the OS that the DT node should be
> treated as if it was not present. So add that missing logic to the
> OP-TEE driver.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch requires the following additional commit:

commit c7c0d8df0b94a67377555a550b8d66ee2ad2f4ed
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Sat Feb 23 14:20:36 2019 +0100

    tee: optee: add missing of_node_put after of_device_is_available

    Add an of_node_put when a tested device node is not available.

    The semantic patch that fixes this problem is as follows
    (http://coccinelle.lip6.fr):

    // <smpl>
    @@
    identifier f;
    local idexpression e;
    expression x;
    @@

    e = f(...);
    ... when != of_node_put(e)
        when != x = e
        when != e = x
        when any
    if (<+...of_device_is_available(e)...+>) {
      ... when != of_node_put(e)
    (
      return e;
    |
    + of_node_put(e);
      return ...;
    )
    }
    // </smpl>

    Fixes: db878f76b9ff ("tee: optee: take DT status property into account")
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>

Please apply this commit. And this is also required for 4.14.y.

Best regards,
  Nobuhiro
