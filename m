Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AA72B70B0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 22:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgKQVJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 16:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgKQVJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 16:09:23 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9817AC0613CF
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 13:09:23 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id g7so18156575pfc.2
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 13:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hisjjNtZoO7NOVuGAk1qUZr/IgvJJn18Uj0ZEIcow+Y=;
        b=MxpWns22cbB20JMiTDCrtAXIpvCTxjwziLw3tNk1Yg3NtENesu0G9MWtLZH6Qyt+Fj
         Kz66VrSUHiIieW/Xmo1DmRs5sJuzE4e4p68gc4ek1434QtU+etEvdZov3QFPNsb7xubf
         MlSfiYZ4UG+0fweUxlJgU5n3JHTVBGaueDhRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hisjjNtZoO7NOVuGAk1qUZr/IgvJJn18Uj0ZEIcow+Y=;
        b=rMzVSSn/mGEhotYFVoq4ku6CJgLDGl7aZ6rt+r826OsUsNN41udtrrhKYwryGYzzZc
         4lrb6lQipWp69qZCjfw8VDHEl2sV9Gp3dJVB3SdwCdMP0VdARZJPqM1ATJsDSiL0LPjd
         PquSOexoTQp6rAp7tNASQe7wYia6kqKLasF3YVrHwPytv0f5O9EihOSuPGsHtzuwfG/q
         /Hxk5sBD1S+ynxTik8HrTugR/fxKlo13yklqR1rrxQhgHbTdtkGIyCD1y7l9Llj6ZbUE
         wEEcfY7lylChoDKeEZUiLdLNqHy4OUtHAr/X5Q+bXGLUlDf4UArpcwEREgPz3zOBTE4F
         nSfQ==
X-Gm-Message-State: AOAM533SYDcNJHmV11UD5IE/5+WjpHyo70fJnpB3/AAPKhrkA6GRbh1+
        ZRpvq1r+Kp66NGnbONfNWhHvPg==
X-Google-Smtp-Source: ABdhPJyFe5P3cl72SKMo4dGnUuYR7nTvkbg6k+Yb1NSUXm/UvTBg4X0ngL39se9S4oxlNiBIqe9U2Q==
X-Received: by 2002:a63:2107:: with SMTP id h7mr4939574pgh.157.1605647363148;
        Tue, 17 Nov 2020 13:09:23 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id mp16sm4255459pjb.13.2020.11.17.13.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 13:09:22 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Oleg Nesterov <oleg@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Cc:     Kees Cook <keescook@chromium.org>, Eric Paris <eparis@redhat.com>,
        Will Drewry <wad@chromium.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, stable@vger.kernel.org,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] Fix misuse of security_capable()
Date:   Tue, 17 Nov 2020 13:08:45 -0800
Message-Id: <160564731624.1001615.8892910904546455542.b4-ty@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030123849.770769-1-mic@digikod.net>
References: <20201030123849.770769-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Oct 2020 13:38:47 +0100, Mickaël Salaün wrote:
> This series replaces all the use of security_capable(current_cred(),
> ...) with ns_capable{,_noaudit}() which set PF_SUPERPRIV.
> 
> This initially come from a review of Landlock by Jann Horn:
> https://lore.kernel.org/lkml/CAG48ez1FQVkt78129WozBwFbVhAPyAr9oJAHFHAbbNxEBr9h1g@mail.gmail.com/
> 
> Mickaël Salaün (2):
>   ptrace: Set PF_SUPERPRIV when checking capability
>   seccomp: Set PF_SUPERPRIV when checking capability
> 
> [...]

Applied to for-linus/seccomp, thanks!

[1/2] ptrace: Set PF_SUPERPRIV when checking capability
      https://git.kernel.org/kees/c/cf23705244c9
[2/2] seccomp: Set PF_SUPERPRIV when checking capability
      https://git.kernel.org/kees/c/fb14528e4436

-- 
Kees Cook

