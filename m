Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E442143D2A0
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 22:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbhJ0UP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 16:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhJ0UP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 16:15:57 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CBEC061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 13:13:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r2so4038596pgl.10
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 13:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:cc:from:to
         :subject:content-transfer-encoding;
        bh=2quhB9wk+2hisyAoejZf46ukVE04ZM4aqDiYUous6WM=;
        b=RBdp6CZAWrVsm/t2q+D4XggtIzLZfM1OjKqrkNJRPW9PZ7YCbYZd8rMt2iY/iJA69t
         y6pVLe4/7wHnozOUZKyj3swN+y9xmpNmzajuCFqdso0WtsAxs5GxiRpwcIT44hJyufPz
         x382y2agaKaHf8PeySqQaUd0m/3HuB6Hmz3zKm98TQUXWpITdcOA+ysR+V1VE1YQinrI
         NEejLHZ0aq5Uva/THylGzHh2ZHe5aVpjiZRwbUSTAP6dIA8hUoZfprq4rYW9Hw+Ci+ff
         3OuGMACbT0rF92IoqdGGXroY1Nok+5u2xm4omkw3D1uZoasLzo3HtcWCjND7eRXm0+NB
         tARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:cc:from:to:subject:content-transfer-encoding;
        bh=2quhB9wk+2hisyAoejZf46ukVE04ZM4aqDiYUous6WM=;
        b=DHJWdlnQOr5ngsOsJufeViP+Pgf1XX2/+0wicfYnyjU4jeqrzGOK7I3/T0YIwgNuUi
         quqBowKd8yyoBjSk3y41UixWDZgmNxW5qN/ac5Aj3PUha3cpHDhcCb6RB99hhjtqlCqq
         JPDtXz8h3t4fI6T1pDEN9HpIjTMvuRjRBDW8uBzsIcDUatYm8u+II+81RelyB/Mo39xX
         ScUfRFDvzZFXr3yPuPA/c5DsY7fHyl4l9tXyaiX0ttjLiF093P6wl6UOyqqVJyNe7SbF
         5qEwcIdPvHsNMJ7mmMwb2XIfKBQ4yZgVJOKlMU42cFDikJlU+slLba2hLNt6Zu2MeEaB
         UbWw==
X-Gm-Message-State: AOAM532cPllTS4hHbVw7jAWfEBUjhyRruhIVV3/VIVCUVsoTV71819ya
        BiFblTphQemC/NvgRghOCXeDzj35EfM3OKBP
X-Google-Smtp-Source: ABdhPJy06nyeJPBkoZ1Axt2/NbXYOomwxrqIReD3Op9bNCFT6MfdswqOFthcb/Rv7lb0+luqy2Ochw==
X-Received: by 2002:a05:6a00:2443:b0:44e:ec:f388 with SMTP id d3-20020a056a00244300b0044e00ecf388mr34196537pfj.7.1635365611512;
        Wed, 27 Oct 2021 13:13:31 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id lt10sm539242pjb.43.2021.10.27.13.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 13:13:31 -0700 (PDT)
Message-ID: <264a42f3-0475-215d-aaa5-5deb435f8360@linaro.org>
Date:   Wed, 27 Oct 2021 13:13:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
Cc:     Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Subject: ext4: fix possible UAF when remounting r/o a mmp-protected file
 system
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
Upstream commit id: 61bb4a1c417e5b95d9edb4f887f131de32e419cb

is still missing from stable 5.10 and syzkaller has found the gap:

https://syzkaller.appspot.com/bug?id=990c7f09780460b8165714b9c9751ae8432587f3

It should be applied to stable kernels: 5.10

-- 
Thanks,
Tadeusz
