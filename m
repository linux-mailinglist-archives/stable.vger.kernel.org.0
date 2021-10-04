Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9267A4218DD
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhJDVAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 17:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhJDVAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 17:00:08 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AF7C061745;
        Mon,  4 Oct 2021 13:58:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m26so2318233pff.3;
        Mon, 04 Oct 2021 13:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fYKYnOB8eWX1FiGjloaLnrlnefMtOtSdd7NJtILGyco=;
        b=C853Tx89yfcySPNqnvWJUUspBQsHrNlVdaWx40wDNpiyGaqX66YzY6OIV9LpWeHroj
         Tzn3kN19LDzPdtZhFrS8v+y2MZJaaMIBhPkS0tUAKusmD2/1lmghxjmbAnqkIL+kH89f
         ZgjxlhzOy9DwqVhSgnb3GAbM4sPEEMluqvJObWlQGQW08975rLdEn+4KgMs2Cm4glwOh
         RJnrWOF5zaF4glrUSybhq/FcpQsSTKlS27S0cFWcAEWFzsLEVND9hTVLKQYmHh1Z+pCu
         mboSNpeH0I3aGQ6HYvbOxonQwcskp17QsmcANLHr3TNMD8eX/4veW7UVvUOWPHZaJJ/d
         YpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYKYnOB8eWX1FiGjloaLnrlnefMtOtSdd7NJtILGyco=;
        b=6qMKdPbYbVsQu/bhWOudsrBepioIB4wWj0U3K7XvE9nl+/FI5yJ+Olri6M+cJJupkV
         p9u1NIex6Jj1S7ScB+NiLCvW1sfuaPCwN8hqC9wDqU7Gd9986/5dYgxhrM6ADwR5WcWp
         XuAsziXLuDDzhZXbwEiUCbDQIXk4a1rey8q5ULrxKPMQi+lUofDaFqYA4UX6u40GIibG
         ojvITiyaxgkwH91em4rtQ6aNtE/fB3g/aEhHcXHlb/0hyhgNU7ouVs0oBm9vVuask8c6
         Iwjx+DwojZ3umybwjsnsyJfQSLKk1WRxUcWi+wBP4dvY90LYbkUr4/mCZGuc6Jhuk2Y0
         K+Sg==
X-Gm-Message-State: AOAM530el4id5ekDUt6TAolNO2XjwApHE/KUHjbCIcjvVDyWFkp7sD7M
        fkEzLbDQCoHl0sH/GPJFbVo=
X-Google-Smtp-Source: ABdhPJwx06KLZhNYOn84KbuSaDXLkt+qrtkepn9nPBW3w8b4a2bXyeTlO1qxtwcLYnsGxJvm6Z/qGw==
X-Received: by 2002:a63:e00b:: with SMTP id e11mr12767854pgh.190.1633381098393;
        Mon, 04 Oct 2021 13:58:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r8sm13482765pfg.91.2021.10.04.13.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:58:17 -0700 (PDT)
Subject: Re: [PATCH 5.10 90/93] net: mdiobus: Fix memory leak in
 __mdiobus_register
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20211004125034.579439135@linuxfoundation.org>
 <20211004125037.569805106@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f806f7c8-f7c4-2c70-4dec-be8794fdb2a7@gmail.com>
Date:   Mon, 4 Oct 2021 13:58:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004125037.569805106@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 5:53 AM, Greg Kroah-Hartman wrote:
> From: Yanfei Xu <yanfei.xu@windriver.com>
> 
> commit ab609f25d19858513919369ff3d9a63c02cd9e2e upstream.
> 
> Once device_register() failed, we should call put_device() to
> decrement reference count for cleanup. Or it will cause memory
> leak.

Also needs to be dropped.
-- 
Florian
