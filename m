Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D5B1076DC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 18:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKVR7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 12:59:06 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33201 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVR7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 12:59:05 -0500
Received: by mail-oi1-f194.google.com with SMTP id x21so163024oic.0;
        Fri, 22 Nov 2019 09:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zt9/WbRpF+in66rAGR5FMaxTYD1kOM2Ez5yax9xrbjU=;
        b=mwWDWXgM5LRjvON1p+hq4/FN8aeAV6T5zQIHssM3jAciT+GCLD+uWaJI5wq8w7D8En
         65dzRnQJFNbLsb/cnZ7pqxSmKiNm7pkNIupWiL3WrFU1fc1ooWy/lWXUPW5jt7AU92ZL
         Esmk6bfF0vDYmZh7z3/yYcrLCbSRRmFLPYpd10ix6zTv8YPkFNx1GVtuCJwUMkgj1BgS
         OW9b2i1uSp1HJwLqqGYBnuo1YT83MjPl+d7XgdV5FXk5YSUUP6vMaBA04RlGc5GxZyxx
         d2F/Ja15TSjVQRNQja/qdoqPfF4/z06HSUwDojRXGWhSOSbCFRu/UXCh29e5eWZ8Jj3K
         EASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zt9/WbRpF+in66rAGR5FMaxTYD1kOM2Ez5yax9xrbjU=;
        b=tRQ8ZPLNTCR4UdMe4z6voXXbo7LQaZox95+xPqB/USvb/pB2W9qvPj+axMLT6/Nfvi
         7AsuY+67IiXrtZb75EnHlaWjb49ey1YCvYUhnONAjChTptftN6Vr/3AhGujxKMuH6cpb
         AlmyVRdfdy9j9MztWJ0Oa7YBpIR2YRtrMg4VE5VN970MDRQ2lAfrEFpbfO+dCkXIq1d4
         qNjCxITbeSr1RtmYcExB5v6r9h8Nm9fYFttfkDcoRgOv+TeSwBIGURQN0Y4KOhCjlMFQ
         kxGqPc1WDuMZ5BLlWen0qnkuJ4KwxrnRL//ZzBMElnwrESicfUZwShTno0TMLqQ3rqys
         P1OQ==
X-Gm-Message-State: APjAAAV19m9ERYoQnp9O5ATm/bX02BUQvU36P/IUxWnTLoIgJHbstrqc
        0RbCoUEpzxdUJxZI3h8afKGFqmuX
X-Google-Smtp-Source: APXvYqwac8KQFpUPDIstpS6f+I9wvIgst8DQs6V3Ro2aaBvH7gB7X9kb/mlsypjVVAxffPQzk1ww7A==
X-Received: by 2002:aca:f141:: with SMTP id p62mr13059822oih.3.1574445543256;
        Fri, 22 Nov 2019 09:59:03 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t10sm2408834otc.65.2019.11.22.09.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 09:59:02 -0800 (PST)
Subject: Re: [PATCH 2/3] rtlwifi: rtl8192de: Fix missing callback that tests
 for hw release of buffer
To:     Sasha Levin <sashal@kernel.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        stable@vger.kernel.org
References: <20191111194046.26908-3-Larry.Finger@lwfinger.net>
 <20191122070014.BA0492070A@mail.kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <abb85c02-d7f2-7eb0-7522-7616d32de100@lwfinger.net>
Date:   Fri, 22 Nov 2019 11:59:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191122070014.BA0492070A@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/19 1:00 AM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers").
> 
> The bot has tested the following trees: v5.3.11, v4.19.84, v4.14.154, v4.9.201, v4.4.201.
> 
> v5.3.11: Build OK!
> v4.19.84: Build OK!
> v4.14.154: Failed to apply! Possible dependencies:
>      0c07bd745760 ("rtlwifi: rtl8192ee: Make driver support 64bits DMA.")
> 
> v4.9.201: Failed to apply! Possible dependencies:
>      004a1e167905 ("rtlwifi: rtl8821ae: Remove all instances of DBG_EMERG")
>      02527a73beb3 ("rtlwifi: rtl8188ee: Remove all instances of DBG_EMERG")
>      0c07bd745760 ("rtlwifi: rtl8192ee: Make driver support 64bits DMA.")
>      102e295ed5a4 ("rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA")
>      2d15acac2354 ("rtlwifi: rtl8192se: Remove all instances of DBG_EMERG")
>      4e2b4378f9d7 ("rtlwifi: rtl8723be: Remove all instances of DBG_EMERG")
>      a44f59d60365 ("rtlwifi: rtl8192ee: Remove all instances of DBG_EMERG")
>      a67005bc46d9 ("rtlwifi: rtl8723ae: Remove all instances of DBG_EMERG")
>      b8c79f454880 ("rtlwifi: rtl8192de: Remove all instances of DBG_EMERG")
>      c34df318ec9f ("rtlwifi: Convert COMP_XX entries into a proper debugging mask")
>      c38af3f06af4 ("rtlwifi: rtl8192cu: Remove all instances of DBG_EMERG")
>      e40a005652ad ("rtlwifi: rtl8192ce: Remove all instances of DBG_EMERG")
> 
> v4.4.201: Failed to apply! Possible dependencies:
>      02527a73beb3 ("rtlwifi: rtl8188ee: Remove all instances of DBG_EMERG")
>      0c07bd745760 ("rtlwifi: rtl8192ee: Make driver support 64bits DMA.")
>      102e295ed5a4 ("rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA")
>      4713bd1c7407 ("rtlwifi: Add missing newlines to RT_TRACE calls")
>      5345ea6a4bfb ("rtlwifi: fix error handling in *_read_adapter_info()")
>      9ce221915a94 ("rtlwifi: Create _rtl_dbg_trace function to reduce RT_TRACE code size")
>      ad5748893b27 ("rtlwifi: Add switch variable to 'switch case not processed' messages")
>      b8c79f454880 ("rtlwifi: rtl8192de: Remove all instances of DBG_EMERG")
>      c34df318ec9f ("rtlwifi: Convert COMP_XX entries into a proper debugging mask")
>      c38af3f06af4 ("rtlwifi: rtl8192cu: Remove all instances of DBG_EMERG")
>      e40a005652ad ("rtlwifi: rtl8192ce: Remove all instances of DBG_EMERG")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Sasha,

The underlying directories were moved from drivers/net/wireless/rtlwifi/ to 
drivers/net/wireless/realtek/rtlwifi/. I can refactor the patches to account for 
this change. How should I annotate them, and where should I send them?

Larry

