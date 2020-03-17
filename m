Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C396B1879E2
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgCQGy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:54:59 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:32943 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgCQGy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 02:54:59 -0400
Received: by mail-pl1-f201.google.com with SMTP id b10so11918805pls.0
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 23:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cF0mn8RFp/NzGOPpgquFoVLhCbRSN6dQrHYHqFzbKxU=;
        b=qLUq4/RNPb7PhrgnudeQu/ls8asTv9i4YDOfr3NggSvcNYi4UxSfYMit8S1WUgfRKZ
         hZbbZQPFLrVYc4w+L0UZzkonnR+9Rm8+cgeDoLy//zUl/eEx1tyOtsRTwwk0IC1GmMk5
         7CS7xqEvKVY1hdXlUYzYVEQFG7dy5X2lR4whv4tssypZlespqwDBYf2ykgBrHzGRsoWw
         KSyWF/LIwFFvygdQi7hxsX3du+o+gHjUR3p65oe+tr2Bc5ohTBv5n7uD892DON5VSkoX
         pinFPh3FrUqi+8QXt/ZEbxdi0FQwUvd8TPga7GUwJMefUnNRxfnPnWu3NX9YAlqNlHUu
         10hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cF0mn8RFp/NzGOPpgquFoVLhCbRSN6dQrHYHqFzbKxU=;
        b=j1sFeYLV6tzOx5w+xsHsnOv21xgSEOLIoMroHSuEN0MWbRSXJFMX9Ylt1mY0Rsmtsi
         8ZPtJP4nk+oCfCVP0nEq12am/VDGtqpGi29+zCl6ycvyWiuQZroAfFM94WXDRgsuZsmX
         gDRjN97Fc1pGqfV1fMD1lRpNPqure7VYzdIyGzO5jbtieWaM7CqCrHXdP84UQpDl+S5h
         WoQU9fJr67bgtyAGGKNvZtBivpWfFBQBFZd4P08SVgnO5F76IVfSMlfpFPWBpBVXtr+a
         m6B1MpJxQrgrdYpK+7bg7AMbRtpDhtKdw2Q33ENwpCsKC8eqwOgVkiIJFJjktabes5LA
         BSug==
X-Gm-Message-State: ANhLgQ1e0U3IZhvck0ePdvW6dBth1DupsKDzGgbfOTBM4q83Lwumm/Xy
        CgbQmpwaueC/Z0XXyEaMBHI4aWWRmhmI5FXUKgTpNdN4p0fyJFMBsPL/8kAtAnPa09mGzGyD0Dc
        9XC8n23+8AwoTvKLM8YstUmgNSkxZy7DxLbYCifaEno0O92pWSkx/v9GGHWXJQwRaARXnuw==
X-Google-Smtp-Source: ADFU+vt2Zvqf1px/Dmb35lmQnUB5JpW8RvY7l95YZat6XfupQdXF2UMeOYFTa4BNyZ32vltscuYTU3kAv+PeRtc=
X-Received: by 2002:a63:8342:: with SMTP id h63mr3660917pge.141.1584428098211;
 Mon, 16 Mar 2020 23:54:58 -0700 (PDT)
Date:   Mon, 16 Mar 2020 23:54:46 -0700
Message-Id: <20200317065452.236670-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v1 0/6] Fix device links functional breakage in 4.19.99
From:   Saravana Kannan <saravanak@google.com>
To:     stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As mentioned in an earlier email thread [1], 4.19.99 broke the ability
to create stateful and stateless device links between the same set of
devices when it pulled in a valid bug fix [2]. While the fix was valid,
it removes a functionality that was present before the bug fix.

This patch series attempts to fix that by pulling in more patches from
upstream. I've just done compilation testing so far. But wanted to send
out a v1 to see if this patch list was acceptable before I fixed up the
commit text format to match what's needed for stable mailing list.

Some of the patches are new functionality, but for a first pass, it was
easier to pull these in than try and fix the conflicts. If these patches
are okay to pull into stable, then all I need to do is fix the commit
text.

Thanks,
Saravana

[1] - https://lore.kernel.org/stable/CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com/#t
[2] - 6fdc440366f1a99f344b629ac92f350aefd77911


Rafael J. Wysocki (5):
  driver core: Fix adding device links to probing suppliers
  driver core: Make driver core own stateful device links
  driver core: Add device link flag DL_FLAG_AUTOPROBE_CONSUMER
  driver core: Remove device link creation limitation
  driver core: Fix creation of device links with PM-runtime flags

Yong Wu (1):
  driver core: Remove the link if there is no driver with AUTO flag

 Documentation/driver-api/device_link.rst |  63 +++--
 drivers/base/core.c                      | 293 +++++++++++++++++------
 drivers/base/dd.c                        |   2 +-
 drivers/base/power/runtime.c             |   4 +-
 include/linux/device.h                   |   7 +-
 5 files changed, 265 insertions(+), 104 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

