Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2000C1F6203
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgFKHJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgFKHJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 03:09:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1883C08C5C2
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 00:09:52 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so5353672ejd.8
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 00:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DtL5WAzPI6yFzxKrnFWLyzLneMVuJM2j2+7dCxmKS3E=;
        b=p1+WbNweAXsOFzeUgS3BfYbGzfF7B6WiRclhIaHuUQHTpojR3koLWggafk7uQmQWS0
         YpTFAtwdfe/OI7LUu9ruWPReU8+uwd/fPpSyYKQqze3eYK7DN8LKMBtCS5mhK08oDUZa
         hjGVuo4BG2vHyRda2E6o1mtwvIlNJkuHMMFCbpmY9ukfo4g2tr1f38PoavsekLvyaE/f
         tkB6uQNZGWSaDELmgExnFMVa7opva8ke3vskgXrawONif8lN9zXmESOjkG9lhfNLWm8U
         ihP4gRhnX1CGHg7rymRHBeQkq1RwqQk7HfP3KKRVa/bEJdX2ZVQThQ5kvx46eG6nVSzC
         MurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DtL5WAzPI6yFzxKrnFWLyzLneMVuJM2j2+7dCxmKS3E=;
        b=JBC6MCRkqHpXVFUU2g6oTs9Aiy5qpFUfSVXkydHojPhb/j7NGsIH1Rwlng9Y0Q4tr1
         2rJqpkMQx94EVW9cYU/ed04VwIdLhDSF9yzYP9D00F2DfPEoXKsiYt0aJBVfzrTps7YC
         QS5XIO/f6ubeudJg5foKTuvd+2EM4UjGYfi1yJ+OWD3TVQRUDVZZKkwX8rQMrlM5aOMM
         63UiegqG2z0tcvhMv18TJjvofHosCB9pmcwdIMdaSY0yzmUms/vaVe0otDJzaHc7iobX
         rG+DEazeKuMvw5cPiYOAJRU/GDUKbDlX3+qEW1pM6tI9gRxz7q4WZZX50DMwGkhVyTzu
         yAEA==
X-Gm-Message-State: AOAM531Gp/fVXO5AqJ2nbrzQxI+q/Ay+3mrR9WlmQHFrQlfiVTjlVRLM
        0BHwquUzPikliNeLllrU7wsy8w==
X-Google-Smtp-Source: ABdhPJyrMVsUvyqud3qgao6R3zRQh8JHC5ZCHnVwXucm82mAcTEGh2aXjGANmZwHt3g+N/SQeBsNhg==
X-Received: by 2002:a17:906:528b:: with SMTP id c11mr6867128ejm.407.1591859391273;
        Thu, 11 Jun 2020 00:09:51 -0700 (PDT)
Received: from [192.168.0.14] ([83.216.184.132])
        by smtp.gmail.com with ESMTPSA id e4sm1067559edy.17.2020.06.11.00.09.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 00:09:50 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 1/3] bfq: Avoid false bfq queue merging
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <20200605141629.15347-1-jack@suse.cz>
Date:   Thu, 11 Jun 2020 09:13:07 +0200
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <FC3651A1-DB65-4A77-9BFB-ACAB80E54F3E@linaro.org>
References: <20200605140837.5394-1-jack@suse.cz>
 <20200605141629.15347-1-jack@suse.cz>
To:     Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Il giorno 5 giu 2020, alle ore 16:16, Jan Kara <jack@suse.cz> ha scritto:
> 
> bfq_setup_cooperator() uses bfqd->in_serv_last_pos so detect whether it
> makes sense to merge current bfq queue with the in-service queue.
> However if the in-service queue is freshly scheduled and didn't dispatch
> any requests yet, bfqd->in_serv_last_pos is stale and contains value
> from the previously scheduled bfq queue which can thus result in a bogus
> decision that the two queues should be merged.

Good catch! 

> This bug can be observed
> for example with the following fio jobfile:
> 
> [global]
> direct=0
> ioengine=sync
> invalidate=1
> size=1g
> rw=read
> 
> [reader]
> numjobs=4
> directory=/mnt
> 
> where the 4 processes will end up in the one shared bfq queue although
> they do IO to physically very distant files (for some reason I was able to
> observe this only with slice_idle=1ms setting).
> 
> Fix the problem by invalidating bfqd->in_serv_last_pos when switching
> in-service queue.
> 

Apart from the nonexistent problem that even 0 is a valid LBA :)

Acked-by: Paolo Valente <paolo.valente@linaro.org>
