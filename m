Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26CC122323
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 05:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLQE2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 23:28:47 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:58742 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfLQE2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 23:28:47 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xBH4SbUr031223; Tue, 17 Dec 2019 13:28:37 +0900
X-Iguazu-Qid: 34tMW239pyFjTEImBk
X-Iguazu-QSIG: v=2; s=0; t=1576556917; q=34tMW239pyFjTEImBk; m=xvkk2ILyQf2Wk8qjQeD3kZv9hP1nl1f2dieNnZRzlS0=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id xBH4SZdR023261;
        Tue, 17 Dec 2019 13:28:36 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xBH4SZ6C022042;
        Tue, 17 Dec 2019 13:28:35 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xBH4SZso023846;
        Tue, 17 Dec 2019 13:28:35 +0900
Date:   Tue, 17 Dec 2019 13:28:29 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.14 204/267] blk-mq: avoid sysfs buffer overflow with
 too many CPU cores
X-TSB-HOP: ON
Message-ID: <20191217042829.x3n4h4yiuogklmym@toshiba.co.jp>
References: <20191216174848.701533383@linuxfoundation.org>
 <20191216174913.713799376@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174913.713799376@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:48:50PM +0100, Greg Kroah-Hartman wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> commit 8962842ca5abdcf98e22ab3b2b45a103f0408b95 upstream.
> 
> It is reported that sysfs buffer overflow can be triggered if the system
> has too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs of
> hctx via /sys/block/$DEV/mq/$N/cpu_list.
> 
> Use snprintf to avoid the potential buffer overflow.
> 
> This version doesn't change the attribute format, and simply stops
> showing CPU numbers if the buffer is going to overflow.
> 
> Cc: stable@vger.kernel.org
> Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

This commit also required following commit:

commit d2c9be89f8ebe7ebcc97676ac40f8dec1cf9b43a
Author: Ming Lei <ming.lei@redhat.com>
Date:   Mon Nov 4 16:26:53 2019 +0800

    blk-mq: make sure that line break can be printed

    8962842ca5ab ("blk-mq: avoid sysfs buffer overflow with too many CPU cores")
    avoids sysfs buffer overflow, and reserves one character for line break.
    However, the last snprintf() doesn't get correct 'size' parameter passed
    in, so fixed it.

    Fixes: 8962842ca5ab ("blk-mq: avoid sysfs buffer overflow with too many CPU cores")
    Signed-off-by: Ming Lei <ming.lei@redhat.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>


And this is also required for 4.4, 4.9 and 4.19.
Please apply.

Best regards,
  Nobuhiro
