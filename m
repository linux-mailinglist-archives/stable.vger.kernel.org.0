Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B14912232C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 05:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfLQEi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 23:38:27 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:37476 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLQEi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 23:38:27 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id xBH4cFR5010467; Tue, 17 Dec 2019 13:38:15 +0900
X-Iguazu-Qid: 34tMKo1JevEwTib89y
X-Iguazu-QSIG: v=2; s=0; t=1576557494; q=34tMKo1JevEwTib89y; m=R/+K17mdD/Vln+E9qkngc/OrgbDAB07oZZSVseeD9SY=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1511) id xBH4cERN039096;
        Tue, 17 Dec 2019 13:38:14 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBH4cDCh007642;
        Tue, 17 Dec 2019 13:38:14 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBH4cDUn017234;
        Tue, 17 Dec 2019 13:38:13 +0900
Date:   Tue, 17 Dec 2019 13:38:10 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Marcin Pawlowski <mpawlowski@fb.com>,
        "Williams, Gerald S" <gerald.s.williams@intel.com>
Subject: Re: [PATCH 4.19 053/140] workqueue: Fix spurious sanity check
 failures in destroy_workqueue()
X-TSB-HOP: ON
Message-ID: <20191217043810.xamko46u2g4sdkwp@toshiba.co.jp>
References: <20191216174747.111154704@linuxfoundation.org>
 <20191216174802.938835002@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174802.938835002@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:48:41PM +0100, Greg Kroah-Hartman wrote:
> From: Tejun Heo <tj@kernel.org>
> 
> commit def98c84b6cdf2eeea19ec5736e90e316df5206b upstream.
> 
> Before actually destrying a workqueue, destroy_workqueue() checks
> whether it's actually idle.  If it isn't, it prints out a bunch of
> warning messages and leaves the workqueue dangling.  It unfortunately
> has a couple issues.
> 
> * Mayday list queueing increments pwq's refcnts which gets detected as
>   busy and fails the sanity checks.  However, because mayday list
>   queueing is asynchronous, this condition can happen without any
>   actual work items left in the workqueue.
> 
> * Sanity check failure leaves the sysfs interface behind too which can
>   lead to init failure of newer instances of the workqueue.
> 
> This patch fixes the above two by
> 
> * If a workqueue has a rescuer, disable and kill the rescuer before
>   sanity checks.  Disabling and killing is guaranteed to flush the
>   existing mayday list.
> 
> * Remove sysfs interface before sanity checks.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Marcin Pawlowski <mpawlowski@fb.com>
> Reported-by: "Williams, Gerald S" <gerald.s.williams@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

This commit also requires the following commit:

commit 8efe1223d73c218ce7e8b2e0e9aadb974b582d7f
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Sep 20 13:39:57 2019 -0700

    workqueue: Fix missing kfree(rescuer) in destroy_workqueue()

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Qian Cai <cai@lca.pw>
    Fixes: def98c84b6cd ("workqueue: Fix spurious sanity check failures in destroy_workqueue()")

This is also required to 4.4, 4.9, 4.14 and 5.3.

Best regards,
  Nobuhiro
