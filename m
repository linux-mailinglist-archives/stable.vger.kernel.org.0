Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EF639DEA4
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFGO0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 10:26:38 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:43743 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhFGO0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 10:26:38 -0400
Received: by mail-ot1-f47.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso16836508otu.10
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4PwH1AXD3SllEEcEV6owIpVJRtalHEcUOPjpbDNsvcE=;
        b=cnyQchdM9XN7mTX7klVDRaZAGec8Q8qrrgJsK/rY5IWCFWqXKtJigc2u5iJ3nTKhXw
         hTCBoDi6PvaC7Qal4P5PtF+hNfxJn1UEkv9Hcf9wtTn4pAgUNqIJOUSXsbljLqmpewmm
         o915MnvFQ1z/s12k+1IjfeYKPee8nCycjHwGg9lCiAvsiBZiU16+Oc4LGR4H6FBXGjI2
         JoUq37/RciUGNPVXDcKoI2f+/2f4Ew1q1gKOLYe6Pnu9XuAG41djRUSa78GNxa77lzgX
         YhOBNQ+SGZ/R7qUINBzULtCo2R7jCWVKASeTky5mGxFkxRVvoiaTjMJnE6UdLu371scO
         kfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4PwH1AXD3SllEEcEV6owIpVJRtalHEcUOPjpbDNsvcE=;
        b=mZxEzlqTpdS6lcM719LTW0ZdElIU9Cwf1+R4HhCP2FUv89jyp6V+zRQ3C7L1ZCB0ro
         LuyoH71uNudPbRN4lqIuRTXUDFNIykNX+OREibfsu3e8tMmdxhBFNvoOxte0CQdTZazn
         2tg078K2ujSoHOwYHdAMponihc38Chud98kHcBeYId4ooqg2vCOE9KeS1R3WGM32U6fC
         SFy/7pw0auL2X22wSAh+8i/l2mngtqnzDDszJeefzd9N/2J+bE75dYKXjabkYvzYvqGn
         SDgOLj0ROoVUaiZK9/H+45I5AIjACllRN+ClYi/hJ9vnYcv09+MGZH0SFk7mxvp42AUy
         zxSg==
X-Gm-Message-State: AOAM533FjsR9RB0czuYr8NKeKZvU4FbS9MV+Y/5GyFYVFZgv2i0Jp71e
        /Z8RhV2q0/YACgNOwZmi6CepWMM/OYap65OqeLapvMhT7k0Z/g==
X-Google-Smtp-Source: ABdhPJz15LOt9hpVMXGWPSrsBD4CZ1VQ2e0HTqJhDcwL8qPa2YqaZL4KCBOgZGx/xE3Z2zHVczwClsGbRFeRlCUNwl0=
X-Received: by 2002:a9d:7a54:: with SMTP id z20mr14261136otm.17.1623075826297;
 Mon, 07 Jun 2021 07:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210521083209.3740269-1-elver@google.com>
In-Reply-To: <20210521083209.3740269-1-elver@google.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 7 Jun 2021 16:23:34 +0200
Message-ID: <CANpmjNObVfB6AREacptbMTikzbFfGuuL49jZqPSOTUjAExyp+g@mail.gmail.com>
Subject: [5.12.y] kfence: use TASK_IDLE when awaiting allocation
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Alexander Potapenko <glider@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,

The patch "kfence: use TASK_IDLE when awaiting allocation" has landed
in mainline as 8fd0e995cc7b, however, does not apply cleanly to 5.12.y
due to a prerequisite patch missing.

My recommendation is to cherry-pick the following 2 commits to 5.12.y
(rather than rebase 8fd0e995cc7b on top of 5.12.y):

  37c9284f6932 kfence: maximize allocation wait timeout duration
  8fd0e995cc7b kfence: use TASK_IDLE when awaiting allocation

Many thanks,
-- Marco

---------- Forwarded message ---------
From: Marco Elver <elver@google.com>
Date: Fri, 21 May 2021 at 10:32
Subject: [PATCH] kfence: use TASK_IDLE when awaiting allocation
To: <elver@google.com>, <akpm@linux-foundation.org>
Cc: <glider@google.com>, <dvyukov@google.com>,
<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
<kasan-dev@googlegroups.com>, Mel Gorman <mgorman@suse.de>,
<stable@vger.kernel.org>


Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
allocation counts towards load. However, for KFENCE, this does not make
any sense, since there is no busy work we're awaiting.

Instead, use TASK_IDLE via wait_event_idle() to not count towards load.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1185565
Fixes: 407f1d8c1b5f ("kfence: await for allocation using wait_event")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org> # v5.12+
---
 mm/kfence/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
