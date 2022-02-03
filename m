Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AC74A8987
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352696AbiBCRLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346667AbiBCRLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:11:08 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C000C06173B;
        Thu,  3 Feb 2022 09:11:06 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ka4so10752688ejc.11;
        Thu, 03 Feb 2022 09:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sovBYQAcoAyRD+IIp48jmZd62dc3/cLT/aahzL7f+PY=;
        b=UjJ6eCdCr1s35/Zo6xyKw4ExVCZWsabyMSRJPkW67/rmaNf6eywVd5fYWuVKjzsZ1a
         hkEqLCHF//sbgceQvWe/DKmEw1ETKhUbrxKLa5NwHqHyzskqYVDomlaQlVp4I2u0d+tp
         1Zv0nQ7fTHzczJUWhlhsUyE+skpdhD+D5Tikriz0fV1/DmZ6/SJKpNrSBM1puEVLULiV
         Iuy8E3nZTM0q/d98bV6q4+HXzeHVDwEjORppIh2FXwNtl3a4dLSQz98FpBa8GfsrEwFV
         /XHfVa4XimsgNOZqgQkeqnCAObuEufllNAee3Qx2GZLIhcibJyVaajFCD4my587rkZBz
         jcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sovBYQAcoAyRD+IIp48jmZd62dc3/cLT/aahzL7f+PY=;
        b=CoMTD7P1jo6myrtiRPozkSS4Hc0Ir+q7D4Acs0wJ58MEOI54uNJgRXGDyqu7wV0A+/
         cckJjyhxAHufpwJ/dwbSmvEfEq4l9kK0NmRGoDRA33w4M3PnCU+kMPAO+S8ZlOQIofxr
         x8Rv1Ri4o7EuWpoLmOsdJREml1GNOic6hsP4N9pA3Q+oP0IRYSxlVDm9iSBWzNj8IrZc
         /hfDbr5E0hQV5Ua8G/YWoEqjyxP0CG5fZkPQwrXusxKFsLYLnw3PXB+lYPCkPXPZyUD/
         gwmtCDr2o7tML4MHgvSSOL0hXz5ZZ/0VefuAI0km0RAl+k/C4n5If6/sUIETdV44pk7P
         OvCg==
X-Gm-Message-State: AOAM531Oce6xEIeEnKJsvXuLQC3rpu47coCI6qcOMHCV+Ut44W4ypGKH
        aD5Pw/NQbddxKhLYAuHH2Jc=
X-Google-Smtp-Source: ABdhPJx3sYSUxiXz5lyDAeE53N1p30al3RfLZxJr/EGh4DnCjrKY+oKW+E0n7MmYR6U2CYbraG/Jug==
X-Received: by 2002:a17:907:868f:: with SMTP id qa15mr32261051ejc.518.1643908264487;
        Thu, 03 Feb 2022 09:11:04 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:71d8:a0a4:4bb5:bafa? (p200300ea8f4d2b0071d8a0a44bb5bafa.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:71d8:a0a4:4bb5:bafa])
        by smtp.googlemail.com with ESMTPSA id u3sm17315462ejz.99.2022.02.03.09.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 09:11:03 -0800 (PST)
Message-ID: <84f17973-96c3-6513-ca4f-20750c896e6b@gmail.com>
Date:   Thu, 3 Feb 2022 18:10:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] eeprom: ee1004: limit i2c reads to I2C_SMBUS_BLOCK_MAX
Content-Language: en-US
To:     Jonas Malaco <jonas@protocubo.io>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220203165024.47767-1-jonas@protocubo.io>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20220203165024.47767-1-jonas@protocubo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03.02.2022 17:49, Jonas Malaco wrote:
> Commit effa453168a7 ("i2c: i801: Don't silently correct invalid transfer
> size") revealed that ee1004_eeprom_read() did not properly limit how
> many bytes to read at once.
> 
> In particular, i2c_smbus_read_i2c_block_data_or_emulated() takes the
> length to read as an u8.  If count == 256 after taking into account the
> offset and page boundary, the cast to u8 overflows.  And this is common
> when user space tries to read the entire EEPROM at once.
> 
> To fix it, limit each read to I2C_SMBUS_BLOCK_MAX (32) bytes, already
> the maximum length i2c_smbus_read_i2c_block_data_or_emulated() allows.
> 
> Fixes: effa453168a7 ("i2c: i801: Don't silently correct invalid transfer size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonas Malaco <jonas@protocubo.io>
> ---
>  drivers/misc/eeprom/ee1004.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/misc/eeprom/ee1004.c b/drivers/misc/eeprom/ee1004.c
> index bb9c4512c968..9fbfe784d710 100644
> --- a/drivers/misc/eeprom/ee1004.c
> +++ b/drivers/misc/eeprom/ee1004.c
> @@ -114,6 +114,9 @@ static ssize_t ee1004_eeprom_read(struct i2c_client *client, char *buf,
>  	if (offset + count > EE1004_PAGE_SIZE)
>  		count = EE1004_PAGE_SIZE - offset;
>  
> +	if (count > I2C_SMBUS_BLOCK_MAX)
> +		count = I2C_SMBUS_BLOCK_MAX;
> +
>  	return i2c_smbus_read_i2c_block_data_or_emulated(client, offset, count, buf);
>  }
>  
> 
> base-commit: 88808fbbead481aedb46640a5ace69c58287f56a

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
