Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9866D11EF
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 00:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjC3WHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 18:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjC3WGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 18:06:31 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7268810A90
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 15:05:08 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id j7so25407324ybg.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 15:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680213907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzddXLXJjSyzgiqqrfc07wYuiUqaQpQxMzV0ISmZ5CY=;
        b=BlsOPvgCcRPuNplixoOzNefefr5iOIGQXn5vH3JgDRv+5UcO/1zU+fIySlhX6KRQlb
         WGPRpFgF4zXNs3j/nL5k3NVDVimRmnwUp651JvBWoULGdX8g7He7wLSBdi9XeLX0SKy7
         ElA8B7QLMnGpnLTm3q3gaWBIUy1stHDXwX/TZ5aJ8HsNMwp9lcfQtO2REKZ5Q74tHZs8
         uvmUzsm5VgrzdttBWi8wFPBSmYbCBT/fe2dpaGpO5Q2ybDcjyw6CA5Lb+9LRkDS/Ci19
         EYU0Fd9bdiQKoA0d0I/suIggMBoRT0ch8aVhmi+ydwDB0teBnc3QSUFWqwctg9G+e/2/
         PrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680213907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzddXLXJjSyzgiqqrfc07wYuiUqaQpQxMzV0ISmZ5CY=;
        b=P5QUN8GCBhqzW/fozBfgDyO30EAEUv4uRiki5zmSjeLbC7S5h3mwSpqPIMx3lZHeCT
         zdGFTHb1m0NMUPePteaIjYR0DUG4kjJ2CNZ1akM1/rJqih6cRiTmtF3kGkOlopWl56bT
         N01v2cCN833NCTeUMLZ5yXWiISFVbE0xchIpLDvKV/aUrOOG/6NG15FJt/Plbp+BQ6sR
         MD8IdzfP3oT6nJwzoXIvIgoP87GoZFIZR91rkK1N+nzwpSexQ6ttHjBvP/Me87GOrasT
         adHk+azanWPKS22y3HsGnh+ibtsSioPYO01LDFeTpDnlqKebTSnFD2Qyq6Ambb86FtPX
         B6yw==
X-Gm-Message-State: AAQBX9fNmYFMMxKYa0ae1hzKCN60nL+PJWxmE36Fgjr88vm1MXIJOGdF
        NFGPsqYDGxWu+cMgC9inZjl+t08TjCdn7ZFENZ6BGvBH9qdwPhdW8gjWAvTi
X-Google-Smtp-Source: AKy350bi7K/KayFWX6BkRbp7QJIV0IjaFNq07lbQCsWzOgedvAa6M7+wQblqGqmIe/5f7llbk7HUReaenTiPBFhXN2k=
X-Received: by 2002:a05:6902:1083:b0:b6d:1483:bc0f with SMTP id
 v3-20020a056902108300b00b6d1483bc0fmr13721551ybu.9.1680213907537; Thu, 30 Mar
 2023 15:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <CANZXNgPN=yNchM00fn0-7nd5xs_6DEgTFng0zS96J+tGnntynQ@mail.gmail.com>
 <ZCK8Voa2AWbCUHo6@sashalap>
In-Reply-To: <ZCK8Voa2AWbCUHo6@sashalap>
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Thu, 30 Mar 2023 15:04:56 -0700
Message-ID: <CANZXNgNgYvsdD6y3QETRG-XM4ShiNGOrz9AmvnzNRL3uuLvGJQ@mail.gmail.com>
Subject: Re: 6.1 Backport Request: act_mirred: use the backlog for nested
 calls to mirred ingress
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey sorry, looks like
act_mirred-use-the-backlog-for-nested-calls-to-mirre.patch isn't
compiling correctly on 6.1. It probably should be removed. Same goes
for 5.15 and 5.10, looks like those two are running into compilation
errors on our config.

On Tue, Mar 28, 2023 at 3:07=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> On Mon, Mar 27, 2023 at 01:15:45PM -0700, Nobel Barakat wrote:
> >SUBJECT: act_mirred: use the backlog for nested calls to mirred ingress
> >COMMIT: commit ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640
> >
> >Reason for request:
> >The commit above resolves CVE-2022-4269.
>
> Queued up, thanks.
>
> --
> Thanks,
> Sasha
