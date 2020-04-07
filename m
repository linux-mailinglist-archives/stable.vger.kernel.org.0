Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D92F1A09D2
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 11:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgDGJO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 05:14:27 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:40145 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgDGJO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 05:14:27 -0400
Received: by mail-lf1-f54.google.com with SMTP id j17so1776345lfe.7
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 02:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6OtopnAAEq7RcaO3cYzbThDgjEImIu/ZUC/MK9b+8Qk=;
        b=N9VSIZQuml59Tid/3BT8Vv4Sl3yokkoCg6reujsWc0KVmCdZMyecSp/JlJ5bRFLMfx
         3oEg5dE+ElyxX76iOxKMp8b439iMCs5lrNXjrIO3VqB+0WP4iInZWzceXD0wNI+VqQPk
         n8LP6LTxMSNYh6XvAAoh/2rLEUZfgWzlTbFU+ThhE+qFEcYl3fTFc99sVuIHcvh2oRVo
         F/7Y9Lj4MEndi2rtAbUwoyLYjzu10I+wrv0GkyOXtzYsT+h2jZyY4KZUOX/q6fLO2+Sk
         crkqYg8AcOeIXQfefQQYKJRFd3hBg5pkw0LosD1pDaBbXt8u6BEY/WXxDULmROayJbJ5
         VwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6OtopnAAEq7RcaO3cYzbThDgjEImIu/ZUC/MK9b+8Qk=;
        b=q+5/VORe6J3Fb+KuM+xm4B84ykssTh+IdtBV+oJpBh9k8M1TnGVeYNZp3XAuMZHHo6
         adj+zRXvWg6Sny6FQPgn69Z7JGSyENSpUDHDDtNKoh/aXNEd8CKQKGZyupZ3vpFdBR7E
         4ZSHe/6VctflQBQfIUO4b4Gmawu4n8utzKX6MKq7xS9ci+BN/7DEpWHnRvDKsaiJEycu
         q9EMqlvoNVUJBgJ0993fTC2+pylsST/NSKKxmLn5inaqXE5xOroSacEhAJUQ8GAKBcCL
         ErzLkGKQkMEFlkigZsc4bxuhN6cErn+9ADMTKsk93RVLnu+mqkH2s0U3jY/qkB9LO9zY
         wS5w==
X-Gm-Message-State: AGi0PuYwzCeCCAd6vQMI38axD+WX7r+FeImNRJ3qCiTqakfd6J+chs/D
        yZUIj5JL/+lKjrYIb4AVHhz4PgjIVkrPyg==
X-Google-Smtp-Source: APiQypJGoa7tB+BMSHzRLxg2kNe/UtYrewh2+8LZfB0dIpTElAeYYLhQvYMMPeS2DRMexOD8gZbQCw==
X-Received: by 2002:ac2:5559:: with SMTP id l25mr936737lfk.55.1586250864387;
        Tue, 07 Apr 2020 02:14:24 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:46df:46e6:40f1:f0a5:2488:8311? ([2a00:1fa0:46df:46e6:40f1:f0a5:2488:8311])
        by smtp.gmail.com with ESMTPSA id m17sm11470733ljb.61.2020.04.07.02.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 02:14:23 -0700 (PDT)
Subject: Re: [PATCH] libata: Return correct rc status in
 sata_pmp_eh_recover_pm() pwhen ATA_DFLAG_DETACH is set
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, axboe@kernel.dk
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190327090254.10365-1-kai.heng.feng@canonical.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <6c0f9cd4-13a7-3f5c-020f-2401de9e42b7@cogentembedded.com>
Date:   Tue, 7 Apr 2020 12:14:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20190327090254.10365-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

    s/pwhen/when/ in the subject? Also, I don't think "rc" is needed there...

MBR, Sergei
