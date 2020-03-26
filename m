Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D071942F4
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 16:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgCZPWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 11:22:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:46054 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727916AbgCZPWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 11:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585236132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1OMIcMPeDCWR0QmTQUhozd64vtRTFbHwbh1dfB8B9wI=;
        b=DN4ihMz7Hk3mwSxqWeaLLCekDU7NhHNNx+dR3ZFP0ttGKL+vHqMNfprFtJ0wUDje+WQON0
        UN5O8crJTHOQIGwpMLTy7Z3bE3oPdBOxGKH7uGcValxlcG6oPQCr8yIZt41Y9cq6IXS4fq
        oeTDlqcEEnW0ystDU2kex/ZENm1nJ1U=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16--QEzZaKsPl-UMpPOrfLh3w-1; Thu, 26 Mar 2020 11:22:10 -0400
X-MC-Unique: -QEzZaKsPl-UMpPOrfLh3w-1
Received: by mail-lf1-f71.google.com with SMTP id i2so2386231lfe.7
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 08:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1OMIcMPeDCWR0QmTQUhozd64vtRTFbHwbh1dfB8B9wI=;
        b=DKqVgW8aV6unLwWeg9rZlWKMBGwqZ7d3TWX7zhkn1wBa9Vc5BctvoQIPnP0g976XjK
         xiFqEbC0/pyXVCqPlGY+Lbh7AvvNpdb5DTvuHDZdvDUMwqgyI7b1ayzxPKsPHXywQEh3
         0781u9pT8Mt74HWAbz0uRnyNY6KuEXitqhlQDlzj4YenwMkfihXc+7epF0SJSj8KIBCo
         e/Awxz954n+1LIMQaTPjjKOUccaUcp49ITsi5pRj6XAM71C02T/WKodygRKRb2oEDbPO
         GTfsMbvipY1xmhrt9v6FeqMrEDqB869ilv7j2FdnV7z5U1lvjMBwtgc0971GNkCt6pvV
         xyxw==
X-Gm-Message-State: ANhLgQ2DDOgatlTLGVrhGsdIHBD/FEaMQBfCx4kKaoJqFvP3Py3YE2Wa
        D8SxKm8DTK4qmM4urlSw+brTS3Jb8GkpIFfbJ+6W79kQJcpHtTtmAcBnYeos11MLzzNY91IwmTy
        /LUrMumaBJSoushEk
X-Received: by 2002:a2e:a419:: with SMTP id p25mr5230170ljn.206.1585236127856;
        Thu, 26 Mar 2020 08:22:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypK11efxdwb2eIBAeY1MOLiicdmNzgdTE4XHq5atqlpwmuwG1bzOyWRVyAKcXuXtG2viX7Aw1Q==
X-Received: by 2002:a2e:a419:: with SMTP id p25mr5230151ljn.206.1585236127518;
        Thu, 26 Mar 2020 08:22:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n17sm1639989ljc.76.2020.03.26.08.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:22:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 958F918158B; Thu, 26 Mar 2020 16:22:04 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: mark station unauthorized before key removal
In-Reply-To: <20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid>
References: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid> <20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Mar 2020 16:22:04 +0100
Message-ID: <87369vnntv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> If a station is still marked as authorized, mark it as no longer
> so before removing its keys. This allows frames transmitted to it
> to be rejected, providing additional protection against leaking
> plain text data during the disconnection flow.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

