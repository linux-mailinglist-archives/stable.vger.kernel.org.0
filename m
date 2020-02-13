Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1315CB0C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgBMTT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 14:19:29 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:36559 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgBMTT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 14:19:29 -0500
Received: by mail-pg1-f169.google.com with SMTP id d9so3635051pgu.3
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 11:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=svdHntk6MjGx0bb0gPAAC5MXcMRdwli9ToygCmoHZug=;
        b=cZEX1LOk79IweKChQh6iOyftLp9zvaVzeD5ANkjCqMNAvClJXgucPEDBPp7pSJSdHl
         fwNCLDc/4/UOMhUKo+47cekUp0OXoN1C9GBEEOo51kg7XJnSJ/HLu2Uwt5iexngNbdR1
         6z9TxHzLHkPA5W2sZCaJ0TMB5FPz68PKUFF2KU83xySvj6Dhk8rUPBeOJ30JZouXkBTB
         nZYHcw4EnluPJZv8Wq4UNe7JIpvagUEXNtX4xhRRgd/08oltbstC+9+OEnP+7adhQOUY
         srWgkS7OlZ5BotA+Qe8j1gz77ETZ0XpIc+vk4Y4DteTselHwCVLXOXLeH0nNHrz2KWMX
         AFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=svdHntk6MjGx0bb0gPAAC5MXcMRdwli9ToygCmoHZug=;
        b=Qf4S0KtB9klG5rmWkrNjIbR6fgQjyg0JhDIEHKyHLuLOeTNhYmPFWrBff51jzBbju1
         juToWKGQPZZB1/uip4gIUIrWWiU/O8wQLuReglgw4ZVC2E68tarcVr8ttPpfhpSSuTwq
         I8/Ag5QwX7abhHg00wBWfLLoRXmdAMxlqx4KmvuWwcEqpvv7qPZ+OdfTfbzQDRnie5AK
         dI2mQLeQQU5LmPpCQTDpHWUDwcAUcsNonfa6ZMLIjs0EPesK1cXiU+2D+VbdJICqu25+
         NgYNV8gQaqir5pq9UoJYw1N5szbv0j7ldIIByD9B1WDl3ykbzWqO/vn6UZzWhNQFUqdP
         e7nw==
X-Gm-Message-State: APjAAAXo8uGDiNobCHZ/BlE8Ga7OyFdND+jbac3hyx0KSFroWM6GFEPF
        ssBoKfRLWUxNbd1yrq7oqVLevo6a2hcOGdwGYoaxPw==
X-Google-Smtp-Source: APXvYqye/XEqFG87rJrV5D98jPgJZZn4CTD3Lt2lrjVVLMyw0tZi0MKQw+p+SjuwcmU0uNgBMsN9Rw6IbhVkXvFcbAE=
X-Received: by 2002:a63:af52:: with SMTP id s18mr7468400pgo.263.1581621567084;
 Thu, 13 Feb 2020 11:19:27 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 13 Feb 2020 11:19:16 -0800
Message-ID: <CAKwvOdnYPvov5ULB_BHodeLde4V1Zg+UF0X=V=i1yH77XvhXZg@mail.gmail.com>
Subject: please cherry pick 75fea300d73a to 4.14.y
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, nico@linaro.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <Miles.Chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,
Would you please cherry pick
commit 75fea300d73a ("ARM: 8723/2: always assume the "unified" syntax
for assembly code")
which first landed in v4.16-rc1 into 4.14.y?

In my experience, it cherry-picks cleanly.  It fixes a stream of
warnings we see when building 32b ARM kernels with Clang, like:

/tmp/signal-1ac549.s: Assembler messages:
/tmp/signal-1ac549.s:76: conditional infixes are deprecated in unified syntax

We'll make immediate use of it in Android; if anyone objects to
landing in stable let us know and we can carry it out of tree.
-- 
Thanks,
~Nick Desaulniers
