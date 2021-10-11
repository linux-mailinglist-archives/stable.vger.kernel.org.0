Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50944295BA
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhJKRgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 13:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhJKRgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 13:36:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B130C06161C
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:34:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ec8so20983766edb.6
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqHTX+GguL8ORT9GrQ74plpa6tL1UMIQFlsWgmkB5XI=;
        b=BAgyYImIj+fKmncnitI3V1qb45GN0JjumPW4ktt5y4pNxAXW1s23bbuifN6slnK52T
         GnhczY3Abi0zADW9BXO9gMZAA5wGaAL3BekMQ9FkzI/Ua3MKWdT7eL0FNUTJsaM/Xcsc
         fzzwqfzfVH+7k0BPqI4rSEJq60sZtgIOexiR+RCggVUa8N95t69oWj1RSN/YAMSi/vev
         lttUj95EUbVssoMteOlro/LORWb9RBvvejdLT5qqMcpG5VITLckKqiClIIh6TVQ/kXDF
         ftL7su0sWNKW5Im2v4ijlKg/a0BXHFNz0gaaEW5E3o6tt5p+26qDf6M/0MIwXJQ1tbwh
         ehWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqHTX+GguL8ORT9GrQ74plpa6tL1UMIQFlsWgmkB5XI=;
        b=df5ynNH2acu+N0OJLQdR+rgk1ni4oOt/Cdq9n0BnU3fo3Hj/10N40f4IWrgw4jrqBW
         o63crNLZGfrqzZ4Uc0gr/AYPYlapHyIp/5FzpBkm40fDKYu/0U7JrM2UDarqcaGaIiWJ
         4mNQcY1WHjL1uahvu6IbWe6+lwJL9nD1fCOkqorez8HQJNd6qC1xOV4qDiuXivjtsV83
         Aac3M6VCTiBMW+kvhEWSfCRfu7OnlNWlALKAX+UhuJXxS7Kmf0tfEdtQdMnjwMHKVEDK
         2+hlBDqAGZURfgCcdn11B2VmcpWaepjHkdGU5njYKIzl5NYyddr+gOVTGGrPyNT4ln5U
         mhnA==
X-Gm-Message-State: AOAM530aMtd/82oFxrqNh/+n8WhYqhOnAgl54UVhXbX+LmZZnbTYH7Yc
        XkzFyYfafl0RkgFStvQ5tyHfGzSBLA2bTI/J97y8QhS+Npc=
X-Google-Smtp-Source: ABdhPJzFv578GkBOVYupa/L/lyb1zfZkMj67qSAoKywCTXgOTb/pcsWO8YFDzjje14H2XsLLKMvnUf98/kzQ598z7x8=
X-Received: by 2002:a17:906:7016:: with SMTP id n22mr26702622ejj.567.1633973689051;
 Mon, 11 Oct 2021 10:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134508.362906295@linuxfoundation.org> <20211011134510.897297770@linuxfoundation.org>
 <CA+G9fYshyzMVBbO9ySSYtK+oucZ4k0e4M2JcVfQ8-U26cV+7=Q@mail.gmail.com>
In-Reply-To: <CA+G9fYshyzMVBbO9ySSYtK+oucZ4k0e4M2JcVfQ8-U26cV+7=Q@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 11 Oct 2021 23:04:38 +0530
Message-ID: <CA+G9fYt4kkW4_yNJ9dBAsSPrjV+agk73NDhS0McytDQy0-rWPg@mail.gmail.com>
Subject: Re: [PATCH 5.10 73/83] powerpc/bpf: Fix BPF_MOD when imm == 1
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 at 22:59, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> stable-rc 5.4 build failed due this patch.

This is only for stable rc 5.4 build failed on powerpc.

- Naresh
