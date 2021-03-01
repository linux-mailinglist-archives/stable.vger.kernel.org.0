Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079EA32769F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 05:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhCAESO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 23:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhCAESJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 23:18:09 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C52C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 20:17:28 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id d3so23219720lfg.10
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 20:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LmjnrJ9mFhKlFYnZVZ+um3NRidOVBBND5RLu3ZBmDfI=;
        b=ClPmZKvwezE8/EgIRCs+rDMOMzPobEmMN+967iKvV0lIT/U+9ybWgXDWgQv+Af6A/N
         /GTJPTnBFzOnLC1FfGf2pQiP0dlx+yUVPJClEPS2EXtHElNaxQTcLnMqnXa66X9dQnKZ
         /Y1xmdyAdb9EDNQ28qtgnFyi3T1T2hRbmASMQ+GCsahHYrPEggOesJLfn760ZKveIaLL
         kAbghNAt1Fuz0XbnYG0vA/b7Fp0V+fYhLKGEf6h/Es89vyFhgokJ1SZZCHUprE1yQEWV
         TDDJ5HXu9YTwRl6PLel+dpuOmmzFo/sF/twWghcrqqD5S7UYoEnxEdX54ORRvjoAElw9
         N9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LmjnrJ9mFhKlFYnZVZ+um3NRidOVBBND5RLu3ZBmDfI=;
        b=aZgMLfL5QEOdew4tXqnlYiZ/fvwbZYQJ1+Y0hfz/UXKRJeQ/AO1nLve43CO2FgkJKd
         eqVXP+myfbwGOdcypcdCJNbgLEzjBj90L/mH5NiI+WIbbOVxTn0achjeX5B3F4VHGcJ5
         pZQQUqP0xmhEN/ZPRykuXC7jONBT3PsgiK8vdC5mWN3I+fO1oxpp9PByz3yrutPnQvxE
         rDhBF7fqUyhnBeRriiS16wR8xivNV6F/SRHGt8NoSwI6NwYbSp/NAwYieawc0I3EcAw0
         XQXXEK2RwmU1pwZPdaTRXeKGOpkHWkm1i47RyINzVFO2xMOl8U5EvhhWW3A1c809UPaG
         tHag==
X-Gm-Message-State: AOAM5305Sbip50psEG+j6JbhsS2G4jV8rdrhQcv/yO1VLYi7gcLI7Auo
        3oDFJP/tH2F0Yw9S7ggQl0MlEyQjfZv8bS7Grcbfq+m4vX8F1g==
X-Google-Smtp-Source: ABdhPJz4oxiAMy8wLEUpqFPWm91MvThj234jp+H70CZWcuzJtPfyy0I9o7XKSQSoyGsX3TGlsJXsibe0LO4tH8JPdgs=
X-Received: by 2002:ac2:4d9b:: with SMTP id g27mr8721415lfe.113.1614572246663;
 Sun, 28 Feb 2021 20:17:26 -0800 (PST)
MIME-Version: 1.0
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 1 Mar 2021 09:47:15 +0530
Message-ID: <CAFA6WYMVsmjy5KMYwFcnXuuPJsNBcEY_DCV+wF0bA_umg-Ri3A@mail.gmail.com>
Subject: Request to backport commit: d54ce6158e35 ("kgdb: fix to kill
 breakpoints on initmem after boot")
To:     stable <stable@vger.kernel.org>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please help ot backport commit: d54ce6158e35 ("kgdb: fix to kill
breakpoints on initmem after boot") to stable kernels. Below are
comments from kgdb/kdb maintainer in this thread [1]:

"BTW this is not Cc:ed to stable and I do wonder if it crosses the
threshold to be considered a fix rather than a feature. Normally I
consider adding safety rails for kgdb to be a new feature but, in this
case, the problem would easily ensnare an inexperienced developer who is
doing nothing more than debugging their own driver (assuming they
correctly marked their probe function as .init) so I think this weighs
in favour of being a fix."

[1] https://lkml.org/lkml/2021/2/25/516

Regards,
Sumit
