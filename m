Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82894C2104
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 14:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbfI3M5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 08:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730411AbfI3M5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 08:57:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862CB2086A;
        Mon, 30 Sep 2019 12:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569848233;
        bh=cWkGctcZBpLzWUdydqZGbs8Z7ktCzDFl133cvL8ARuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UpsYcYT2KIY+SdY5z5MJjzkmqf3RwPqHDOLd0YLJI2C9krfpDjOJbRW9DZRQOeaY9
         xm0L0/TyEjtlsBy0yYOq4vx5VztMN5Y5370LXryk6mAL0ofcJqM8C5qk9yR4i/PZqS
         cwgo/8w9Rfmb0CgeSX4Hb9KHrLCwrKyzjLcVGSKM=
Date:   Mon, 30 Sep 2019 08:57:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 4.19 33/63] tpm: Fix TPM 1.2 Shutdown sequence to prevent
 future TPM operations
Message-ID: <20190930125712.GS8171@sasha-vm>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.128262622@linuxfoundation.org>
 <20190930061346.GA22914@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190930061346.GA22914@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 08:13:46AM +0200, Pavel Machek wrote:
>> From: Vadim Sukhomlinov <sukhomlinov@google.com>
>>
>> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
>>
>> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
>> future TPM operations. TPM 1.2 behavior was different, future TPM
>> operations weren't disabled, causing rare issues. This patch ensures
>> that future TPM operations are disabled.
>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index 46caadca916a0..dccc61af9ffab 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -187,12 +187,15 @@ static int tpm_class_shutdown(struct device *dev)
>>  {
>>  	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
>>
>> +	down_write(&chip->ops_sem);
>>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>>  		down_write(&chip->ops_sem);
>>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>>  		chip->ops = NULL;
>>  		up_write(&chip->ops_sem);
>>  	}
>> +	chip->ops = NULL;
>> +	up_write(&chip->ops_sem);
>
>This is wrong, it takes &chip->ops_sem twice, that can't be
>good. db4d8cb9c9f2af71c4d087817160d866ed572cc9 does not have that
>problem.

I agree. I've dropped it from 4.19 and 4.14.

Jarkko, can you take a look at this again please?

--
Thanks,
Sasha
