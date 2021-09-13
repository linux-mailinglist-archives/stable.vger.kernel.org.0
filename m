Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF3409A1E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbhIMQ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239888AbhIMQ47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 12:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A1CC60FE6;
        Mon, 13 Sep 2021 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631552143;
        bh=uUD9BeW8jFyLzVb0L7I3RCTD4qAQLcOLZZFlOvJ6GrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQ2w0/Elkm+1G3wLjr17l9B2+/QcO0UwFVduMARk/dIt2bTmoS2TlWAgP9Qxzhs/H
         J+HSjxT9vUVf8XG/e7ZSCTEmCXWQoPnwVdeAh1iAEWfp8EfomkJJy+4Usub5jDVxqt
         Z+8ktArEH3LiFcHHe9sNaMWlhtfg+cR9P4Xqv2TFxIjmrfBy8hWCPkQIOMJs+GutK0
         IAkvz5z2Xn5xMOXmAhYKL5bn4N1fxu9fZB/UU7atC+NguZpIUdcSloYYkqDQybANSk
         +GethoLYKDThi70fW1qF2HrLi6pMB64PlYmRj5mcJIVrwnF6G8p3bK9JU0voZ/Ofhe
         xSEeZ2Sl0mYnw==
Date:   Mon, 13 Sep 2021 12:55:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 088/252] i2c: i801: Fix handling
 SMBHSTCNT_PEC_EN
Message-ID: <YT+CjnAnkfL3Nh0D@sashalap>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-88-sashal@kernel.org>
 <20210909151320.7bddd134@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210909151320.7bddd134@endymion>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 03:13:20PM +0200, Jean Delvare wrote:
>Hi Sascha,
>
>On Thu,  9 Sep 2021 07:38:22 -0400, Sasha Levin wrote:
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>
>> [ Upstream commit a6b8bb6a813a6621c75ceacd1fa604c0229e9624 ]
>>
>> Bit SMBHSTCNT_PEC_EN is used only if software calculates the CRC and
>> uses register SMBPEC. This is not supported by the driver, it supports
>> hw-calculation of CRC only (using bit SMBAUXSTS_CRCE). The chip spec
>> states the following, therefore never set bit SMBHSTCNT_PEC_EN.
>>
>> Chapter SMBus CRC Generation and Checking
>> If the AAC bit is set in the Auxiliary Control register, the PCH
>> automatically calculates and drives CRC at the end of the transmitted
>> packet for write cycles, and will check the CRC for read cycles. It will
>> not transmit the contents of the PEC register for CRC. The PEC bit must
>> not be set in the Host Control register. If this bit is set, unspecified
>> behavior will result.
>>
>> This patch is based solely on the specification and compile-tested only,
>> because I have no PEC-capable devices.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Tested-by: Jean Delvare <jdelvare@suse.de>
>> Signed-off-by: Wolfram Sang <wsa@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/i2c/busses/i2c-i801.c | 27 +++++++++++----------------
>>  1 file changed, 11 insertions(+), 16 deletions(-)
>
>This patch fixes a theoretical problem nobody has ever complained
>about. I don't think it makes sense to backport it to stable kernel
>branches.

Sure, I'll drop it. Thanks.

-- 
Thanks,
Sasha
