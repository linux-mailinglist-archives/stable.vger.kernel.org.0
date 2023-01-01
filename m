Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C9765AA27
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 15:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjAAOPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 09:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjAAOPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 09:15:45 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B253C53
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 06:15:44 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id i188so26154568vsi.8
        for <stable@vger.kernel.org>; Sun, 01 Jan 2023 06:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BuFZ44C0YwmT4jbmclaWDxvon1oy7DdQSZfYjsKH4cQ=;
        b=N/kMHF5WTq1tgq6B6XOEexI/55/xBznFtAd9XO0WI7UFrpGg5jrceQTb4WWWvkgq1J
         3jm1ENfR8nC+z0+2ne3yaBWnozUf1UwIyA5wttlGrhpzYeP407LzjxzXi/nP4L2vgZF7
         QKqIviE0B9miQXRUhXy89dN4RxHx6Bb1fAKT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuFZ44C0YwmT4jbmclaWDxvon1oy7DdQSZfYjsKH4cQ=;
        b=o8JGOxCib6AO3xwXS14EfZG/tlc1wDcADmn3AOSnFogYW4uNx6sZwctr7dWyd6k3Sn
         Fq7BiIY5W5Cn3aLo1sTHcbR+TZjVsJbQHLK5ENcpMcg4irElydoEd8WZZM3XOe6Lh3pc
         TXykFrGacG/tBdRa++cWmJLI2j7ScmS7eGKLuv53pkawX5rSCN/OeTYDC2KodVWxByXX
         xNCBtzw6fV+wthAN77DPEOudVNHcbcPoSRlF12CwIJbP8B95omAi23mG+WNzLlqAcpmu
         +g5zmmhNjJ70SeXhx8p5XLyfTStvRq+xqoronfUQZncbsGyY9eAwhLT9F5QNbPj9xH1o
         L9Ag==
X-Gm-Message-State: AFqh2kpZgzHbIvnETxu3xvxXKY/UNkD/ZJem4ozX2/F76/1Rm7T1ELIi
        ge0LnnMiLSeEfJ+BUSvXAtY93w==
X-Google-Smtp-Source: AMrXdXsbE1ujfH3UvrOCh00ab4c+8GIQ8cVkAOHEyemQY3k8lu28j2I94hTI3D8EXeSJ7XVxY0VDFQ==
X-Received: by 2002:a05:6102:3138:b0:3cd:b27:ed75 with SMTP id f24-20020a056102313800b003cd0b27ed75mr3121359vsh.10.1672582543570;
        Sun, 01 Jan 2023 06:15:43 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id c15-20020ae9ed0f000000b006ff8a122a1asm18504012qkg.78.2023.01.01.06.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 06:15:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Date:   Sun, 1 Jan 2023 09:15:31 -0500
Message-Id: <6630F427-88C6-4DEE-B069-35B81835E387@joelfernandes.org>
References: <Y7FI71mW7ZJZDiTI@kroah.com>
Cc:     linux-kernel@vger.kernel.org, Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Josh Triplett <josh@joshtriplett.org>
In-Reply-To: <Y7FI71mW7ZJZDiTI@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 1, 2023, at 3:48 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> =EF=BB=BFOn Sun, Jan 01, 2023 at 01:20:01AM -0500, Joel Fernandes wrote:
>> On Sun, Jan 1, 2023 at 1:16 AM Joel Fernandes (Google)
>>> Cc: Paul McKenney <paulmck@kernel.org>
>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
>>> Cc: <stable@vger.kernel.org> # 6.0.x
>>=20
>> Question for stable maintainers:
>> This patch is for mainline and 6.0 stable. However, it should also go
>> to 6.1 stable. How do we tag it to do that? I did not know how to tag
>> 2 stable versions. I guess the above implies > 6.0 ?
>=20
> The above implies 6.0 and newer already which included 6.1, so all is
> good.

Thanks a lot for clarification,

 - Joel=20


>=20
