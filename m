Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62E542573E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhJGQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 12:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhJGQAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 12:00:16 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CADBC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 08:58:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y15so26931017lfk.7
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 08:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y9D8Ve09aAWjj+21spNNEEpdiCF/o4uUCQG6xYqTvy0=;
        b=aJUA2s1oJfnDQydP436Ez5/VDQ0bYnvJGzTDPHsMfz50GmcIY3ivci62T5PubiH+SC
         aSGYTRD8Z1Y184KFqE6pXBWxSrDsfKQSg4DLvYciJJXanFulWp78RT/1A1GosY61yS6s
         g8wcnYosq6WcsuGkq70E0Fc1LUxahT25WV0eDwQYlobQTD8JiJQ40E2N6w9CqYP8K2k2
         qNUtNd45iPv2QmfWyOR7V0mBgyfC5U64hu8JUlVd2rJ2JHRCN9H1UQkgSGgANmSQpz6W
         u7ugPWArHwKiOfRpjg+Vp8I1JvEfoMSXELBTEIs2j5opawevkN5mjkws7dDyfJi0VW7y
         XtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y9D8Ve09aAWjj+21spNNEEpdiCF/o4uUCQG6xYqTvy0=;
        b=0fDu5xqPxFtCFQntqDnKXRcgCDivLllxrBntNFI9pGXwk1fM32Il35o6xB0qXowZWq
         OdoNHg4EzleVJ95PujhEkp4+ALIB04SeXbEJafSl0UtOTWjXNpLXnFrZGhSmwHV2rudu
         DrzWDo5BZC/A5AJqYYsIqVn5dvOT14/iujO6kuHAFP8n89gYz6IumaBQzzmU4NXBlB5E
         xp5hZziLQ8URycumazExyDrtx19Ue5bQeTL/S09H7//DTBkn3hQk4wFlqr7X6cT+B3p3
         Up+d2D0kj8b844gbnu3aZTSePV1p/BlkwCyZrdOMSRbdz6H/jtI5dipWDtXcQYvTlpZR
         11DQ==
X-Gm-Message-State: AOAM533tSEAgVyjy8cpHV04BVOZIMUiwldOt/G61S8xMGNAKJvl/rgYx
        KoN0z0wSjg90bgTxysjpIBwPmc2m1zbPmDHJOmp7Kg==
X-Google-Smtp-Source: ABdhPJwIVCwN3c3pt9nOGgs56jlMyHiqHpflHpL2mRnwDSQ7tRST2kg7sTTwKYdOc33xvDwNhwzaeoe4pnwe64kKpz0=
X-Received: by 2002:ac2:4f01:: with SMTP id k1mr5053506lfr.157.1633622300810;
 Thu, 07 Oct 2021 08:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211004125031.530773667@linuxfoundation.org> <20211004125033.335733437@linuxfoundation.org>
In-Reply-To: <20211004125033.335733437@linuxfoundation.org>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 7 Oct 2021 17:57:54 +0200
Message-ID: <CAG48ez1yJxTZJNPsxgy7FVq40MVXoc0_h4-s0gH-xfM1s2tStA@mail.gmail.com>
Subject: Re: [PATCH 4.14 54/75] af_unix: fix races in sk_peer_pid and
 sk_peer_cred accesses
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 4, 2021 at 3:00 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> [ Upstream commit 35306eb23814444bd4021f8a1c3047d3cb0c8b2b ]
>
> Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
> are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.
>
> In order to fix this issue, this patch adds a new spinlock that needs
> to be used whenever these fields are read or written.
>
> Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
> reading sk->sk_peer_pid which makes no sense, as this field
> is only possibly set by AF_UNIX sockets.
> We will have to clean this in a separate patch.
> This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
> or implementing what was truly expected.
>
> Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")

From what I can tell, this fix only went into the stable trees for
>=4.14? SO_PEERGROUPS only appeared in 4.13, but the SO_PEERCRED in
4.4 and 4.9 seems to have exactly the same UAF read as it has on the
newer kernels.
