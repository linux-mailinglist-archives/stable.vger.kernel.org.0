Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C3C572D17
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 07:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiGMF2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 01:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiGMF2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 01:28:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0458DC8B9;
        Tue, 12 Jul 2022 22:28:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id sz17so17914965ejc.9;
        Tue, 12 Jul 2022 22:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zpzGC0d/rdPCgl5tFu9d6v6NpwTSdgKiF3uLQJGNpEw=;
        b=Oswchug5eEGm5u8qpEBdF6+uz0p0QanHysxN55l6VJFts/CIv+iRFyOjBkx49bbAMG
         YkmC5Qv8GATUm93DedfENfqI73R+8oL/FIugmUuE+AWw7vRyEqaVHx5RPCmwvYME3rrl
         nt7pMK886N8agX+zXKJP/woF6o03pmk7RYFt/c/bzgMOy+8I8E+yoZx68YmdOV+48blN
         VdpwBqBTr75bUJDWyzIidB1EGThrEOJyFW2WFppWuPAKCxHhAmQCIVdKDZfTTj00JBWH
         t/ReYmILLK4AkCadfyUpaNAhLq/nCgQOzVMtjDD8vY1oaQS1HEemeYj5gueduT3PU4Zu
         99tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zpzGC0d/rdPCgl5tFu9d6v6NpwTSdgKiF3uLQJGNpEw=;
        b=tFcLLcD/68Ec1YWvPJt5OFjiFi1kFLMz946WTziinb31+qL6MylHndoCKlvsN+Mxs8
         asVFyezTJ/QEC77gfkp2x+QsF2dkGqMcHjKdwFhj3Muh5hn6X9q2l8HtDmgHXv2cGwaA
         W2OrFPZruvlGuxrh6h4wN1kCmsPidHcN1IiBemAH8FWHjEGtpX+Zp4Gviic/J/UEymw0
         7RTqPiOn07l6yj5Q6P+0nKXgiSwppt3nFlitbF7ZNJNxxhEQbiT8zDZ6DybfDd3I7Wnq
         v5iWluEP0b1b2w12uCZcyWRa5T7SvQ2rG+EIF6TfMBTydMA5X1uV6D/HVc/QBGjP3Gb5
         6VFg==
X-Gm-Message-State: AJIora/FOjoiP2O43XueTigDC3kbTO2/gIqxzExTRYR6uEuBTOIzbwqC
        nnjsuBE3svn4id4HafrAk3KXzj8Hvat+xPWdXFetqTNGbaw4gg==
X-Google-Smtp-Source: AGRyM1u0aHhUkrVGDkWSrMsK6cjXANcyLhkuDpYSD7AW4rzNr8FlYEemLqg8+PUaDySHVKhUi6JFnkr6fRnVn9u5Xvc=
X-Received: by 2002:a17:906:99c5:b0:6fe:b069:4ab6 with SMTP id
 s5-20020a17090699c500b006feb0694ab6mr1649893ejn.436.1657690108981; Tue, 12
 Jul 2022 22:28:28 -0700 (PDT)
MIME-Version: 1.0
From:   Ben Greening <bgreening@gmail.com>
Date:   Tue, 12 Jul 2022 22:27:52 -0700
Message-ID: <CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com>
Subject: [Regression] ACPI: video: Change how we determine if brightness
 key-presses are handled
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(resending because of HTML formatting)
Hi, I'm on Arch Linux and upgraded from kernel 5.18.9.arch1-1 to
5.18.10.arch1-1. The brightness keys don't work as well as before.
Gnome had 20 degrees of brightness, now it's 10, and Xfce went from 10
to 5. Additionally, on Gnome the brightness keys are a little slow to
respond and there's a bit of a stutter. Don't know why Xfce doesn't
stutter, but halving the degrees of brightness for both makes me
wonder if each press is being counted twice.

Reverting commit 3a0cf7ab8d in acpi_video.c and rebuilding
5.18.10.arch1-1 fixed it.
The laptop is a Dell Inspiron n4010 and I use "acpi_backlight=video"
to make the brightness keys work. Please let me know if there's any
hardware info you need.

#regzbot introduced: 3a0cf7ab8d
