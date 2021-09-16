Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA8140D356
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhIPGmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 02:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhIPGmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 02:42:09 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C790AC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 23:40:49 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id q3so12777496edt.5
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 23:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=vIEOp0q6jNVjGdxWn0YRuSFxMbCS6AwgE85k1qJujDA=;
        b=lMmKSb5AIi16CfyEr+e3xjpvCqq5cBC6O4f5Q7OXdvAXACFcnzBrnPhWvpGQloItWw
         efAlgOzru4swDXERhx8PJF4WDOUnv7Dy6l5amyv8KtYex5jR9eLfv1AEiCrcKN6AnCWv
         hGHIdWXCtu+t0m+PTM7gGR3GydQHDEHU3WoW02NqV4yfTz36rqgNFQaGw5qF+abH0JfT
         2YOmGMf/LS+pyHMV3yW+kEHxTgBqknRL1LXoYGD6SPQua7cRs3ZUtH1CT40qwO1hUVs7
         3kWiuaRffYaUBG4CIafmNDZzDeO5z4O/3QyMYgmoWXcWptNq5TTay6q2IM1q+0qJCgO5
         X1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=vIEOp0q6jNVjGdxWn0YRuSFxMbCS6AwgE85k1qJujDA=;
        b=YEnNzrliH0M9lgOX4I8Lwt8QqKwztT0tgCa0dLoIHL4VccWfN1TXoGXPFneY607CXE
         C9FYX9ali9F33doCX4HGXx5/lemFAZmtqkGTS4D4HGTyk1vDofet6xr0zDz4zOLtGYfG
         P3qiyAPQ8T3rDEXunYM3/I4Q0FTrK+rWMBXc4sJeWnJjlGgrLXmswNRojoFQ371GGHgQ
         z8WPeEwGA9Al7fUnneOna5B3Qz6f2V6eQ770ysdD5nkvdun6WSzfu2DDDetDapAj2CDu
         hC3QReCEwJtYYnD7ckKa30R7hihkGZOYO/a//FhQu5TOvr86bmDRmA3wU2/oWLzFwgYn
         HzMw==
X-Gm-Message-State: AOAM530MEumOOokHW/Bpdu5W/uP+ZnhHUQnG7zIcwoc1rc5zlA3d4vK5
        PUyNkJ4lCkI3xz5IrwEFvZ1q99qvLXjeBfGeyUtm6g==
X-Google-Smtp-Source: ABdhPJyfs9eUgcaXG+Bvazw2Zd+eDxVIEyXfvuVRVthY1Ef6aFZEA88iVx8t21DXuP3LjEZI6GQf3jJYnFFoCbKi/Cs=
X-Received: by 2002:a17:907:995a:: with SMTP id kl26mr4627508ejc.6.1631774448165;
 Wed, 15 Sep 2021 23:40:48 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Sep 2021 12:10:37 +0530
Message-ID: <CA+G9fYtcsy_jaGkssSSUb5qeQehLvPF9=TgEG9kn42NKez1mOQ@mail.gmail.com>
Subject: ARM: 9109/1: oabi-compat: add epoll_pwait handler
To:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        rmk+kernel@armlinux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build warnings/ errors noticed while building stable-rc 4.14...5.14
branches with gcc-8/9/10/11 for arm architecture with axm55xx_defconfig.

# to reproduce this build locally:
tuxmake --runtime podman --target-arch arm --toolchain gcc-11
--kconfig axm55xx_defconfig


build error:
------------
arch/arm/kernel/sys_oabi-compat.c:347:2: error: #endif without #if
  347 | #endif
      |  ^~~~~
make[3]: *** [scripts/Makefile.build:271:
arch/arm/kernel/sys_oabi-compat.o] Error 1

Build config:
https://builds.tuxbuild.com/1yCGjI41IKXkLhFamMRkMmNu7ak/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: v5.14.4-74-g739800791564
    git_ref:
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc"
    git_sha: 73980079156484a4acc3b4fa06a1aaf7f7633433
    git_short_log: 739800791564 (\"Linux 5.14.5-rc1\")
    kconfig: [
        axm55xx_defconfig
    ],
    kernel_version: 5.14.5-rc1
    target_arch: arm
    toolchain: gcc-11

steps to reproduce:
https://builds.tuxbuild.com/1yCGjI41IKXkLhFamMRkMmNu7ak/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
