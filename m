Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29E996B38
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfHTVNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:13:53 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:39623 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTVNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 17:13:53 -0400
Received: by mail-pg1-f170.google.com with SMTP id u17so20632pgi.6
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=COQZdiCjrrFEcVsjX6I0ZXViUiK8K/UbiYsifMm0lpQ=;
        b=hC0JAsdkBmeIWNFNGmEqP7K6ub18gh9k8irPi0ipsaSpo2Njrhbu2TNSS6iz9xkoUx
         8+vfxlezmNEJ/P1DmD1AjBrRH6Nu1r6GOxw3cV/qUT5DneI5Sq7G9JdwYlZxed6+DKS2
         ETvxGt6zDFQmPAp2B5rM8dRzOe6MJBnSX4h+BKjmk/v6rdC0mF3UCcK45nalrCpbjhiF
         gtIn8xIcRf4hi+z7kA4MNTge1cfpoxotHHMvU3oXcegbfYkAKS+npWOIA7PjNtwbuMVe
         qLKlU1DLGnbmD0ZSQphipIJKc4IN+qbHzaG7cWXQ7gXFW6siwxqVW6p2KJ8hVgG8TNrg
         v5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=COQZdiCjrrFEcVsjX6I0ZXViUiK8K/UbiYsifMm0lpQ=;
        b=SNAGqlvOSAqCvM5rm9hetMirJ8Sj48i67iZcPv+OCA6q7XniF3AIeCkJjvL505Vjpv
         fslPXbn//xBOJy6OvjJi6QuFqpK1RvhjwWnbAbDLmNZiIRUuoCQ7vjrxEOivxSJLs2dG
         UfOzEpaGDyUady3KApuhRJnuvVhYxpHCVyB2o/OQEQp0lImSoZ/6nwXV726SBo90VXub
         ybyf0dh1ANaeKNT2yzvGknhrerqi6jHiun1fIohYEWD3BYzkOqx9KneIfW6jkDLFkCYA
         wJyu9gI8Gj989Ja3vP2D++5QTUftsP7DdP6TJfef16ya3sxG00UlBQdeoAbc30fCrQAN
         Uj1A==
X-Gm-Message-State: APjAAAUblzmB3+75gMzM0RDzHqc8gSwhI9JrX6DyoAUdeNO6Rce+I7xp
        t+uNGQKEzPoEzSU4Krw8z1qKTQ==
X-Google-Smtp-Source: APXvYqxN2pWdjLTCMpSWcz4etD41MHjyNMwBGq8Bot7/an/+ofeqXS2Yajq0JcfiwaEbFq09SwbeWQ==
X-Received: by 2002:aa7:9197:: with SMTP id x23mr31790435pfa.95.1566335632670;
        Tue, 20 Aug 2019 14:13:52 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id a6sm22890774pfa.162.2019.08.20.14.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2019 14:13:52 -0700 (PDT)
Subject: Re: USB: gadget: f_midi: fixing a possible double-free in f_midi
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        "Yavuz, Tuba" <tuba@ece.ufl.edu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        stable <stable@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
References: <20190820174516.255420-1-salyzyn@android.com>
 <20190820201515.GA20068@kroah.com>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <c96a0121-eb12-9449-44eb-0d2e09ccef92@android.com>
Date:   Tue, 20 Aug 2019 14:13:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820201515.GA20068@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/19 1:15 PM, Greg Kroah-Hartman wrote:
> No signed-off-by from you?
>
> Anyway, this is already in the 4.4.y queue and will be in the next
> release.
>
> thanks,
>
> greg k-h

Ok, thanks! I will stand down.

-- Mark

