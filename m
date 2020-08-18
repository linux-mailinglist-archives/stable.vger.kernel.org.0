Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91A0248BDD
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgHRQpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 12:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgHRQpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 12:45:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000CCC061342
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 09:45:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t10so9465613plz.10
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 09:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EYH9QFulwc1L9HM0/F/ZkVeSU+OyN7m9DTioie6aqBw=;
        b=um9u8CPWT2vG3JzJ0O6YmmAwCf5SU9BaVzjyUdm9d5aXPxhYeyIThBfbfm7MOIKFst
         2JaGKUkAewEX9C7agQwDPPHXupRyvdJElX4MejOjaJ1JCpNAy7doG5YRQhP1Nf9cSAIZ
         Ar84YjQGI4IpBs3XRKLqC1q/i1jzpU/zmN646j73aT22pMNiIjeuAur03HPhWQg3sikO
         dXOdQGxEw6+w4xRlkNtUqnckJvTa/d0OVhZHKoEw3Fk7G6P39ucDRSucGImAqdDcBXq0
         8uyNG7iwvGLPPZT8rAaP7nJ1uiImiw68pLjlsRwRf3Q6TBP4CU+dxD7PY0j7B5GSwrrc
         F7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EYH9QFulwc1L9HM0/F/ZkVeSU+OyN7m9DTioie6aqBw=;
        b=saiTtFt9tXcMSrmj9D+FnUGeVhb2FLpw/dS7INPmxQe1ICmYtZ4+oUyXnys821QdN5
         iurW1USx9HFh5FS1dAH8Qfgw/5n94uhF/e5e9eMMa5QzcUW4V8iZS5SkO/F9bSnr5WDV
         1yD6imH8FlI0e0foY2nliJhrLCYWAtX2ZsMEa2T0alyUBTNrvTaYJ9lBCNvFaDHXhmaV
         ct3ZwpoVtJle4txQmRLbdGV9YrQ+zHOiH0X1iYrv8sL37ZHqEsmQ3GUswdOWk5goywVI
         11HJspWFypMlf7OoLen8aG8iTo2VB5ROk5j7dFM/xwSB4XF0B0i4MF9ifzrdlY/JISxQ
         0vLw==
X-Gm-Message-State: AOAM533GnRn8qrGEzilMxK/DyplX64a73gRUJfuOA23fWcdzXfpcd4lu
        EeUj5GozIYBIcDNzpuh4Y1gsMOZovVtR0Owq
X-Google-Smtp-Source: ABdhPJyhHR9ulFLMzLG8a0aTSfejqMZzC2bFrA6G+Y0gxun8N+vMYLa9iHOvXPtVrn/j/pu4QAhieQ==
X-Received: by 2002:a17:902:ed4a:: with SMTP id y10mr16088246plb.106.1597769102161;
        Tue, 18 Aug 2020 09:45:02 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id v78sm26545853pfc.121.2020.08.18.09.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 09:45:01 -0700 (PDT)
Subject: Re: [PATCH] block: fix get_max_io_size()
To:     Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org
Cc:     Eric Deal <eric.deal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
References: <20200806215837.3968445-1-kbusch@kernel.org>
 <20200818163932.GA2674385@dhcp-10-100-145-180.wdl.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <edcaf8e7-c76f-6ed5-e0e8-080f8fbb7473@kernel.dk>
Date:   Tue, 18 Aug 2020 09:44:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818163932.GA2674385@dhcp-10-100-145-180.wdl.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/20 9:39 AM, Keith Busch wrote:
> Hi Jens,
> 
> The proposed alternatives continue to break with allowable (however
> unlikely) queue limits, where this should be safe for any possible
> settings. I think this should be okay to go as-is.

OK, let's try this again then. Queued up for 5.9.

-- 
Jens Axboe

