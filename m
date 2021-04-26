Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7510736BAA3
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 22:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbhDZUWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 16:22:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:40266 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238112AbhDZUWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 16:22:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619468518; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=3LGFtiTRJjNMYbJ6EUUyU7V1Qj7k6TQXUxK2E6mPlFU=; b=vBX84bpXvjAjnxTAOJymBDr0lbcemn36Tx+H7wEbJ0e6UqcJ4JSxH0WONSYGD59nvkTTcasj
 8HsjpgFw4x3OoZJ/O2F1spYgesgk8zr7HUwrYQFKitcjd8t7EpVOLx9L7FhnJ7QktnQIJIJr
 wIeWEYTZFC7dxriPSLYCi9ZKx6U=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 608720d4f34440a9d4d63ffd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Apr 2021 20:21:40
 GMT
Sender: subbaram=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E43BAC43217; Mon, 26 Apr 2021 20:21:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from subbaram-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subbaram)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06071C433D3;
        Mon, 26 Apr 2021 20:21:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06071C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subbaram@codeaurora.org
From:   Subbaraman Narayanamurthy <subbaram@codeaurora.org>
To:     jackp@codeaurora.org
Cc:     abhilash.k.v@intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, subbaram@codeaurora.org
Subject: Re: [PATCH] usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4
Date:   Mon, 26 Apr 2021 13:21:31 -0700
Message-Id: <1619468491-22053-1-git-send-email-subbaram@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20210426192605.GB20698@jackp-linux.qualcomm.com>
References: <20210426192605.GB20698@jackp-linux.qualcomm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> If such a source is connected it's possible the UCSI FW could have

s/UCSI FW/PPM

> We can resolve this by instead retrieving and storing up to the
> maximum of 7 PDOs in the con->src_pdos array. This would involve
> two calls to the GET_PDOS command.
> 

This issue (see the signature below) is found by enabling UBSAN and
connecting a charger adapter that can advertise 5 PDOs and RPDO selected
by PPM is 5.

[  151.545106][   T70] Unexpected kernel BRK exception at EL1
[  151.545112][   T70] Internal error: BRK handler: f2005512 [#1] PREEMPT SMP
...
[  151.545499][   T70] pc : ucsi_psy_get_prop+0x208/0x20c
[  151.545507][   T70] lr : power_supply_show_property+0xc0/0x328
...
[  151.545542][   T70] Call trace:
[  151.545544][   T70]  ucsi_psy_get_prop+0x208/0x20c
[  151.545546][   T70]  power_supply_uevent+0x1a4/0x2f0
[  151.545550][   T70]  dev_uevent+0x200/0x384
[  151.545555][   T70]  kobject_uevent_env+0x1d4/0x7e8
[  151.545557][   T70]  power_supply_changed_work+0x174/0x31c
[  151.545562][   T70]  process_one_work+0x244/0x6f0
[  151.545564][   T70]  worker_thread+0x3e0/0xa64

> Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
> Fixes: 4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
