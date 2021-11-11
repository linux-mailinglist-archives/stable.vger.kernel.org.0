Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87A44D7C5
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 15:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhKKOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 09:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKKOG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 09:06:26 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45449C061766;
        Thu, 11 Nov 2021 06:03:37 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g17so15218587ybe.13;
        Thu, 11 Nov 2021 06:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Jl86n894deUc+EyzRc3Kdc4ie9DWCIIIPAtn9wSfF7Q=;
        b=AQUQHcFJKaL1KwaFejo9eGaweb58HS1JVUQzPZsZiVPTjQ0uAYpePfp0jR68cO3T4/
         dqbA7IbAUFbg1wBIHM/NexyD9QxOdP4kNQ56WXfVZZCkcNENtbd78P1tobLKTFCrNFd3
         l9pgdUiDSZA/KxaO0vOdwqF8R25oNEoV8m43ZDTkV7+k4JK6lC4c7tYhrTPID4os3lFc
         XfnWo+B1aerxK0wYxEaTPKOa03ZNuhQ765wpofvfss6GVC+HXY/0RbHVJm5no/3j/2Ud
         x3JdtSs+0DBIL5c0BhOXQPEcF3q9Yog44kf0U8nsvZjXQK5h5L8r1NVzN3snZ1hENHjQ
         BxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Jl86n894deUc+EyzRc3Kdc4ie9DWCIIIPAtn9wSfF7Q=;
        b=gTnutKENjAyyB5k8Hhx2kmN+wYRWzW3uv2qdoDugKUZjI7YIs1vYu8KvSRDRJpauet
         6oJhpz8vTEvS+XmjyG3vPPHjBW0lUvBuZwY26k+4rUKm+v33Oehu0SJOnDt3AtGoKI5g
         M8dEb1VEJJSypLkJAO7gSeJcD454Faa3Zu9eP9ANdAqnnOGuBgI0hYHFqyqd7spdQCFX
         UrJoAnmlbLYQzB2vXHwd+i0ZbmeLyMRZoHyhsm+XzZP+8k/4L2hA+m2WynrVUtcLfxDP
         Ol/cGic4Do5nSqAx+CLGIZLu6JQi4kNjqcLrkTHp12KLyjkKk9Hw6YkhpuDmLYOKkObA
         J83g==
X-Gm-Message-State: AOAM533MntM8UBELZzYHMi09vJRAHnP1kwnjJwDJCNhg6Xt0u+ooQYtb
        X18zmGLvnWnA0eVmZ53Rj91XVZfgEnVP19VQwQUVzWNwREM=
X-Google-Smtp-Source: ABdhPJymxzFgO75t6intJsw4qa109jrrYnG+4AyV8xGLU6d54TKTGqHttzlsvFjaG3tov1L98lYMKiH3Vgds9MHnoZE=
X-Received: by 2002:a25:bdc5:: with SMTP id g5mr8235631ybk.403.1636639416542;
 Thu, 11 Nov 2021 06:03:36 -0800 (PST)
MIME-Version: 1.0
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 11 Nov 2021 14:03:00 +0000
Message-ID: <CADVatmOuOk6RoZF=M9sZm2L=9NuDDsSNNCJJbAtkgScG0og1Ww@mail.gmail.com>
Subject: regression with mainline kernel
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

My testing has been failing for the last few days. Last good test was
with 6f2b76a4a384 and I started seeing the failure with ce840177930f5
where boot timeout.

Last good test - https://openqa.qa.codethink.co.uk/tests/323
Failing test - https://openqa.qa.codethink.co.uk/tests/335

Saw a similar issue with 5.10.79-rc1 today and bisect showed the
problem with 8615ff6dd1ac but that was already in the last good test I
had.
I will do a bisect tonight and let you know the result.


-- 
Regards
Sudip
