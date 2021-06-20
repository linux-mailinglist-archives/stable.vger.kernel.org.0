Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB13AE011
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFTTnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 15:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhFTTnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 15:43:02 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20698C061574;
        Sun, 20 Jun 2021 12:40:49 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so15604378otl.0;
        Sun, 20 Jun 2021 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DQusFnW3hHgzuSI11If5qDcszYEE0tpKTWUFr6lPDeY=;
        b=slkLYI7GNK8zRxNvrmbcUH0LxFMreiQ7YMu+8cXQOQNiQRI0Nr7rIOj1esTPqXu0db
         VodmP2fxrI//9o7wLIxkh0BsPw5vwt/6SAA8eVf8ki0knR8G4nX+3ExhetoOSAgteR+N
         IKWaWYcUc1qSnfo03+I85BtLMazqnTnud41UDYL5ERE9Mr5JhuXMmyQr1Mms6Pq7rxAk
         YpKzYXEBsTJ3ddzXZR1bwP7m2Jtt7SFs8DH3cfpCytZBR8dfwKZedOv9aQEKJaOWnLEf
         /xZcECnwZ1UqmAEw4ou8BFfHXuCsYA+bQN93guCkT2cAUqicRNRDrXFDmTglP1jQda4t
         si6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQusFnW3hHgzuSI11If5qDcszYEE0tpKTWUFr6lPDeY=;
        b=h2DB85/u+85oQci9bkdps9vGC5+zzFve8CYloWLuIA+rvAJ1FF/b+KCcWO4bCAQUFi
         dFZAHaOJcQcYmFvQco6uQc+cg6i4ce2/8uJWWa1rVqe+SyIrVkaNwVuC3C/k/fTfYul5
         MWlsAKF3Lk33iIwBYLiqn8krwjuO5Q+KiBVIyi0OejTc5zaQ8PFuDFmW6PHlRLJ5aTRV
         zJJw6xoFlrXYsCYWd9dYqjcAj5LMk2V6A0O0EKynVteZNE2pzu9AllhXlcXnDTjvVACh
         jh599UbHabSkNa6Q18BGsX+OrczoxmJVkcO+PEhbZjya8sLOj8hpwcUab9l1JYLEHFde
         LeCQ==
X-Gm-Message-State: AOAM533QuNPuYI9/42G16bkPGDbjb/MVOoeH/FwZDbgD2pPspfcBHU90
        UBf9MzPV5Rh7iRnSWeV7mWwRz3MGYkg=
X-Google-Smtp-Source: ABdhPJwksek0LL3QqY6hZHVdM7ulXoIAe+SlVBLZh/wevgf0tKT4UdK4xg+ctkAZF8tTrzr6WEKUYg==
X-Received: by 2002:a05:6830:1283:: with SMTP id z3mr18364129otp.346.1624218048274;
        Sun, 20 Jun 2021 12:40:48 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id u14sm2232916oie.0.2021.06.20.12.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 12:40:47 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] rtw88: Fix some memory leaks
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
References: <20210620192407.22812-1-Larry.Finger@lwfinger.net>
 <YM+X1pUFCLWprv+O@kroah.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6987b395-b6a8-662b-9901-e499a59bbf64@lwfinger.net>
Date:   Sun, 20 Jun 2021 14:40:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YM+X1pUFCLWprv+O@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/21 2:32 PM, Greg KH wrote:
> On Sun, Jun 20, 2021 at 02:24:07PM -0500, Larry Finger wrote:
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
> 
> No changelog at all?  I know I would not take this if it were my
> subsystem :)

Greg,

I would not accept it, now will Kalle. V2 on its way.

Larry

