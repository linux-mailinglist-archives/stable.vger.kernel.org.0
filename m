Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57A055E351
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiF0Hk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiF0HkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 03:40:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155A760EE
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 00:40:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so2244411pjj.3
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 00:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fIZEfghQ0ii9WVrTC+9goUA3aEqJlpVFlfTVAuEsAds=;
        b=CST2Zy2qdHkXtYM4GDgK2Gj3JguNMlsCfXmBYGSPIOf75G0icxz/JQhHSc4OHiiNnv
         l3bSXZVjW2ly6UZdOXlb0cN0Kn2fXq1T3gzXbReArJNhXJQi1IJMhxZdOLioh3+bIvDi
         Fu3Xd5VTQZqfXXrK8M6DMflgimCcdb2PIWlVDBkeWI0vGt0w51cPlFnLiejJ9N2NgdL5
         PrnxYIusRwgQhAVBvC4YhF9BvQj7Xt/9Fz/EVC0vAzkyAFE4Z/kjH1OTNVpg12dDZJzH
         XvV/bktXZNuBInZk9i22oVMp9FHc7zE/49fOQvCf5HupfHiyzWKEAKUueUTmWGAs5+4A
         FH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fIZEfghQ0ii9WVrTC+9goUA3aEqJlpVFlfTVAuEsAds=;
        b=hzBScx0fkNflkH7ZHCJK5jN19hKoX7uz8R5lH9ORedMqobgVvCe4ECGn1+XEX5yegu
         NUUe7cbOnihAkb3k/bt2msX62APZ64UTk1wU9ZObWFI6Ejo1AgeiZbLEz83oYID3w8rJ
         h+W/Nu/utvwbdpg1DA3lBz8GYrvWJjJp0wL7PeYXOW42z2St1cfTHTo90WKiZPld2K7R
         JGIqB/Yz8gTiikwq8iNCJA6vWSIrksH9qPOLg91dQ/XP6se49Qv/R04a2xbF2wMuJZld
         h2IHXkkH29ZsenyaxVCDE6UDCbmmQwjiCgQYkxfw7IRrYzRdEHnb5nZyK3VPTdsBQI2K
         YQXQ==
X-Gm-Message-State: AJIora9I0zs1jbPoABvo8DWcCBevB0aoqLMK9jtOxwFzC6GfmHL3orrk
        YKQrRsfc5clrUiK9xLRGM4dZg11h+r9mEg==
X-Google-Smtp-Source: AGRyM1s1+68WoTobpy+Afdx7DOsNlQ7em61trM7uxqqg+unrOQh3XZghM4LxMrigBDDNxQRigixaag==
X-Received: by 2002:a17:902:f552:b0:16a:a17:a9bd with SMTP id h18-20020a170902f55200b0016a0a17a9bdmr13569383plf.97.1656315622517;
        Mon, 27 Jun 2022 00:40:22 -0700 (PDT)
Received: from desktop-hypoxic.kamiya.io ([42.120.103.58])
        by smtp.gmail.com with ESMTPSA id l10-20020a17090a660a00b001ec7c8919f0sm8556049pjj.23.2022.06.27.00.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:40:21 -0700 (PDT)
From:   Yangxi Xiang <xyangxi5@gmail.com>
To:     arnd@arndb.de
Cc:     stable@vger.kernel.org, xyangxi5@gmail.com
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
Date:   Mon, 27 Jun 2022 15:40:18 +0800
Message-Id: <20220627074018.19181-1-xyangxi5@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAK8P3a1L+_-qVEsOfoHgJ=3dg+cXLHQiWLC7HmQV07Ds8C8ZXA@mail.gmail.com>
References: <CAK8P3a1L+_-qVEsOfoHgJ=3dg+cXLHQiWLC7HmQV07Ds8C8ZXA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I also noticed that it was removed in commit 98b861a30431. I did see
this problem in kernel 5.1 and this problem remains in
architectures without selecting config GENERIC_STRNCPY_FROM_USER.

Yangxi Xiang

