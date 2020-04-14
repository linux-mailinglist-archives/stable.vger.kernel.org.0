Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11311A8918
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503772AbgDNST3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 14:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503749AbgDNSTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 14:19:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1091AC061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 11:19:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a25so15635484wrd.0
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 11:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z7RFC4UDtzgCMtAJ4kXgnhBcp8pqe2wl7bATSZuLIp8=;
        b=ZabiIsnKOXCTJXyogEKJpCwq1zS8Jw3TAlujYBoIO4yOLNmRfAVC8Pa7oqniSHaIJq
         /O9zEPxrXF8t3pdSrZMt9HXXqgFJKqlelr77T/4+2pqChLj+uSdTC4eYckCYYHF0998p
         MAZUcGtwfnkqNAqbV2yEsbF3sqP/oj9i89GHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z7RFC4UDtzgCMtAJ4kXgnhBcp8pqe2wl7bATSZuLIp8=;
        b=P6+NWu8RuT1xz5V9/3G6zkwpJ/WBNrxnN3Kv9SK6WooGTyDar5akB4HoXlszB2mAPS
         xja0evxWZ2qzhR7FzH7vZkBMQ5ctAsR7fy3B+7t2G2HMA/uKiUgZ6FvyqqH2Ug3zSO1D
         pjOTmJsP/V97TfLwVGZyFCq2+TtJ8wAo16fr6OV9UIigUxA82DpyRLOJuBfd2AVvGj8c
         1HTDQN6SO0ymt/la/1dI2OfJOEgrpK8cT1HFUw9jBGgY3Q38Qd+1Aty443R+V6ttnhzr
         rZE7CqdzOmAuTE3kTx9UAk8klrhris3TkSp0gaoIItxp9Mw9QYE+k/BJiJ5sN6rehVFU
         18oA==
X-Gm-Message-State: AGi0PuZIFIGAwG4nO5lrXStklKhQG1II3IeYpbOlIe7d+plmqecDDopL
        4I/Gt9c4709IqvTo8Uoz/ByZeg==
X-Google-Smtp-Source: APiQypKV/3UJOcqK3Sh2XmER1j4Gy9/Bk5W4wFBXa6VwIKBTfArTgta7dQg2ChilaDi4JSY+ljMsDg==
X-Received: by 2002:a5d:464d:: with SMTP id j13mr23656702wrs.269.1586888362635;
        Tue, 14 Apr 2020 11:19:22 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:fa59:71ff:fe7e:8d21])
        by smtp.gmail.com with ESMTPSA id n4sm19211798wmi.20.2020.04.14.11.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:19:22 -0700 (PDT)
Date:   Tue, 14 Apr 2020 19:19:21 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
Message-ID: <20200414181921.GA1864550@chrisdown.name>
References: <20200412140427.6732-1-laoar.shao@gmail.com>
 <20200413193111.GA1559372@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200413193111.GA1559372@chrisdown.name>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To be clear, you're correct that this wasn't intended to result in any changes 
on cgroup v1, so I'm not against the change. Especially for stable, though, I'd 
like to understand what the real results and ramifications are here.
