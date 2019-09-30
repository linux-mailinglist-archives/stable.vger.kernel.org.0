Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C5CC1B53
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 08:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbfI3GOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 02:14:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33427 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfI3GOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 02:14:04 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id D7D45802BC; Mon, 30 Sep 2019 08:13:46 +0200 (CEST)
Date:   Mon, 30 Sep 2019 08:13:46 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 33/63] tpm: Fix TPM 1.2 Shutdown sequence to prevent
 future TPM operations
Message-ID: <20190930061346.GA22914@atrey.karlin.mff.cuni.cz>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.128262622@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929135038.128262622@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Vadim Sukhomlinov <sukhomlinov@google.com>
> 
> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
> 
> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> future TPM operations. TPM 1.2 behavior was different, future TPM
> operations weren't disabled, causing rare issues. This patch ensures
> that future TPM operations are disabled.

> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 46caadca916a0..dccc61af9ffab 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -187,12 +187,15 @@ static int tpm_class_shutdown(struct device *dev)
>  {
>  	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
>  
> +	down_write(&chip->ops_sem);
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		down_write(&chip->ops_sem);
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>  		chip->ops = NULL;
>  		up_write(&chip->ops_sem);
>  	}
> +	chip->ops = NULL;
> +	up_write(&chip->ops_sem);

This is wrong, it takes &chip->ops_sem twice, that can't be
good. db4d8cb9c9f2af71c4d087817160d866ed572cc9 does not have that
problem.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
