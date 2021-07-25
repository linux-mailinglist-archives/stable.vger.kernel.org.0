Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A789E3D4F98
	for <lists+stable@lfdr.de>; Sun, 25 Jul 2021 21:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhGYS34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Jul 2021 14:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhGYS3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Jul 2021 14:29:55 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC85CC061757
        for <stable@vger.kernel.org>; Sun, 25 Jul 2021 12:10:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c11so8988985plg.11
        for <stable@vger.kernel.org>; Sun, 25 Jul 2021 12:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kX0eYY9YjEaivkZX4gZmRWQoX5AVWchp0HevtnDPnVw=;
        b=Dur6eMDuTvAkBjxN5DFykUolJuJfOjcaoqcODAp46b1yil9KulA8uUGwZTDhk4nyFs
         CP1D3UTft8rGs8rkJxLhdckRscpRLbyfMoAWegJaJsIV+cjW1vphzhF0eoXSzy+3t50f
         HetlSuDMhM5u8/4GobkY72JHklydNFotcsZz8r2PhnhgTlQr1fISdiB+T0aY+vD67Nrl
         h7ZhGL5VyRL4evggJPgg26P498goeg31GDx6+zj3VZODxq/CnHKUci8dsbHRF8iz2RoI
         Y39ZFg0EhtjpJl30R0goupAxo9pG3/T69UAhYgh40xa5D7Em1/4QKOkJPC+fEDpVFafC
         woLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kX0eYY9YjEaivkZX4gZmRWQoX5AVWchp0HevtnDPnVw=;
        b=oFJb8gIy6NQbkDLGzQT7Q0ssMR7gHyuIUvKT+w13WlyWpgSPA0JTc/tGya+NznduS7
         fYeuO35DDE6HL0oVejDmrgLW+DaSd3UtW1EABhxQ0RC/FRmyBGMHEWMtwfMpCc+VBX3B
         IaIRSHmgzt556xxLFuB/b8qokA2M+TT663j7ll+Yt47g6ukNhfuep4bsz+zdAxMpQfs/
         kXVVKIQR91jAyQ7RDSF0kktZixwbrvv75tT18isSfcCUOtXYKXNCHuPIydDYtwlS0Xcd
         yLgLjcD48dGcZAFGSxjEh8mGmoHOePRNGhMSxa++Fhzy1x68FxUNo4BQCXmrKD+8zaqw
         UW2Q==
X-Gm-Message-State: AOAM5301OVm88wRrkeJCuQmZEWfMRgtnypM4Hm+p9nJ/bHZEyLRKYNp1
        dhQOIsreAL/+5Ofrwcsyjcu0gQ==
X-Google-Smtp-Source: ABdhPJzpbjlw6cp7Z+jqoYrInoZDHFwmkxNjruW9JkW/6NtbfsfsTb5QFdOTVYq3kgTWS5DYGWbmzA==
X-Received: by 2002:a17:902:ec86:b029:129:ab4e:9ab2 with SMTP id x6-20020a170902ec86b0290129ab4e9ab2mr11638010plg.12.1627240224697;
        Sun, 25 Jul 2021 12:10:24 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id o9sm42890179pfh.217.2021.07.25.12.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jul 2021 12:10:24 -0700 (PDT)
Subject: Re: [PATCH io_uring backport to 5.13.y] io_uring: Fix race condition
 when sqp thread goes to sleep
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
References: <82a82077d8b02166482df754b1abb7c3fbc3c560.1627189961.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca9be2ad-711e-51a3-9c5d-9472a1fad625@kernel.dk>
Date:   Sun, 25 Jul 2021 13:10:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82a82077d8b02166482df754b1abb7c3fbc3c560.1627189961.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/21 11:07 PM, Olivier Langlois wrote:
> [ Upstream commit 997135017716 ("io_uring: Fix race condition when sqp thread goes to sleep") ]
> 
> If an asynchronous completion happens before the task is preparing
> itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
> will not wake up the sqp thread.

Looks good to me - Greg, would you mind queueing this one up?

-- 
Jens Axboe

