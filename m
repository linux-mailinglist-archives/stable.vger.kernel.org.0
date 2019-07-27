Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773D777A4F
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbfG0PiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 11:38:04 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:37628 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387673AbfG0PiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 11:38:04 -0400
Received: by mail-pf1-f170.google.com with SMTP id 19so25897168pfa.4
        for <stable@vger.kernel.org>; Sat, 27 Jul 2019 08:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=DqzRSfMcFMnscLZ0489+wtz9sRT/Hjw1Szjv8K7dB+g=;
        b=veKnieA80WG8iktlTnxy/cUh8Gu9PtLURRmmsqH9US+oqgqRi9bEg6lwsQRYjN+ZJR
         7GThLoYidFQshx1x77NEu3my4HZynP6tmu1OqGaXnFmNpSDzlQvrMgdV5JeF1BRmwrAB
         U/y9SQekrcSLxSbKnb7rgj6dY7Mg926YieRvAO8gqHZJ0hWwVvZoZxjX7OXK0ygO/Tdy
         ZzsQ/VhTQbiRSBFogXJc8NdFbJ7Xmsgen9xDQ0Spnzy6I24gxVu/j0xEfRnrveMbfE9w
         PD4YxKDqdZ1gnPSR4eUAf++2haTta0RxLj4bGrwUwVEzBDXu5hzB/VAHkPuz7ORwjFCX
         5qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=DqzRSfMcFMnscLZ0489+wtz9sRT/Hjw1Szjv8K7dB+g=;
        b=DvLL+RSjPNMCZJmvOVlM4D/g/ptTStr+sFHZslQb4IBijBlg9aNIbmMei83zcL+bgr
         T8oPgQyEXlhacWr017wN6vvrYfUFhvLgTf8YRnMQjlCwrs3slFUqDukR5U9lr5P14gs0
         CcMAYakPO7mp+Vk31/li8ugOgaj4ZyENJUSAaiZWqRso/Wu/Vuq4p6in482iDrDPolLZ
         YFAbetjPODFfAjIldgNjTx+BaMldl6v8BViO9dBCUug3M7pH9K2X4T2MNEFY7jrZEjg3
         1mew0wVVwxV8hggeNo0ovTPfl4FquOwNub5tZTQgSBUoKStBe72gDhykXwz9OCuByVjl
         i7bg==
X-Gm-Message-State: APjAAAVdCnBi8P0qsapPwNLfn7e/xpMcQ42YhTyTd6xVpAjuJNjWDz5c
        bLffLVirClX6+ucV6XKtMuBXZ27r
X-Google-Smtp-Source: APXvYqxAIwOuqB3JE6/jNDEkITm0lpL/qWKeGudGwxOLyKOgjzl5WItSEexNrOyaWKX15cbsTbh3xA==
X-Received: by 2002:a17:90a:9b08:: with SMTP id f8mr104305571pjp.103.1564241883734;
        Sat, 27 Jul 2019 08:38:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6sm74034638pjd.19.2019.07.27.08.38.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 08:38:02 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: nosmp build errors in v4.14.y-queue
Message-ID: <1ab4245e-3174-f081-9dbc-0847723157b9@roeck-us.net>
Date:   Sat, 27 Jul 2019 08:38:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just in case it has't been reported.

x86/x86_64 allnoconfig, tinyconfig:

Error log:
arch/x86/events/amd/uncore.c: In function 'amd_uncore_event_init':
events/amd/uncore.c:222:7: error: 'smp_num_siblings' undeclared

"#include <asm/smp.h>" is missing. Added upstream with commit 812af433038f9
("perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_llc_id").

Guenter
