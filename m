Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA0041F287
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 18:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355253AbhJAQxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 12:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355160AbhJAQxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 12:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED68E6124D;
        Fri,  1 Oct 2021 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633107122;
        bh=bk6/xYP2gqu5R6jhA4DnP4czQX4XmdvKGTlusbUWxhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fbhqdqylof8JG/SUxYb3CwkopmcxNnoSmLlIcFin3yIabe2ebXxhk1rIRGtHc7bUQ
         ij8FFxf6YgdaKixcitdY8m6pml8Gx/kosoxriOTfQkIfaRJm32qfxWWp54thh8eTxX
         FjWjvGS7ELOB5hFs78cQlXuwj7XqKCBw2GzEJZ4bzJ5IbgJFQPXEvaG+BdHnZD8NIj
         CKWbTXP2VyuZGD4xR8l/86nkdf+Ax5/luKj5W22KpB5rmKJjLpgCHrJH2mBzgULkAD
         OMWgV1VVMLB1HA1+26VkNgxQTYKCc080/fdOFtEMhC/qmtE056s6MXRquu26C1Si8o
         T34IMzY95kNjA==
Date:   Fri, 1 Oct 2021 12:52:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     Greg KH <greg@kroah.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdns3: fix race condition before setting doorbell
Message-ID: <YVc8sZqAR1EOjrlE@sashalap>
References: <20210930094217.23316-1-pawell@gli-login.cadence.com>
 <YVWLamYUlXMmjdqq@kroah.com>
 <BYAPR07MB5381A0DD3A5CBB66D5178372DDAA9@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381A0DD3A5CBB66D5178372DDAA9@BYAPR07MB5381.namprd07.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 10:22:42AM +0000, Pawel Laszczak wrote:
>>
>>On Thu, Sep 30, 2021 at 11:42:17AM +0200, Pawel Laszczak wrote:
>>> From: Pawel Laszczak <pawell@cadence.com>
>>>
>>> commit b69ec50b3e55c4b2a85c8bc46763eaf33060584 upstream
>>>
>>> For DEV_VER_V3 version there exist race condition between clearing
>>> ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
>>> Setting EP_CMD_DRDY will be ignored by controller when
>>> EP_STS_TRBERR is set. So, between these two instructions we have
>>> a small time gap in which the EP_STS_TRBERR can be set. In such case
>>> the transfer will not start after setting doorbell.
>>>
>>> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>>> cc: <stable@vger.kernel.org> # 5.4.x
>>> Tested-by: Aswath Govindraju <a-govindraju@ti.com>
>>> Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
>>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>>> ---
>>>  drivers/usb/cdns3/gadget.c | 14 ++++++++++++++
>>>  1 file changed, 14 insertions(+)
>>
>>What kernel(s) are you wanting this applied to?
>
>To 5.4. I added information in cc: <stable@vger.kernel.org>  tag (# 5.4.x) .
>Is it sufficient or not?  I ask because I need to post this fix also to v5.10.

I queued this up for both 5.10 and 5.4, thanks.

The issue seems to be that in the upstream patch you explicitly stated
to go only to 5.12:

	cc: <stable@vger.kernel.org> # 5.12.x

Was that your intent?

-- 
Thanks,
Sasha
