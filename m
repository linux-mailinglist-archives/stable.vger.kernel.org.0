Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5953FB8118
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 20:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392091AbfISS6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 14:58:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33799 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388943AbfISS6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 14:58:24 -0400
Received: by mail-ot1-f65.google.com with SMTP id m19so2214302otp.1;
        Thu, 19 Sep 2019 11:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMIQo0y0joi9ONCPZAMGxjNxNx6MRqPmS+7Wzb6NPMw=;
        b=PdMcH7dAkOiUVObgzoR9D3iU41jNVLqhuajjaBVFwYrNpJtDABOoz75SpJQPYngU//
         5DcHtHCLgYFS/AXF2zWerXUbAyZKCQpPactZrIWSwVGc4U02cJpbO7bRqRFnkYKe2ApS
         mXZBH9X6OJjK8fg4uP4W/y2eM8G4JvPy2+4tJVfXG7ajjbxnJEpTYycFmkbShTnGJlBT
         VYaLM+6B5/rzTtss7vo0gk+hJXLIGTCCPtwc0xxj3sC/eSvF7MD0sHefN8YQcs8BA9hY
         lQudFnhYdMamD4OtNLLvirAoJrt6FDQ6D7Bw16hUijItmeYDdr0KtLEoY8gY0BLM0yVr
         Zm4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMIQo0y0joi9ONCPZAMGxjNxNx6MRqPmS+7Wzb6NPMw=;
        b=ZqLxMdt/lWd31czs+1+dQ9+qq7gGDs3lzOlyFnWUa8330lGDwTiGAnnQcgXgAGXvZC
         xMIspQdQEuXIej1TjfSlnOCwf+YIYuxSKFiRoWIvpoFgxTRRm3FhG+zcYxP/0D9MwxaL
         0Fwr0MCuCi5kVT2QSfHdySpqCd6Sw23TorD/Kxx22c9w48dDOYT6OVq/36vCW0FiPGMh
         8jL3IwN5tk5/gPZ7L54LpK5XEo5ZZSfGNCY1Upd6juYVFkTY56YxViPKw6xrJgKM88Ko
         7FIHXxA26mciYLl+AbTl1NsZmVY3ybHes/w2RNn7ixtKcQcxLgAoGIiYX1Y3KVkcbU6q
         wZdA==
X-Gm-Message-State: APjAAAX9ni6ikF+Ml3VXHejcjMg2RcmfPmTwRFrp2PCeLfbYxFiftk2J
        /Txe7xxLfbbGEFGwJmYvYTb6BUR3OzuVs82MGWA=
X-Google-Smtp-Source: APXvYqxccIC05hsDwWUY5rbQWcSMLJsLpJN2oedXJT8dEp7TlRE79IMU082hbFlMCp4I4WwU4vEACd9GbZXs4zp4yno=
X-Received: by 2002:a9d:5f10:: with SMTP id f16mr6999602oti.332.1568919503185;
 Thu, 19 Sep 2019 11:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190919151137.9960-1-TheSven73@gmail.com> <20190919182904.AF657207FC@mail.kernel.org>
In-Reply-To: <20190919182904.AF657207FC@mail.kernel.org>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 19 Sep 2019 14:58:12 -0400
Message-ID: <CAGngYiW2bObc8L+mQJEMzYRe+QU7Xx1X_-So-o0RYAE7TWr3rg@mail.gmail.com>
Subject: Re: [PATCH v1] power: supply: ltc2941-battery-gauge: fix use-after-free
To:     Sasha Levin <sashal@kernel.org>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 2:29 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.15, v4.19.73, v4.14.144, v4.9.193, v4.4.193.
>
> v5.2.15: Build OK!
> v4.19.73: Build OK!
> v4.14.144: Build OK!
> v4.9.193: Build OK!
> v4.4.193: Failed to apply! Possible dependencies:
>     Unable to calculate
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha

Doesn't apply on 4.4 because power supply drivers moved to a different
directory (power/supply) between 4.4 and 4.9.

I will post a patch with a fixed-up file path, marked as "[PATCH 4.4 v1]".
If this should be addressed differently, please let me know.

Sven
