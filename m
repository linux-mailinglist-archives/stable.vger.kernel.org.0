Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECBE6791F
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 10:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfGMIC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 04:02:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41507 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfGMIC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 04:02:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so5304388pff.8;
        Sat, 13 Jul 2019 01:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kj4uxPGdjaQYSaMuuVNbxfkypLtBd+PP6doHp41Sdvw=;
        b=TfbaSb+wKJQO1BfU3gPeuDDOQ0afR7dEZVFg7bMs4ExZAQTP+XrDI0p9huDKX01AgS
         WrVYj+lpyyjVHELjzJSME6O03n8ooA0R93Up704piESYzy5vpvS47UfRy6bjbP3Lx4ua
         SXW9L/BKKj87Q+Bt58WX69CcH2saeJLjlOvZdPpMVnvWAtvhnPJBWIMnR2rK4sLReEcv
         1XBbVKCrjjLhUUUbqN2EXXNDDSeYfpkWoLaolFIhU/9iYQsH0ABJZjAJfIVAzBd7q+/A
         TM5AICEg6W6P7ZJw122OSqCOz17csQN7efSiCGytjnZG9qp7gmo5hFKI657RQ179feQo
         Tw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kj4uxPGdjaQYSaMuuVNbxfkypLtBd+PP6doHp41Sdvw=;
        b=t1eSp3MZ7mySh1eEk7gr00NkoY16rTJDTjZyRo5Ad7LAK2aBnS6y6PYxjBDXzX2fAd
         R7E1jmhF5Eka5eKE1KRRKDa3z8js69uVnSfvcbKfENVf5RK7RmkjTkv/K++moxFpfc1z
         W0Ksd4o9anv1in86R26Pawana73N/+7YRw6TachCLQlAA1yF5vHiikUiPZ3ICfKBDc2s
         Vki4LwJrEMlvkP2qU7OtxXasrupVSAvmQIVa8WLR/uiMgDwVnk69J5dCiROJKgTlaRD6
         kk7RnWnmhFHnLNb5LIe9iSPxwFu/wthBZ4Ny86gq+8+F3m8nr+XHNPWnV9xqPn5JCAQZ
         2+Pw==
X-Gm-Message-State: APjAAAVGh4wX4rH2XrYTcXszLrlFHmLce8q3jp8T55gvIuPe65F9Qnrz
        i8zCD9pFY1grugvvZXbYspo=
X-Google-Smtp-Source: APXvYqwFtg0Ta37HZ2EceDeMi683MnFrEts9LcjRUdAP4VhfzlrfbFRYDMBSPCj1WCr1oACKZeqJBg==
X-Received: by 2002:a65:6401:: with SMTP id a1mr15733616pgv.42.1563004976459;
        Sat, 13 Jul 2019 01:02:56 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id w3sm9831951pgl.31.2019.07.13.01.02.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 01:02:55 -0700 (PDT)
Date:   Sat, 13 Jul 2019 01:02:54 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Grant Hernandez <granthernandez@google.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Input: gtco - bounds check collection indent level
Message-ID: <20190713080254.GB243807@dtor-ws>
References: <20190711222232.77701-1-granthernandez@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711222232.77701-1-granthernandez@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 03:22:32PM -0700, Grant Hernandez wrote:
> The GTCO tablet input driver configures itself from an HID report sent
> via USB during the initial enumeration process. Some debugging messages
> are generated during the parsing. A debugging message indentation
> counter is not bounds checked, leading to the ability for a specially
> crafted HID report to cause '-' and null bytes be written past the end
> of the indentation array. As long as the kernel has CONFIG_DYNAMIC_DEBUG
> enabled, this code will not be optimized out.  This was discovered
> during code review after a previous syzkaller bug was found in this
> driver.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Grant Hernandez <granthernandez@google.com>

I wish we could convert gtco to be proper HID driver, so we woudl not
have to deal with custom HID parsing, but in the meantime this is
needed.

Applied, thank you.

-- 
Dmitry
