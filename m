Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64E4454981
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 16:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhKQPEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 10:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhKQPEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 10:04:10 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C0C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 07:01:12 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so5217741otg.4
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 07:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=OWHywtuFQCjoEmwV1z89S63Hz9h2RM/SbBR5Glvbp+E=;
        b=A1Z7I2n4rAVdq/qowK+SekEZOMYEySqpDoDC9UCGuyoz4vnjw6+04C/3Kw2a+4Tc8N
         +a4u3+wIzgkCk8uV/DC5ymCEywWT4w63f/izQdHOR1J2l/5FAzTGHtDTR4Nzag2UIXpD
         eQPph6oZFarfoshULuaU4P4x3FCsQW2uSIPBsjlR/26N+KR2jHgmrS40HbC7yf9so8tz
         8z464nxEtsYFKY2TDqJTnFbWhfjeLV7aEn8Km/sG/wnvlvf1Sj8OMq06LbjmMZTjfyBd
         lCVxxU45dk6oz5XzqwM3gJPNwmC83LhuHbv5wb9vCTTdq9ys5QMQzJoxtq/kDAhaVdNS
         8Cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition;
        bh=OWHywtuFQCjoEmwV1z89S63Hz9h2RM/SbBR5Glvbp+E=;
        b=MjsDIwUW2gtPK7HATWVY7qI8sThSACGu187JvlY+vHNv6Q7ZeQyxOZj05TFc1VEeno
         pMmQGhh4RyWjk0xB62FlbZS9XhQaqrzbs4A7nEBGk3I2XjnPCXWNZh7wwT9jamBZwF+g
         G9Qf9is/2w7xLxufL+6ZO4Fbh3GBdjOViLW7yCD6bJxwEKA2fv2evDV6BwSeHhc9Kxu4
         YHHaKRHrw7OTslYvC3Pe0W8jmeQA+9fPYr9UGgyvMc78ouHOSYQcbQswDDF41Dx3ZrFs
         7en8Ica5Q08yrSFes4q8wnpNsteGOGn3rYiikZXso4iPNqjaQRmpn0iEEKpIBJN+Nl72
         6vMQ==
X-Gm-Message-State: AOAM530Jtk+T4/hlXsV3X6nE1rOGSZF5wiuEuW+8wiwl8cc1XWl0Hesl
        gMi2mwcLCIVYIgQasGufqt9PsvNoypY=
X-Google-Smtp-Source: ABdhPJz9CbMaFiQ0Cd4GLrN++CNDcMPSuxc9qGJ5FaEsFIKzUidcKIf2uMTGSLkdSXvQD4pofCIbqw==
X-Received: by 2002:a05:6830:3155:: with SMTP id c21mr13986843ots.183.1637161271241;
        Wed, 17 Nov 2021 07:01:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bq5sm1488878oib.55.2021.11.17.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:01:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Nov 2021 07:01:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: s390 build failures in v4.9.y.queue, v4.14.y.queue
Message-ID: <20211117150109.GA222117@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I see the following build failure in v4.9.y and v4.14.y stable queues.

arch/s390/mm/gmap.c: In function '__gmap_zap':
arch/s390/mm/gmap.c:665:9: error: implicit declaration of function 'vma_lookup'

In v4.14.y, there is an additional failure:

arch/s390/mm/pgtable.c: In function 'pgste_perform_essa':
arch/s390/mm/pgtable.c:910:8: error: implicit declaration of function 'vma_lookup'

Guenter
