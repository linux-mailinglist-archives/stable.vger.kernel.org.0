Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1CB624CFC
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 22:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKJV2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 16:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiKJV2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 16:28:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B8F10B59;
        Thu, 10 Nov 2022 13:28:33 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so3023233pjk.1;
        Thu, 10 Nov 2022 13:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80I3arJoq2GrS2cZeP4yUcWNDKrQfchQjs2gAQ+Po1Q=;
        b=kkwpINsNl2KamFdaIA8i5cwK+MyS/iW/atr4aE6Lt1JEM9hUlrN+crn+2jRCqkRWG6
         MZdN2JLklsJbjDokxP000kp7jZD2YYo1qNImhAvicIvi2aZCqwQV2MiWGv1LlDTcyUSO
         lUf/e4R498GCBixdP1qz3j/GJwT9PpFW1OyGKsqPzLfR9ir0+hqo3nICS8CZD7QjAAx+
         6HwXWnBeowR41Un3FlbHoRkLAy1ieMe2gIGHq7J+9H4APhbDvDQoixPCimx7lw0eWljk
         5usUz7URWDFUojHM7WQIc2Vm+1gwm2VuZVzE+dJLlbxAHpXnDYMgWvDy+p/SZOnP/U6z
         /ZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80I3arJoq2GrS2cZeP4yUcWNDKrQfchQjs2gAQ+Po1Q=;
        b=FdweV6Eqacl45N4CFxU7Hxugn551xI3ja0/oz/ZpvmaIumU7Dyrt3UqIU+dj8cfygg
         jhHFWLhDXfNpnoV98p2DybvB3Y9Ul084G81ReaQ2nsCZyEYlUNm84ix12kSH8BqZbKDP
         66bJMHTW1bhkz81HTOkbxU8ppqQAbhT2LihmrQG31bUSB3Izxp2xDJXiESqGRuKQcnJm
         0gPDhRjFkO4NELv10TPtue7cTBt3mAnxYHckFsqSATTDUE0QMTgK9eyaJNCSvlQxA1xG
         FA2+SlR390GWjAMDcWH4rrLreXN2/zJ77aXnvVWgquPv6MeEbDky87ZOOzNRtgeWtuaJ
         ZvIA==
X-Gm-Message-State: ACrzQf3nnSHW8ocDh+spVADuxi2RgK8J9PzsrBf288lwW7ziokGZKm/W
        9I2s3dyFojw+fJjXJXqpvdg=
X-Google-Smtp-Source: AMsMyM6AHXBx6OBeNoBiyE1b8AO/7FnghYsNzO2ZZKvU3O+Mdgo0L+OPUSN49TsnmMLfbSdK53UB5w==
X-Received: by 2002:a17:902:b10a:b0:180:be71:6773 with SMTP id q10-20020a170902b10a00b00180be716773mr2165321plr.42.1668115713084;
        Thu, 10 Nov 2022 13:28:33 -0800 (PST)
Received: from smtpclient.apple ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id w184-20020a6262c1000000b0056babe4fb8asm118031pfb.49.2022.11.10.13.28.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:28:32 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20221110203132.1498183-2-peterx@redhat.com>
Date:   Thu, 10 Nov 2022 13:28:31 -0800
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <65FA2E7E-1F12-4919-BD79-11159934CF2C@gmail.com>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Nov 10, 2022, at 12:31 PM, Peter Xu <peterx@redhat.com> wrote:

> Ives van Hoorne from codesandbox.io reported an issue regarding possible
> data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
> sympton is some read page got data mismatch from the snapshot child VMs.

symptom (if you care)

Other than that LGTM
