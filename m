Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9110C2E7
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 04:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfK1Dkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 22:40:41 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:33634 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfK1Dkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 22:40:41 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xAS3eOPY017112; Thu, 28 Nov 2019 12:40:24 +0900
X-Iguazu-Qid: 34trMIO5KQvAymG4rS
X-Iguazu-QSIG: v=2; s=0; t=1574912423; q=34trMIO5KQvAymG4rS; m=2JADXTo0a0DwfWBCaayqVuS6YitGzMqN7fwhpDEKbUg=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1511) id xAS3eMrq024465;
        Thu, 28 Nov 2019 12:40:23 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xAS3eMMo015989;
        Thu, 28 Nov 2019 12:40:22 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xAS3eLkL032028;
        Thu, 28 Nov 2019 12:40:22 +0900
Date:   Thu, 28 Nov 2019 12:40:20 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 216/220] PM / devfreq: Fix static checker warning in
 try_then_request_governor
X-TSB-HOP: ON
Message-ID: <20191128034020.necma5gpnf2wgsm4@toshiba.co.jp>
References: <20191122100912.732983531@linuxfoundation.org>
 <20191122100929.173069944@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122100929.173069944@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Nov 22, 2019 at 11:29:41AM +0100, Greg Kroah-Hartman wrote:
> From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> 
> [ Upstream commit b53b0128052ffd687797d5f4deeb76327e7b5711 ]
> 
> The patch 23c7b54ca1cd: "PM / devfreq: Fix devfreq_add_device() when
> drivers are built as modules." leads to the following static checker
> warning:
> 
>     drivers/devfreq/devfreq.c:1043 governor_store()
>     warn: 'governor' can also be NULL
> 
> The reason is that the try_then_request_governor() function returns both
> error pointers and NULL. It should just return error pointers, so fix
> this by returning a ERR_PTR to the error intead of returning NULL.
> 
> Fixes: 23c7b54ca1cd ("PM / devfreq: Fix devfreq_add_device() when drivers are built as modules.")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The following commits are provided for this fix:

commit 7544fd7f384591038646d3cd9efb311ab4509e24
Author: Ezequiel Garcia <ezequiel@collabora.com>
Date:   Fri Jun 21 18:39:49 2019 -0300

    PM / devfreq: Fix kernel oops on governor module load

    A bit unexpectedly (but still documented), request_module may
    return a positive value, in case of a modprobe error.
    This is currently causing issues in the devfreq framework.

    When a request_module exits with a positive value, we currently
    return that via ERR_PTR. However, because the value is positive,
    it's not a ERR_VALUE proper, and is therefore treated as a
    valid struct devfreq_governor pointer, leading to a kernel oops.

    Fix this by returning -EINVAL if request_module returns a positive
    value.

    Fixes: b53b0128052ff ("PM / devfreq: Fix static checker warning in try_then_request_governor")
    Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
    Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
    Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Please apply.

Best regards,
  Nobuhiro
