Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A373F63F312
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 15:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiLAOpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 09:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLAOpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 09:45:12 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD28A1A3B
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 06:45:11 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n188so1143796iof.8
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 06:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Myk/frs+/PELrl6SJ0tjbXBv1A0UiyxiM57+8qkIPRQ=;
        b=1ECiSr8xkZdZ3I3qIBsqirwG1tY438zDjWMz+rcqOhOrQuIsHCG5dqU7kqNh6TeQSB
         oL2kLPhOk4vJCGLYgdT6XTKtlRlcKnStUKqXpkdx4VxlW00GVDbp/PnM16fCHGUB2Drc
         FEgseG7EChDvXXcNU/DiPKEpyYUu8TuWl0/nCygoIzPyrQ+cXup8ieVQrGl6k8Gqngrg
         xm8CoZNYAv3uqncmLDhZNg1rLGqGLeAajZiZHOHvQtZ7YxM/KWLr+XfR7TXLoBGz98SQ
         mgtVWuRQKFZDIcy72KpI+Z+mVkLzhgxl70EmcBKi7FIX2aGVvEgvFUkUOYIHz4ms0l9F
         s4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Myk/frs+/PELrl6SJ0tjbXBv1A0UiyxiM57+8qkIPRQ=;
        b=EHnc/3UzYDVnuDzWEh3YL7CcUvRBny0jVKTqrCtivwB+uLcBkE0lDKtEkI/pkrP9+i
         1dnureTA5k0v9n7jMoeHv/JLOBs6pnvcejnxEOlbgc4WDbnEBD5oIwgxePiEbM+6Xxw0
         cm69O8/gXAGJeu3d0h9n7aCa6ldSOrH9o67jJv0a660uLR/AVIPjw47vTJCSyok4gVvu
         mvrPbGzcp13nd10UWJcZO1y39O2SJyHePZ74CYqzFnVdC/hiRQptrXMSSeWwkQXl0Sfn
         uJHvvUCr4qdKlWlsjijpvAuMszh+aJkS42Dnw5TkI6DZzMsxlNj3QcgCbpZ8b8DjO2lA
         3w7w==
X-Gm-Message-State: ANoB5pngw4f41EHrTSFy3YReo3m+5/oQKbO62o8oxS27d8JGMIMCyLGg
        EFOtS431eefs7stNNvl7q5lc6Q==
X-Google-Smtp-Source: AA0mqf6PS1vyKImmIJ+s988DaGJbXthqY5i4AUmTUIw7FcXoWmIpIz2g4Iwm7mhSnDK9kB6uKcNmHg==
X-Received: by 2002:a02:c881:0:b0:38a:f6b:76f9 with SMTP id m1-20020a02c881000000b0038a0f6b76f9mr1836013jao.180.1669905910873;
        Thu, 01 Dec 2022 06:45:10 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y17-20020a056e02119100b00300d3c0e33dsm1589519ili.4.2022.12.01.06.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 06:45:10 -0800 (PST)
Message-ID: <a3c9044e-d7ab-8130-76ea-a09152eacaea@kernel.dk>
Date:   Thu, 1 Dec 2022 07:45:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] block: Fixup condition detecting exclusive opener during
 partition rescan
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        stable@vger.kernel.org
References: <20221201114442.6829-1-jack@suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221201114442.6829-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/1/22 4:44 AM, Jan Kara wrote:
> The condition detecting whether somebody else has the device exclusively
> open in disk_scan_partitions() has a brownpaper bag bug. It triggers also
> when nobody has the device exclusively open and we are coming from
> BLKRRPART path. Interestingly this didn't have any adverse effects
> during testing because tools update kernel's notion of the partition
> table using ioctls and don't rely on BLKRRPART. Fix the bug before
> somebody trips over it.

I folded this in. It's funny because I did consider this when reviewing
it, but then convinced myself it was fine...

-- 
Jens Axboe


