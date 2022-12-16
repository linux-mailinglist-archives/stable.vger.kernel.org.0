Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C6E64E66C
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 04:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLPDli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 22:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiLPDlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 22:41:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955F40466
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 19:41:36 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso7530286pjb.1
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 19:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dH2XznVlVmDf1vz9vDgxaRsKNOb8GjVSvLyuIGJXLlM=;
        b=oCpjkuGYsMNCAeB/waJy3huJxqsMJEN4j4R20qo/8ilzTjRHD1acY4anpxtOvShrPG
         gYEdBoZGGr1976oZn8VpgvX7fII1lRMO7uUga5H+SWiTmt158LtNHwAB2S3o+due1gts
         LzOpmcYj1rBeRnS2YL6PCOPZv82MtsSsuaGk15K9UBfomxlYpCM1tlj+eBMVrMYOhEAX
         JETsYsZY1DyVJ27c20/y2JR7j8FpKABIRgcrqnD2I6Dz3UxdNBRf1T5trAnMEsNyIJqf
         7V8AF4dvJQM1sgesydtgd46dSqZn/Wk+4YZkTGmv+LQXSxhpABelJK342hqq01L9zjlI
         D8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dH2XznVlVmDf1vz9vDgxaRsKNOb8GjVSvLyuIGJXLlM=;
        b=YGbLaxCAz2us/Ja2zbcSH5Tjk5JgIXy8UX/vn/LHt3GcwMFFsVFO7RYAjr8A1bF7d0
         cQI4hptO2uzyXVeAfPPJWQMpQ9CnOIXyya31/ooOCOVPUXhTY6C+YdpavGDTFWnxzlog
         JekQTq/J0OKdMcJcXSDdErf0ALL8Ijs/6i8OGS4E3AAN5r7uA6ahhLwLj0lmW+NtHk7v
         HdOS3cu9OMCXNGS1mXy8NbXCs0z8HT/iFjeWTa9XB7paNMJdOD+Vb8bHjww0t3QrwSkl
         4nlseokSK4H+AN6xVs/QzMmLXaRnKkubUWeqn5r3EmMGccvwnzW9hEKoBfJ88G560s4t
         mMxA==
X-Gm-Message-State: ANoB5plAcSHH77HLpeucJfg6FiZ6BJtqxYOOf31ny1qouBpchuFtDcG6
        M4UIsSnDXIg+YoEvzDnsg3eQ4w==
X-Google-Smtp-Source: AA0mqf5HmDu8y9ZmGnJc48OIPjQpy4kb+B08hx6gN5Hafe8ll4etZJTrL2THwt/akkNTMEbfdJWYyQ==
X-Received: by 2002:a17:90a:6685:b0:221:77b5:d678 with SMTP id m5-20020a17090a668500b0022177b5d678mr18630280pjj.10.1671162095983;
        Thu, 15 Dec 2022 19:41:35 -0800 (PST)
Received: from niej-dt-7B47.. (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id nl16-20020a17090b385000b00218f529e486sm3941937pjb.0.2022.12.15.19.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 19:41:35 -0800 (PST)
From:   Jun Nie <jun.nie@linaro.org>
To:     tytso@mit.edu, stable@vger.kernel.org
Cc:     djwong@kernel.org, jack@suse.cz, jlayton@kernel.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        xuyang2018.jy@fujitsu.com, Jun Nie <jun.nie@linaro.org>
Subject: Re: [PATCH v1] ext4: Remove deprecated noacl/nouser_xattr options
Date:   Fri, 16 Dec 2022 11:41:16 +0800
Message-Id: <20221216034116.869864-1-jun.nie@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
References: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch[1] is needed on linux-5.15.y because the panic[2] is also found on
linux-5.15.y when debugging bug[3]. Back ported patch[4] is confirmed to fix
the bug on linux-5.15.y in the latest test of page[3]. Maybe back port on more
branches is needed per patch comments.

[1]
2d544ec923dbe5 ("ext4: remove deprecated noacl/nouser_xattr options")

[2]
https://syzkaller.appspot.com/text?tag=CrashLog&x=171b1077880000

[3]
https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08

[4]
https://syzkaller.appspot.com/text?tag=Patch&x=1766eb13880000

Regards,
Jun
