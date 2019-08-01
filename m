Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343DB7DE38
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 16:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbfHAOsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 10:48:42 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38910 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732267AbfHAOsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 10:48:42 -0400
Received: by mail-io1-f67.google.com with SMTP id j6so25115995ioa.5
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 07:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NL3ejeWxwhxOr1Nd3ekSsZlZL/Ha72heQpwIPUS9CQM=;
        b=naemidp13xVtFqMSdOqrRSjkkUsnqMf9Y9Y1SsoMbp5wbF3R6iW6TX77kOb1ruCUH9
         VRPHYMzz7m16Xs2Mqog+6FbO44I7SyzHsbLn89Q+4Yo8WL9cTKrAmwuFbx2R6g8dfAC5
         TeUi3G9KShuN1yA0blud0EZ4dH0wa8XTd/h8PlCe1JcHq6cOWs+EYbsJhyrd09h+tMvs
         RqspfvuE2b/Y0YGt3cGYI7Ztu7XvyFDwAJVw3ocVhvyMHVW5JrATX5qFI0fLt0syu/I3
         FN+FTnub4ciEiZsbW+BBUZNdPIAqjkT1h13xE9nrSd2VmZUIBKecvdXWnuOoVnn9RDVO
         MR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NL3ejeWxwhxOr1Nd3ekSsZlZL/Ha72heQpwIPUS9CQM=;
        b=rbHzZIxQe4bnECGs7LOq66B3gY/yQPiWV2qAhGz0Mw2aLaloFANClWXFEdCfipSb3D
         oidcaB9rnzaB3Td5w/bgoPjhC4ELN1dOz+KiWxY//pNnGLUp3xB7m0YwvHFcwoOA4RK5
         bEMWZrQSefY/E8cOAsizGtUcDH+kenEWDnYw4fEF5+ko3JDl8skLh5RWRUQw8cjKn18c
         sNDT/ZLIUnwGjrt+wGQm8cq0mrFBTCEyADMUG6sQcwtAgWhZKoim9HmlvJ1eusyrAicW
         5ep+Huknekz/b7OoNl8dikwvU05lfMrLpSs4X8uFcdN44K+hduRJ3bVzCL+3HKokxax+
         Q4bg==
X-Gm-Message-State: APjAAAU9wCLvUsOYLmvzuSyYKFzq59OoMJrNtVtjDORkXfQaRC6U2VVo
        yMFB4N6ynKClFq3B/yW/E//SB/mHKDcH0VfTeJgIFQ==
X-Google-Smtp-Source: APXvYqyjPO1y2Gb/12GLfV9jNpcWDS4MO4IPxsLM8k7KYS/q9WfO+iK03wce0PRzEtaUo9EOqupdygYe6KVwQPMfY0c=
X-Received: by 2002:a05:6638:517:: with SMTP id i23mr18072843jar.71.1564670921521;
 Thu, 01 Aug 2019 07:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190730125157.884-3-andrew.murray@arm.com> <20190801133137.3560C217D7@mail.kernel.org>
In-Reply-To: <20190801133137.3560C217D7@mail.kernel.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Thu, 1 Aug 2019 08:48:30 -0600
Message-ID: <CANLsYkyw9syB3mRVEf+Yo-3s6TjC6xkNzgn4zuKu0B9QZc_a+w@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] coresight: etm4x: use explicit barriers on enable/disable
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "# 4 . 7" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Aug 2019 at 07:31, Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.4, v5.1.21, v4.19.62, v4.14.134, v4.9.186, v4.4.186.
>
> v5.2.4: Build OK!
> v5.1.21: Build OK!
> v4.19.62: Failed to apply! Possible dependencies:
>     41a75cdde735 ("coresight: Convert driver messages to dev_dbg")
>     68a147752d04 ("coresight: etmx: Claim devices before use")
>     e006d89abedd ("coresight: etm4x: Add support for handling errors")
>     e2a1551a881f ("coresight: etm3: Add support for handling errors")
>
> v4.14.134: Failed to apply! Possible dependencies:
>     41a75cdde735 ("coresight: Convert driver messages to dev_dbg")
>     68a147752d04 ("coresight: etmx: Claim devices before use")
>     e006d89abedd ("coresight: etm4x: Add support for handling errors")
>     e2a1551a881f ("coresight: etm3: Add support for handling errors")
>
> v4.9.186: Failed to apply! Possible dependencies:
>     297ab90f15f6 ("coresight: tmc: Cleanup operation mode handling")
>     2cd541402829 ("coresight: tmc: minor fix for output log")
>     41a75cdde735 ("coresight: Convert driver messages to dev_dbg")
>     68a147752d04 ("coresight: etmx: Claim devices before use")
>     c38e505e2701 ("coresight: tmc: Get rid of mode parameter for helper routines")
>     e006d89abedd ("coresight: etm4x: Add support for handling errors")
>     e2a1551a881f ("coresight: etm3: Add support for handling errors")
>
> v4.4.186: Failed to apply! Possible dependencies:
>     1925a470ce69 ("coresight: etm3x: splitting struct etm_drvdata")
>     2127154d115d ("coresight: etm3x: implementing user/kernel mode tracing")
>     22fd532eaa0c ("coresight: etm3x: adding operation mode for etm_enable()")
>     27b10da8fff2 ("coresight: etb10: moving to local atomic operations")
>     41a75cdde735 ("coresight: Convert driver messages to dev_dbg")
>     52210c8745e4 ("coresight: implementing 'cpu_id()' API")
>     68a147752d04 ("coresight: etmx: Claim devices before use")
>     882d5e112491 ("coresight: etm3x: implementing perf_enable/disable() API")
>     b3e94405941e ("coresight: associating path with session rather than tracer")
>     c04148e708c0 ("coresight: etm3x: moving sysFS entries to dedicated file")
>     c1f8e57c9e66 ("coresight: etm3x: moving etm_readl/writel to header file")
>     e2a1551a881f ("coresight: etm3: Add support for handling errors")
>     e827d4550aa3 ("coresight: etb10: adding operation mode for sink->enable()")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

I have another one like that - will send a separate set that applies correctly.

Thanks for the consideration,
Mathieu

>
> --
> Thanks,
> Sasha
