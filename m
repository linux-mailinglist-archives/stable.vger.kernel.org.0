Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31736BACC
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 22:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhDZUnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 16:43:12 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:19764 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233971AbhDZUnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 16:43:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619469750; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=vOHO8cz5mRXLMj1d0Yn2sPy4MHZ3C4usEDqWxFA7sTQ=; b=mRmgsqtY+gF5Crt390j1JObGTkWBEqE8HAF0BxB4l4FoXvISwDbVXOnXmODY3G6zCDpcHzmL
 xyVYUioHbdUYXIfAYdRWlsnoi7cH08LRCNRwsKHHsqTKoVTo03lhg/N4PsAVdp1Q6NySawHS
 LcTj2r7xHuUATpj44l1lFLZaAyM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 608725a9215b831afbdfc056 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Apr 2021 20:42:17
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EDF50C43460; Mon, 26 Apr 2021 20:42:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CD81C433D3;
        Mon, 26 Apr 2021 20:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CD81C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jackp@codeaurora.org
Date:   Mon, 26 Apr 2021 13:42:13 -0700
From:   Jack Pham <jackp@codeaurora.org>
To:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Cc:     abhilash.k.v@intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: ucsi: Retrieve all the PDOs instead of just
 the first 4
Message-ID: <20210426204213.GC20698@jackp-linux.qualcomm.com>
References: <20210426192605.GB20698@jackp-linux.qualcomm.com>
 <1619468491-22053-1-git-send-email-subbaram@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619468491-22053-1-git-send-email-subbaram@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 01:21:31PM -0700, Subbaraman Narayanamurthy wrote:
> > If such a source is connected it's possible the UCSI FW could have
> 
> s/UCSI FW/PPM

Right, PPM is a more apt descriptor. Waiting to see if Heikki has any
feedback first before sending a V2.

> > We can resolve this by instead retrieving and storing up to the
> > maximum of 7 PDOs in the con->src_pdos array. This would involve
> > two calls to the GET_PDOS command.
> > 
> 
> This issue (see the signature below) is found by enabling UBSAN and
> connecting a charger adapter that can advertise 5 PDOs and RPDO selected
> by PPM is 5.
> 
> [  151.545106][   T70] Unexpected kernel BRK exception at EL1
> [  151.545112][   T70] Internal error: BRK handler: f2005512 [#1] PREEMPT SMP
> ...
> [  151.545499][   T70] pc : ucsi_psy_get_prop+0x208/0x20c
> [  151.545507][   T70] lr : power_supply_show_property+0xc0/0x328
> ...
> [  151.545542][   T70] Call trace:
> [  151.545544][   T70]  ucsi_psy_get_prop+0x208/0x20c
> [  151.545546][   T70]  power_supply_uevent+0x1a4/0x2f0
> [  151.545550][   T70]  dev_uevent+0x200/0x384
> [  151.545555][   T70]  kobject_uevent_env+0x1d4/0x7e8
> [  151.545557][   T70]  power_supply_changed_work+0x174/0x31c
> [  151.545562][   T70]  process_one_work+0x244/0x6f0
> [  151.545564][   T70]  worker_thread+0x3e0/0xa64

UBSAN FTW. Want me to copy this trace into the commit text as well?

Jack
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
