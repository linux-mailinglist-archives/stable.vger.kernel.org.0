Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A463B1EC3
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWQih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 12:38:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229889AbhFWQig (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 12:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624466177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mcpQ5NPR2YFFd7daoqcO78pFvQVEgMzcMJsDe0rwIw=;
        b=OsFrNB82DPKilf4AVh5xw6gLYonKjHBsZ6ymvQcVAnbTzhW2pZYP4HOIrUFSXrXVTFs5zk
        Qwr4inW8qXoOAVS2JfT3Evw7xWMMX1U2pb/LOUygReL5XTOnF2i0/51zlM7jlmmGTkX265
        XEyjrLZWcoB6VWteFi3D0i3XmX2STsA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-JYhxaUC-M9eKhb_BwUTnHg-1; Wed, 23 Jun 2021 12:36:15 -0400
X-MC-Unique: JYhxaUC-M9eKhb_BwUTnHg-1
Received: by mail-wr1-f70.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso1256244wrh.12
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 09:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+mcpQ5NPR2YFFd7daoqcO78pFvQVEgMzcMJsDe0rwIw=;
        b=lotH29Q0Dbn/AKDaHTCEVb7WE1KQ2F1uwrk5LtDJWulscwjmXntr1xc7PADc02Z/Pz
         7VCeYox8g9NdoE7Gqn3LTJBwEHD/Ch9snoMlDiqO+Wzq4kYAK24BQbpMcJ+iQ33+ww1G
         SV+jKCAxSkCKP1vmtv115xQRoAmpRSJuTBn3dN2OXZ8sBREB86WqzG9TdxwkmyxHz+yj
         2oal6uaL2yW0koTTL0QrPeEKX8x8waj2W2xsgXGXz40m6RrPTOylZv3Wezx9o1/qirkV
         2G9E2RRW6ihZsePiNyWQ5aNNz62089xGQLcaBt9eDGalf8LUa2wAnfUEBkQooVmHitA8
         fxtQ==
X-Gm-Message-State: AOAM530f0F+7NZWPCy8YHw6ISFhOpZdtwzliJhdRKGXAdA0VTuLHC8i3
        ffPw+l83Vu9SRjrftBf3plffx5ABlMG+78wKhksHphIqw0fWrzkE+0NEhYPcoKGS9ZpbrHn0cTS
        XZGsDv88CHSzyqjez
X-Received: by 2002:a5d:6ac2:: with SMTP id u2mr1117839wrw.104.1624466173866;
        Wed, 23 Jun 2021 09:36:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8ahcTNyebFbGA28jWi8hR8gKO5JD6pROf40mnz5Gh2lW6cOQ7BUZJZiRnyROGJP2NMQkqhA==
X-Received: by 2002:a5d:6ac2:: with SMTP id u2mr1117828wrw.104.1624466173729;
        Wed, 23 Jun 2021 09:36:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-109-224.dyn.eolo.it. [146.241.109.224])
        by smtp.gmail.com with ESMTPSA id d3sm524054wrx.28.2021.06.23.09.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:36:13 -0700 (PDT)
Message-ID: <254a0b83518083416abdae4cd27659bc10760773.camel@redhat.com>
Subject: Re: [PATCH 5.10 038/146] mptcp: do not warn on bad input from the
 network
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Date:   Wed, 23 Jun 2021 18:36:12 +0200
In-Reply-To: <20210623142235.GA27348@amd>
References: <20210621154911.244649123@linuxfoundation.org>
         <20210621154912.589676201@linuxfoundation.org> <20210623142235.GA27348@amd>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, 2021-06-23 at 16:22 +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit 61e710227e97172355d5f150d5c78c64175d9fb2 ]
> > 
> > warn_bad_map() produces a kernel WARN on bad input coming
> > from the network. Use pr_debug() to avoid spamming the system
> > log.
> 
> So... we switched from WARN _ONCE_ to pr_debug, as many times as we
> detect the problem.
> 
> Should this be pr_debug_once?

Thank you for double checking this!

In the MPTCP code, we use pr_debug() statements as a debug tool, e.g.
when enabled, it could print per-packet info with no restriction. 

There are (a few) similar use in the plain TCP code.

pr_debug() is not supposed to be enabled on any production system,
while the WARN_ONCE could trigger automated tools for irrelevant
network noise.

I thing pr_debug() is fine here.

Cheers,

Paolo

