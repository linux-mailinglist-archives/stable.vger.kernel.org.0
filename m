Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C424A4CF4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350196AbiAaRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350146AbiAaRRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 12:17:34 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17649C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 09:17:34 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id q11so3825808ild.11
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 09:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbuki-mvuki-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7FMF5d4y464/mBG+xgnW5AJzOcYV63lfjmbJHbKUYyU=;
        b=UwueWjOowGG9RoghSXrun46QDMCi3GoMJyAPkybLGed7comdsxsY2etq9o4kWeqD8d
         QcriPVfGnMdYOqKYOaXkcRniAdGl/FhQpc5KnXkVbJXNnx4yQFi7068Jzvsy+OdY0Yj/
         ZFa64V3MwcoXR0Lm56ebc6+zMkmyeAdIldQB2jCzB3kdOBuDKzgCQaiRr9doj23/n/Jc
         LNKkMdbiBYKtKqWovgIFZDiyTTqPMjUOxAyoOWrnWwlWL/RWOq+/EQh5AkYDjKGWerRM
         3zlQKOmKHv5fAhKYT/rvyb7vCNbLZpY0VuAi94Xub/kf/EHSxudndjNa1ITPC3NWD87v
         X6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7FMF5d4y464/mBG+xgnW5AJzOcYV63lfjmbJHbKUYyU=;
        b=fRlbY8lw+W6A7hbfGYqu3DXqC1dGbCWlRJ8Ju0jsqkfs7T+w6tTlvI2Ew6AsAqS4Gq
         /JjbvwwdK1TQ7NYvocps6oMYp2vysGE8Q45vs0i4H8Pmwcnb3mx3sY0xW2E0/bfVxYgh
         CDOr6+wscbIaRanZbl1A6srcWLAlGP6GjtLmwSbDga/G4PLd/OqMy6lJnxndsCDrncMg
         nRux9MsulLXjbiNhJ4KZdrihifLn66XRyL1bD7F4n4NNi52ILGi9jvo2Uz5ESQYw+Fqk
         wrFgPiWcXq3YQU49VuolyOf4nIynxCM3IazjvZc9/wXXFDDf4RHkGsXBmBsYubAmlD0g
         n+Cg==
X-Gm-Message-State: AOAM533N7XRIxgOWPJ4iE60M1maoi1uD9JLBBBL9yY8xFAHr4Rxi2R6D
        3JGMTTfGSBRQ4biFpR26kAOVdw==
X-Google-Smtp-Source: ABdhPJxAPbl4lIWo/zl/wBMjezsPxPZpgneEeANeylpou0230Vt3jxB5ymE7ds/N5HABAwYzorMKLA==
X-Received: by 2002:a05:6e02:20e1:: with SMTP id q1mr13387664ilv.172.1643649453386;
        Mon, 31 Jan 2022 09:17:33 -0800 (PST)
Received: from localhost (c-73-73-44-208.hsd1.il.comcast.net. [73.73.44.208])
        by smtp.gmail.com with UTF8SMTPSA id q4sm7815726ilv.5.2022.01.31.09.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:17:33 -0800 (PST)
From:   Jesse Hathaway <jesse@mbuki-mvuki.org>
To:     ycheng@google.com
Cc:     davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        ncardwell@google.com, pavel@denx.de, sashal@kernel.org,
        soheil@google.com, stable@vger.kernel.org, weiwan@google.com,
        jesse@mbuki-mvuki.org
Subject: Re: [PATCH 5.10 099/167] tcp: disable TFO blackhole logic by default
Date:   Mon, 31 Jan 2022 11:17:32 -0600
Message-Id: <20220131171732.1018990-1-jesse@mbuki-mvuki.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAK6E8=cEX6MjxdnW36t9qq8+RqkPp9ZTwwH9Mr=emfbJ4=WV0Q@mail.gmail.com>
References: <CAK6E8=cEX6MjxdnW36t9qq8+RqkPp9ZTwwH9Mr=emfbJ4=WV0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 09:32:42 -0700 Yuchung Cheng <ycheng@google.com> wrote:

> On the other hand maybe we do not hear middlebox issues because this
> mechanism is working. So I am okay to avoid applying to stable and
> keep in net-next to test this new policy.

This change did indeed break our mail servers at Wikimedia, causing
difficult to diagnose timeout errors on sending outgoing email. I
resorted to bisecting the kernel, which resulted in finding this commit.
I have verified that reverting the sysctl value for
tcp_fastopen_blackhole_timeout_sec to 3600 does resolve the timeouts.

Given that it is not clear how a user would discover that this sysctl
has changed, or know how to fix a middle box somewhere on a path to
their destination, I would love to see this change reverted.

Yours kindly, Jesse Hathaway
