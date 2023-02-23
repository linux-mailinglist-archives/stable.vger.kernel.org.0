Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1866A0FAA
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 19:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjBWSri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 13:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBWSr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 13:47:26 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC508158B9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 10:47:17 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-536e10ae021so171307777b3.7
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 10:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WjA32Jpx57cVd32SZNOzuTDW+6o0QlN93xjAZYLFqW8=;
        b=Et512GEBd/i+QztxG9BP68ZUka2FWMV/oMXCyp7HLAZl0+O3To3Kp2C3Puqw4RxUfs
         ne7x2wh5uEYAwuDQiCtjd4+7+PfwDf7yJZAoyko3kPff+eukaUMR+DNt7sl/v0qOiN3D
         D8vE3rHELk9k8etzpnjAuzvIqxC2qlcWLklCP5QAxYar8obSgaOTHY/zjBEIY7b6cTOh
         zaq55yCvEsz0gS/dJrlKPs3o0iyom5iocEQ+RYzTiCWzf/rFWxLGchBy4nxhHQPQsDQ7
         Skog1g8yfBFBOUiepq3XKDbO8FtV/rl9wMPaD5RQ8c9xJsQOvI44c6el6QOP5vttPaMU
         EltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjA32Jpx57cVd32SZNOzuTDW+6o0QlN93xjAZYLFqW8=;
        b=2XqVN73EkMb71fooGYiXgkQuNnocyUugH38T+oxz0Au+v6xnwI16U0EmK7WocRP0Ln
         tE0qY6cwLju1B0K2B73HDXtd2WKDYv1A78SnrLOsA//Fupyo89j4jgDeUQF4TYxI2nvc
         WXWlWq70EVenTk99lhiYPddU6xM/ALFzzTMGuLruKskcai1Ics7w4rPmqmnNxVlhjBFR
         LwJj3/hfp8c2LSPTyniG7GEIO2HUC9pw14fpvOw3082kWGJOOX8Xcbsb7uJd0nM8nDcJ
         KtSQK1f/aVki/ONMtrUq/ZHq8kog8sbqtTYbYo0ZwVd+060HjAV8CGzQG5bQPiC56t8f
         RZgA==
X-Gm-Message-State: AO0yUKXtkTMXqmepNxV9uXMsgy16dF7y9MLp4sRv2AZbX6nzjlmfuf1g
        YVquq4x7BzE/WNt6TPKvHudvNcST6LRa5Tb1g9dCEQ==
X-Google-Smtp-Source: AK7set98S9Wal9BCX+UN2eVq/NYxQWlplu7di3H8NX1Jc9j4OW0mPv3/2yhgLX+OIKLyZr60rmWfEOsxoQfG80GcRqo=
X-Received: by 2002:a5b:907:0:b0:932:8dcd:3a13 with SMTP id
 a7-20020a5b0907000000b009328dcd3a13mr2538488ybq.5.1677178036613; Thu, 23 Feb
 2023 10:47:16 -0800 (PST)
MIME-Version: 1.0
References: <20230222192925.1778183-1-edliaw@google.com> <20230222192925.1778183-2-edliaw@google.com>
 <Y/crdG+quVvKMF0m@kroah.com>
In-Reply-To: <Y/crdG+quVvKMF0m@kroah.com>
From:   Edward Liaw <edliaw@google.com>
Date:   Thu, 23 Feb 2023 10:46:50 -0800
Message-ID: <CAG4es9Wa+PxomxmK348O8nxfXny8jo=9kqQ0KOYgQq82gTNeaQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter on div/mod
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        kernel-team <kernel-team@android.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> What is the git commit id in Linus's tree of this commit?

Hi Greg,
It is a partial revert of 144cd91c4c2bced6eb8a7e25e590f6618a11e854.

Thanks,
Edward
