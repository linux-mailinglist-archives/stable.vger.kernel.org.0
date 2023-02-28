Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D599D6A5442
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 09:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjB1ISR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 03:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjB1ISQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 03:18:16 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687FDBB81
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:18:14 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-536cd8f6034so248367027b3.10
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LD5KPX7LVPT7ALOji1Tt20TiXcy2sKJ/9LNj91SBJig=;
        b=MjOzX8b51IkE7h+Ejr3WIRfO2MHzdszZ2VopDPBIW/lvHvcihCjikECXp5AHTHXVxF
         Y3ucbcBwobPWBSE31Xa1PbSt5extM2rnvpa7VUg43Ht/Wvl2A8BoJLOJ6J7x7LGX98YZ
         xYweDqrXXorDas1cZ4brQwwE8PQrHX+JMimZREe6jc/6H/48vBX28wtTtAealmZ1guLE
         25b+DhRV2enigRdN3uKSIJ3G0Gy9rL8guLs8MjYr0aMPxWYTgDJBIQfaEnJZidx9nTEE
         Um463Pmf94OtbeJrL7N/a/5816g3sPeYNwvBnPMDO6zCDX76YiZiKj4aFOE9JA/L1Y1X
         OlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LD5KPX7LVPT7ALOji1Tt20TiXcy2sKJ/9LNj91SBJig=;
        b=M2x4bv0e8bLNfKzV8MAGJWtK4Qo26pUhuUi4j5Kqy/rVdKAWyrx+Xf3HbcS6NPRIHD
         2g/bepp16sa2vhs8deV1voHPVIVHG2x4fXmtmmdb76yWNOEX3F2JetmG/J5TqhxdnMi7
         xMShr+rJEFy54vGgh4EQzaEpusmcdSF3YoKDSqeXdzkCziVn4ZTbm60hLCn9IzXTctT7
         hp0Tl5knhzAlBZ7Ix4Rwo+9Or9iNQ92plOGO/MuRVDzoEYkCdOlihOE3KLCyYQXJ6KMO
         PHBeoMxq0DAfNS0Bclg7U3T2GERcAHGgFPEzGefEwWcVQXrN/R3JeX5lUk9U2UMeyQTy
         WSmg==
X-Gm-Message-State: AO0yUKVi9RNF9gGPFfSOBin9RZMguGX+62OuYplYK61uUy0LLIAGvJmv
        jbaPG6qC1O575Ye5gwT4lO2c9hS+ODxM2s+ltVrREIi54m4=
X-Google-Smtp-Source: AK7set+y5FLVXs+Yn5Y205wNgJuzeERu7oWP4puNYaoJVrVgE6Nf2v3LuDfF5BldXJwgXqCpI2sP2kx73BuLcMfGZjI=
X-Received: by 2002:a81:431c:0:b0:52e:b22b:f99 with SMTP id
 q28-20020a81431c000000b0052eb22b0f99mr1120913ywa.4.1677572293484; Tue, 28 Feb
 2023 00:18:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:a309:b0:480:bd65:1f87 with HTTP; Tue, 28 Feb 2023
 00:18:12 -0800 (PST)
From:   =?UTF-8?B?546L5piK54S2?= <msl0000023508@gmail.com>
Date:   Tue, 28 Feb 2023 16:18:12 +0800
Message-ID: <CAPge7ycxEpms_wQoDoCncz743N2BfzVCZPLmbHCVTs6ZKSp=nA@mail.gmail.com>
Subject: Symbol cpu_feature_keys should be exported to all modules on powerpc
To:     stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Kevin Hao <haokexin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just like symbol 'mmu_feature_keys'[1], 'cpu_feature_keys' was referenced
indirectly by many inline functions; any GPL-incompatible modules using such
a function will be potentially broken due to 'cpu_feature_keys' being
exported as GPL-only.

For example it still breaks ZFS, see
https://github.com/openzfs/zfs/issues/14545

[1]: https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220329085709.4132729-1-haokexin@gmail.com/
