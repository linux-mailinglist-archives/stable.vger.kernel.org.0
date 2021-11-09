Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5875444B1DD
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 18:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbhKIRWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 12:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbhKIRWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 12:22:48 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8820EC061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 09:20:02 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id w29so22698236wra.12
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 09:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=OLzo0EOB1taa2CSck10pmNDW2WkMN2hcPFxNpgrSaIc=;
        b=Bxea1HiHsP+QYszwm/LNY0fuSii2ItA48GCqeDbd354Y9j3WwIJV2wvsgUJAxdyrom
         TP66ORGLW87mBYQbr6Me5HfWFF0d7fJz/BUMdPCphVnDpIzuYX9Dk9hMjeb/FBzpsimh
         JA4BH3OR4b5sAx1syQsCYvCOW7o80m7fGy7cRTTAbz5aE9nguLOdYTpSvI+IWh+m42K9
         l5HC7lZwF48sZ4g/nTDDFE65orqgVJyU9vVPpULdA3mzUSJUxjizO7byNf6J8E4nFRFP
         ig4WR0cxhypBlnO6lp7ogmNYMLYU4dLqVCsEZK7eR4iXDZiFPiCUwgOErKvtF+leSCNA
         ESOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OLzo0EOB1taa2CSck10pmNDW2WkMN2hcPFxNpgrSaIc=;
        b=Vap3sakjNQjBXN/H6BPBhjeGwy+lcTUSb5aZirJiHmhWX05jLq6T8cNouMfyyGLB+T
         rnd7feThcG3xzb5k/jeF5XSRemZpJ5NFIq0htfa+Bi1nXjlxqjnxVj8dFLFrr4Nufd/v
         LYWQcr5jNFxBpF71EUDCJiZRV93CcK2vlEFWDZrk35PWcAb0LXjJ2m/Pf4BmoJbY0zjt
         w2GdmUwJrxr+zFlaex31OgJ+lhCg2EWta1bVgvMtWlsr1+wOLZvCbNmQU+RsI6sEhHFq
         O5RcETpYgxbKeC2UJnhewvBa9aBKlET2dRCV66ythZHDWPO3LpwVqeD/9KVKN436Rm47
         MuJg==
X-Gm-Message-State: AOAM531brUEXMM0/g2amD692YHpMgtceFEM4ukns1r42rgzNBKDDC5ls
        f1E+WCH13gFzN1lNyQUQRYjYQNLa9k/jrw==
X-Google-Smtp-Source: ABdhPJz85A8JR0o9AyrgDiJomcrg+pZOBBcTWifgQF+E/BDamxTpy3X5s7QBZDOXWTJRY5Cqa5TQ+w==
X-Received: by 2002:a05:6000:15c7:: with SMTP id y7mr11588170wry.424.1636478400645;
        Tue, 09 Nov 2021 09:20:00 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:d20d:9fab:cbe:339])
        by smtp.gmail.com with ESMTPSA id w15sm20755359wrk.77.2021.11.09.09.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 09:20:00 -0800 (PST)
Date:   Tue, 9 Nov 2021 18:19:54 +0100
From:   Marco Elver <elver@google.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Alexander Potapenko <glider@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: [5.15.y] kfence: default to dynamic branch instead of static keys
 mode
Message-ID: <YYqtuk4r2F9Pal+4@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,

We propose picking the following 2 patches to 5.15.y:

	07e8481d3c38 kfence: always use static branches to guard kfence_alloc()
	4f612ed3f748 kfence: default to dynamic branch instead of static keys mode

, which had not been marked for stable initially, but upon re-evaluation
conclude that it will also avoid various unexpected behaviours [1], [2]
as the use of frequently-switched static keys (at least on x86) is more
trouble than it's worth.

[1] https://lkml.kernel.org/r/CANpmjNOw--ZNyhmn-GjuqU+aH5T98HMmBoCM4z=JFvajC913Qg@mail.gmail.com
[2] https://patchwork.kernel.org/project/linux-acpi/patch/2618833.mvXUDI8C0e@kreacher/

While optional, we recommend 07e8481d3c38 as well, as it avoids the
dynamic branch, now the default, if kfence is disabled at boot.

The main thing is to make the default less troublesome and be more
conservative. Those choosing to enable CONFIG_KFENCE_STATIC_KEYS can
still do so, but requires a deliberate opt-in via a config change.

Many thanks,
-- Marco
