Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B2968B453
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 04:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBFDIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 22:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFDIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 22:08:54 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E9A1A4AB;
        Sun,  5 Feb 2023 19:08:53 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id be8so10757055plb.7;
        Sun, 05 Feb 2023 19:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RMxC7x6L+WxwPVlPfl0tkAj5/BL2kNspBRHg3VwU1s4=;
        b=lDsMVLElVzpgoQN2srpKFeAQ+Krxozmbt3yUeP795SjPMi1RBTSKenSwoiYI0J1Tfi
         9a9TkhbVOZll+Ta5OMqnKi6Vtwv6eFT5hQqZXtID2UPaHoRAWxUs/rjKROq6xR31nnF2
         WFVBSZ82Apvhi3SovoGAihZOl3axIHONu6Rs6MIRmIjt1BgVrzxtINQqt09K2nFEBXSo
         ucuYhn17IUUKCrciVp0S/FOgi093ysYyMcWowvjODqSz8hA45kGeG5d8seh/Cx3SToHp
         NK+U7hW9GzA8z6fBDV58I0uZSUZkFk30kUZ847eSFeEWq3e/2HICS1jN+u4lkCxcjr59
         W9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RMxC7x6L+WxwPVlPfl0tkAj5/BL2kNspBRHg3VwU1s4=;
        b=s1K8hiCEWK1bsg15MVyorxEcknN6VY3uLo9axBZhmf7RnQnuUBxbyzt8h1OV3eBNGS
         ZhDWTWIuAk4FA/vBmGX6yzQ+aWdP8YRjLVWTcNLLDCxUT72e+dp9jUdsgrRm4qxAL8EB
         eg6NNuvFQoQ8fweRgE3CTaakoi4+Gl+lQq9eycrOPeTvRlYibMP5V3w6jYfVWFUUfhDB
         FDnpFyZ37RvvuFdBeSaYiLdidMktRrkQ0X0RjFS7GfRxxVMvvcfVb7TjLamEOH3GdFsd
         onp4rj+Dewc4/9lb/mkZDNZvBE1AZ9K5Us3GBWSjI9+Hx7J0dY3IJXwRKe0A0lvj9oG5
         NEFQ==
X-Gm-Message-State: AO0yUKVwCPq5uam1YMGnx4nZz5jfkf+mooSMmjFWcOvRX6fiCT+YjycQ
        SAkacyPN2pDSiEghh1Vf9+WU1rpHeMJquhogyxS3kh6rJqyoQjvd
X-Google-Smtp-Source: AK7set+1wu7zoy1JvaMxzaETcw7kTPscDTbapABdZWHZ56N8YzxsPrefpTrPqrqhDo/LALllQQ5oJKlDPMgetJAfaLI=
X-Received: by 2002:a17:90b:e0d:b0:22b:fca9:4749 with SMTP id
 ge13-20020a17090b0e0d00b0022bfca94749mr2497792pjb.0.1675652932772; Sun, 05
 Feb 2023 19:08:52 -0800 (PST)
MIME-Version: 1.0
From:   Xinghui Li <korantwork@gmail.com>
Date:   Mon, 6 Feb 2023 11:09:48 +0800
Message-ID: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
Subject: [bug report]warning about entry_64.S from objtool in v5.4 LTS
To:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all
We found a warning from objtool:
arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1d1:
unsupported intra-function call

and if we enable retpoline in config:
arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1c1:
unsupported intra-function call
arch/x86/entry/entry_64.o: warning: objtool: If this is a retpoline,
please patch it in with alternatives and annotate it with
ANNOTATE_NOSPEC_ALTERNATIVE.

I found this issue has been introduced since =E2=80=9Cx86/speculation: Chan=
ge
FILL_RETURN_BUFFER to work with objtool( commit 8afd1c7da2)=E2=80=9Dbackpor=
ted
in v5.4.217.
Comparing with the upstream version(commit 089dd8e53):
There is no =E2=80=9CANNOTATE_INTRA_FUNCTION_CALL=E2=80=9D in v5.4 for miss=
ing
dependency patch. When the =E2=80=9CANNOTATE_NOSPEC_ALTERNATIVE=E2=80=9D is=
 removed,
this issue just occurs.

I tried to backport =E2=80=9CANNOTATE_INTRA_FUNCTION_CALL=E2=80=9Dand its d=
ependency
patchs in v5.4, but I met the CFA miss match issue from objtool.
So, please help check this issue in v5.4 LTS version.
