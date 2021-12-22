Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C42847CA45
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhLVAc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 19:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhLVAc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 19:32:26 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E809C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 16:32:26 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id p8so1005535ljo.5
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 16:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7xcE93SQUTnmpprWNNrn4RnRomw6varxCO+eWG92cmo=;
        b=lmhKgJQu05WCKShkgxDOsnJSAglx5hzJxv7qyXZ4Tm7pQYz4+yeOpG80ZLArYxBmUY
         ne4ldsh61991ts1XU68fuBrm3GN4LVFapTCIZv06MJihkZLfXn9dbdqWbUUjlfH4euOW
         UtVDi0xkPxHV8V3z9uFgTWH1UdG/GmkT+fxp7BT1a8noXHRY3W2a+QFpec3R9xJQ+pS2
         wQ7CF9YP8H92Wv60P8pK5zIIUYclRTQGKi1VXqAWKvb/Ct28iDmiDrJpSF1Omswsm57N
         n88g9bRTRN83+PNKHdn2oat1PQE1p4KYi92RY5zqE8M+W1re4FUz6TedObimILzA7+C7
         KiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7xcE93SQUTnmpprWNNrn4RnRomw6varxCO+eWG92cmo=;
        b=4IYl5Lu+kSVYzPV9FhgWkoFaD/sVDQG/o8LNKnKHP+FiDlD5luuV5thVJ9kJSjaDzc
         9v92qSpwokAMkytAKuiVbt+kwEruRy2a3U0INGQyVGy2DedDd9FbyoRZ+JFpc/V9H0Xx
         4yPr66S0VCbAFo5aRVHpUlTjGd5mrI9BOu1pqJEwV45st4uV7QlJSGP+qdcKqBMAJUDB
         HF0twpbmFwg2AR4UDutTzcE58YI4vg6YuTphB8yyONLecyZXarerg7r+x2Gzr7a5IjHD
         n+DDB10mLmZz1VCrXno7OTy+zDaFyO3gGJ5QEJ4736BS8+ik/8XLyreczSfKkVh2C+VZ
         H42w==
X-Gm-Message-State: AOAM531BnIop1vJcbv/vZ4MvxPq1dHwlPMw5sZMs8xnAXZWj4BIqSpyd
        3k1iCam9zQzYkFC5l5Ydtaxo7SccAb/tXKUpkRoQ9Q==
X-Google-Smtp-Source: ABdhPJx3iJnHCsyoWnKA49ZPV189cBeO62N/fdKwG5AlxTJ7ZmS4LzxQHLqVDQMicic51FyA7eCfJlBZTkljL8LNg30=
X-Received: by 2002:a2e:141c:: with SMTP id u28mr570364ljd.338.1640133143982;
 Tue, 21 Dec 2021 16:32:23 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 21 Dec 2021 16:32:12 -0800
Message-ID: <CAKwvOd=3ZSuiLxWbRWicTWF2WX4biS=-+EEXbSJiuLEborbD6w@mail.gmail.com>
Subject: CROSS_COMPILE_COMPAT cherry picks for linux-5.10.y and linux-5.15.y
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,

Please consider cherry-picking to linux-5.15.y:

commit 3e6f8d1fa184 ("arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd")

Please also consider cherry-picking to linux-5.10.y:

commit ef94340583ee ("arm64: vdso32: drop -no-integrated-as flag")
commit 3e6f8d1fa184 ("arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd")

They landed in v5.13-rc1 and v5.16-rc1 respectively.

They allow the command line for building the arm64 compat vdso to be
shortened by dropping the need for CROSS_COMPILE_COMPAT for LLVM=1
(and LLVM_IAS=1) builds.

linux-5.15.y:
from:
$ ARCH=arm64 CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make LLVM=1 -j72
to:
$ ARCH=arm64 make LLVM=1 -j72

linux-5.10.y:
from:
$ ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make LLVM=1 LLVM_IAS=1 -j72
to
$ ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make LLVM=1 LLVM_IAS=1 -j72

This can be verified with the above by checking .config for
CONFIG_COMPAT_VDSO=y after running defconfig or building
arch/arm64/kernel/vdso32/.

I also verified these build with clang-10, which was the minimum
supported release of clang for linux-5.10.y and linux-5.15.y
(Documentation/process/changes.rst).
--
Thanks,
~Nick Desaulniers
