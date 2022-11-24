Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB5F6370B9
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 04:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiKXDEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 22:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXDEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 22:04:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953CEB7396
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 19:04:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g10so282093plo.11
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 19:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bcMcGUNuoMJuSs4yU8yoVpNsIaTBx96zCmeIIsDGo68=;
        b=yPb7+/K+P6R9y4XNrvde8BjXxPhUmP5TYP1hWozvBewVNwbjKqlTw2nBWw6o5a1ih0
         2/YS36mdMqQlntlgtP9Zct3q2QWcQQVBTVyICUUch/yVTQ6HEW5Tq0qix2fu7Ci5hcAP
         malPow8GUgwKDpsR9YNUOdJzCsLDXGxg0NBnbDbXNJl0rYaff7nXhJ1Kv3wdcsfK7PnE
         b4MQkApZ/o84FuFyM3+GsrlzP4Iebwye/QaTs8eGZE9Kf/dmrGpzZk7LxqxykJfl0Tua
         BgbZQffv/lJNVuMRwiH75iTUbXuBeJmrZ3tELFrGTDZQ0FABR8yBhSbBuq42VUqj/wkP
         HaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bcMcGUNuoMJuSs4yU8yoVpNsIaTBx96zCmeIIsDGo68=;
        b=AqXQVeXm4tcS3nANnpxZqz8CU9NycnKBEUstbiyiQS6/sr+beQ/9oNUQL3Trv9urSf
         YF4h3BmB68lv47V2Ys/ab8Kc5QtOAzbX9PdYVEbzYazZ6hsoENNsWn/z56Pad6Zx9AqI
         MtBFDa8W3NanGPo88i0UiyEhA7nFDOZVSPowSRlbc80OjXa3853Mb/4aEM3011kVrYay
         f0fySRFFajpp+DkIvgp3gt70pVkiTt8WJyCoHFK7H0QwQIv+RWCi7raY0g/YdehPgt0S
         KDYP156aprJmLjkAgFdJIYSPpI9ZLtLlBLrW4yl74UW3cWdRpRzD+UstMWIvD99IZpLA
         X6Jw==
X-Gm-Message-State: ANoB5pmibZ9yLJokm8+dT34aYe9ZEUrUdhBoZuezsXiA86XYB9Z39Dgw
        lnqb6KtMxzqdGlLvtth4ayD9wIZk4EIuTeSP4RNZiA==
X-Google-Smtp-Source: AA0mqf5Sti3acIR65O91VlbIeOfWaBO+XNp0ftttQVBhpZKJ5mlNWz3wC9fTxlzrC0bA44RAP1r/uPCUtYKRp9B6b2c=
X-Received: by 2002:a17:90a:c286:b0:212:2098:fd2f with SMTP id
 f6-20020a17090ac28600b002122098fd2fmr23316232pjt.162.1669259054027; Wed, 23
 Nov 2022 19:04:14 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 23 Nov 2022 21:04:02 -0600
Message-ID: <CAEUSe7-vBpHrbEy+eQrNZ_LTeqHpn2eQEr3C7cmfNYjK1YL4Ww@mail.gmail.com>
Subject: Stable backport request: tools and binutils' init_disassemble_info
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>, andres@anarazel.de,
        Alexei Starovoitov <ast@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, quentin@isovalent.com,
        Jiri Olsa <jolsa@kernel.org>, benh@debian.org,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

Would the stable maintainers please consider backporting the following
series of patches?:
https://lore.kernel.org/lkml/20220801013834.156015-1-andres@anarazel.de/

Branches where this is needed are:
* 5.4
* 5.10
* 5.15

Branch 6.0.y is fine, as this series is present there.

Failure is seen in this form:

-----8<----------8<----------8<-----
util/annotate.c: In function 'symbol__disassemble_bpf':
util/annotate.c:1739:9: error: too few arguments to function
'init_disassemble_info'
 1739 |         init_disassemble_info(&info, s,
      |         ^~~~~~~~~~~~~~~~~~~~~
In file included from util/annotate.c:1692:
/usr/include/dis-asm.h:472:13: note: declared here
  472 | extern void init_disassemble_info (struct disassemble_info
*dinfo, void *stream,
      |             ^~~~~~~~~~~~~~~~~~~~~
make[4]: *** [/builds/linux/tools/build/Makefile.build:96:
/home/tuxbuild/.cache/tuxmake/builds/1/build/util/annotate.o] Error 1
----->8---------->8---------->8-----

The 5.15 backport is almost straight-forward, with patches 7 and 8
requiring some small modifications. I could not get the 5.10 backport
to build, and for 5.4 it was even more difficult to adapt.

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
