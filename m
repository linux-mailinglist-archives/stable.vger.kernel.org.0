Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED24537EFA3
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbhELXOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:14:55 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:44873 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347132AbhELXE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 19:04:29 -0400
Received: by mail-qt1-f171.google.com with SMTP id y12so18517726qtx.11
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=at/x4ujhwBb1I6B7G6zS733wEZ3y6hgxqlYHDG2px5w=;
        b=gQHe3526W2tASXKpSb+yTiDjDdDANXXJwrni7yUZq6sPCD9eaZjt5SIl1qmOn/OU47
         KwMn6tUmfZ57HsXe6klsIgm3qKq6RB3e/9h9QamtRzs9XCq86FyP/elRXhQLWhHZZ1cm
         5wOjQeunf5Qh9otYXCIkSThz8W/vXq9sRck80ak6Nm2bQdiTW07VtXBmbt7DVtrEFgLG
         LNvBfazZQs4W0EWddkqNljZMvDzy5oFhS8T4kpn1ZCC4ir0Ny9l5hKf92zqd7aBSLMbC
         JD/uB9G/kjTmEBM3POfvBINcqeuu3BO2l3nSF1c/5SllL/ocLpD1ita7sel6C/9ECiz6
         vlGg==
X-Gm-Message-State: AOAM531j8/9mpZIFnAIf4hfEajRYtwzzplBb0u5roxp7tA8zmUrSOJPQ
        mxx5qpSab8CrrdMIuguFcQDtXcozQrQ=
X-Google-Smtp-Source: ABdhPJwISQYtEBFYD9TUIlTrkxkUSMiWwD9x7V7Qxf3i8qy9qQ+Qc+LgDt/+hTcIBUX4Gj22i+5gwQ==
X-Received: by 2002:ac8:4750:: with SMTP id k16mr18773465qtp.13.1620860595226;
        Wed, 12 May 2021 16:03:15 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:c65a:d038:3389:f848? ([2600:1700:65a0:78e0:c65a:d038:3389:f848])
        by smtp.gmail.com with ESMTPSA id q2sm1225616qkj.63.2021.05.12.16.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 16:03:14 -0700 (PDT)
Subject: Re: [PATCH] nvme-fc: clear q_live at beginning of association
 teardown
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <20210511045635.12494-1-jsmart2021@gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <601fa5a1-e52b-edf1-f32e-b1c454e23758@grimberg.me>
Date:   Wed, 12 May 2021 16:03:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210511045635.12494-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> The __nvmf_check_ready() routine used to bounce all filesystem io if
> the controller state isn't LIVE. However, a later patch changed the
> logic so that it rejection ends up being based on the Q live check.
> The fc transport has a slightly different sequence from rdma and tcp
> for shutting down queues/marking them non-live. FC marks its queue
> non-live after aborting all ios and waiting for their termination,
> leaving a rather large window for filesystem io to continue to hit the
> transport. Unfortunately this resulted in filesystem io or applications
> seeing I/O errors.
> 
> Change the fc transport to mark the queues non-live at the first
> sign of teardown for the association (when i/o is initially terminated).

Sounds like the correct behavior to me, what is the motivation for doing
that only after all I/O was aborted?

And,
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
