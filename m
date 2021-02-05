Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACD93101B0
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 01:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhBEAez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 19:34:55 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:41570 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbhBEAex (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 19:34:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5131B1280945;
        Thu,  4 Feb 2021 16:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612485252;
        bh=ao1tCVbyRaFXodmCECuczSLWDQt1/Kn3kiGuUAeu38Y=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=pI/DlmMU8rlca1wgwBn9ISSeG91HbyGhtzrDznsum3fC3/kciuTEm+DS7bNREbSO4
         kq1stgXIMkcZqWzZccu2CYTce+zcbfH5SG6wV/L6jfbtbVF5l005qapo/gbf//zhij
         IIUHAAs67roxSRXM988T/gC2b2M7Gb8o8d6du/6s=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jNbf3Z_B-f4N; Thu,  4 Feb 2021 16:34:12 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id AD6D41280935;
        Thu,  4 Feb 2021 16:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612485252;
        bh=ao1tCVbyRaFXodmCECuczSLWDQt1/Kn3kiGuUAeu38Y=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=pI/DlmMU8rlca1wgwBn9ISSeG91HbyGhtzrDznsum3fC3/kciuTEm+DS7bNREbSO4
         kq1stgXIMkcZqWzZccu2CYTce+zcbfH5SG6wV/L6jfbtbVF5l005qapo/gbf//zhij
         IIUHAAs67roxSRXM988T/gC2b2M7Gb8o8d6du/6s=
Message-ID: <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Date:   Thu, 04 Feb 2021 16:34:11 -0800
In-Reply-To: <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
         <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-02-05 at 00:50 +0100, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> In tpm2_del_space() chip->ops is used for flushing the sessions.
> However
> this function may be called after tpm_chip_unregister() which sets
> the chip->ops pointer to NULL.
> Avoid a possible NULL pointer dereference by checking if chip->ops is
> still
> valid before accessing it.
> 
> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of
> tpm_transmit()")
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> ---
>  drivers/char/tpm/tpm2-space.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-
> space.c
> index 784b8b3..9a29a40 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -58,12 +58,17 @@ int tpm2_init_space(struct tpm_space *space,
> unsigned int buf_size)
>  
>  void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space)
>  {
> -	mutex_lock(&chip->tpm_mutex);
> -	if (!tpm_chip_start(chip)) {
> -		tpm2_flush_sessions(chip, space);
> -		tpm_chip_stop(chip);
> +	down_read(&chip->ops_sem);
> +	if (chip->ops) {
> +		mutex_lock(&chip->tpm_mutex);
> +		if (!tpm_chip_start(chip)) {
> +			tpm2_flush_sessions(chip, space);
> +			tpm_chip_stop(chip);
> +		}
> +		mutex_unlock(&chip->tpm_mutex);
>  	}
> -	mutex_unlock(&chip->tpm_mutex);
> +	up_read(&chip->ops_sem);
> +
>  	kfree(space->context_buf);
>  	kfree(space->session_buf);
>  }


Actually, this still isn't right.  As I said to the last person who
reported this, we should be doing a get/put on the ops, not rolling our
own here:

https://lore.kernel.org/linux-integrity/e7566e1e48f5be9dca034b4bfb67683b5d3cb88f.camel@HansenPartnership.com/

The reporter went silent before we could get this tested, but could you
try, please, because your patch is still hand rolling the ops get/put,
just slightly better than it had been done previously.

James




