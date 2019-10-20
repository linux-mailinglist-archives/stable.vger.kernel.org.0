Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B43DE057
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 22:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfJTUNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 16:13:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36237 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfJTUNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 16:13:16 -0400
Received: by mail-ot1-f66.google.com with SMTP id 67so9251525oto.3;
        Sun, 20 Oct 2019 13:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G+2eqRRy4akls0unQNzeQFHny5jIQlyDN020J7AGyQc=;
        b=JdNB3IqMzsHXrJnNdQsSyJeytpFuiwA4dUwsY+gsS3RfDwW36Tsa1BqxJ2U/N7ULaN
         mYymbmzmkaBa1WwNouPkTReYEjadmBiiLSLlwEmRcwuubjZdttHcqRO++dtIuc0uxPdy
         CliS/V+rdKANoBCVSJ9t5CSsxgwwxQ+s7vMVqEpVp54OOLVCi0mNY/c0YbHw/mNc2m/F
         83e51FEV7CJiQJ7FVmcLWk5iTfq64OCNsMuNi24+EBDKlyN2clBHwTJX/DNkDji/X9O2
         vmINZTyMDh+V9gB5Lzl7hhcrO2hQM7neNwwuklmNIzx5Xcipv0BxQDCO41UCPmcoCdHm
         lYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:subject:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G+2eqRRy4akls0unQNzeQFHny5jIQlyDN020J7AGyQc=;
        b=S+1ZA88CXFahMF5N2rag4somcLy37Ws2EoFkouGD8jW6te7n2qEmmQb23OJ3KrHu/D
         TK7oJJ9V+ihLXaKObLWVhyiUU1vdaGere+pP7gtDEtW2EMC3bYPo9764Ozf90cKaAM5R
         2hozaWlq59a4RGWTP9ontCaXROwjCqqTEBQXbxXnexPlYcedVKMhAJKhdqCN/eWNQml4
         RLuZ6gzJcGzGKQ57ezri7qsaLqiIgrnoZ41BDv+pxScEIglAGsc4qajHyxynD0BEQNUt
         RrfZnb4oFxhiF4T2qgISCPjGDdEq7my5NiwCw42oB7hz90b6f/GVk/uJGvw1CU7Xkin5
         tjyA==
X-Gm-Message-State: APjAAAX8p6lDQASoUWBLG0IpRj7WdEvaXbXrbwmE1RqHoKLp8iegn5N0
        uBtPukvlA9bvZOCNUZpKnYFhlOO5
X-Google-Smtp-Source: APXvYqxmahmZichoOikLt9k6kxKGSHHII//DVkKmRgFF63iTf6Jdu8PJM8NYCzYaPoi3Q0IwiGTHgQ==
X-Received: by 2002:a9d:5886:: with SMTP id x6mr14921331otg.351.1571602395728;
        Sun, 20 Oct 2019 13:13:15 -0700 (PDT)
Received: from [192.168.1.122] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id w13sm3165528oih.54.2019.10.20.13.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 13:13:15 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] rtlwifi: rtl_pci: Fix problem of too small skb->len
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Stable <stable@vger.kernel.org>
References: <20191020011153.29383-1-Larry.Finger@lwfinger.net>
 <874l03lt29.fsf@codeaurora.org>
Message-ID: <11ea185a-e2e8-5371-e9b3-4ac6f7880a00@lwfinger.net>
Date:   Sun, 20 Oct 2019 15:13:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <874l03lt29.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/20/19 3:28 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
>> only"), buffers whose length is too short cause a WARN_ON(1) to be
>> executed. This change exposed a fault in rtlwifi drivers, which is fixed
>> by increasing the length of the affected buffer before it is sent to
>> mac80211.
> 
> With what frames, or in what scenarios, do you get these warnings?

I am not sure how they happen, but the firmware reports a 3-byte packet, which 
leads to the warning. After looking at the code path again, a better approach 
would be to consider those short packets the same way that those with CRC or 
hardware errors and drop them.

After more testing, I will send V3 using that approach.

Larry
