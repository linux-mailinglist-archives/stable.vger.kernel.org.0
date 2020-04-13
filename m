Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451801A6C7F
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 21:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733186AbgDMTbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 15:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728291AbgDMTbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 15:31:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA50C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 12:31:13 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a81so11153113wmf.5
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 12:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+1oIAGp/+mYXSIibcKMNOMtcUpS8aqG4LNCJREQx4I0=;
        b=vvLr0PCo3ceEpektVTQVrt0+tx94n9iBTlGZAK0bjFj/z9kb8ZLiWacNCe2ovRkYDT
         cqOTXc2bCABkHPKafkdRaCpUWJs0kvwVhY5edDr5xdnOe/nbMibOHRjEi0kINxp+kLCb
         lKVPejbfruG/nFaxDR1iyxn4c+Dh4XO/cyw28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+1oIAGp/+mYXSIibcKMNOMtcUpS8aqG4LNCJREQx4I0=;
        b=b1AAi4xFlDaMLGEzROM77eYG4gO8G/3SRhQ41eG+dQQ93hQ0VPsWrpXTMXGl9tFBG4
         cbqpNZM56dOom1P1oLHHenhEnl2+P+6O1YmSh80gYEZI8qW6Z5B0gF5Pw1jMEJSUJdYv
         7QdmfjP7PqQUsV6qSua+qp7RMlRxuh/iyBnIh6kF4Tyj7n2V71yGi0d7nHlCfQue9t16
         mHmKLOx+k/EvqMIRYMuvOjWKYhjf4gHlIILN4B8XixABfzssZBNuHrCRXVhZ+QOACvMX
         Ef1EOnr+tM+/xOw7IPodi38R34i6F6WxHcCn2qF7lZJyvflTbRgpDH3tB1NTlZi+N4Eh
         0Smg==
X-Gm-Message-State: AGi0PubY8mqNMaFjwvD2LirSUA8enWQatCr/rdyCkZsUYwZLf0T0yiRa
        UmqVbY64cBgmWBtAPJO+Llhgcg==
X-Google-Smtp-Source: APiQypJ/mpnsEUj9pgbNcu3Pv9+/pt/Nlq9mWca5Q620EPZGmW/XoR58jV5Qp4yL6uvl0K4Q65v1QQ==
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr19450264wma.19.1586806272067;
        Mon, 13 Apr 2020 12:31:12 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:fa59:71ff:fe7e:8d21])
        by smtp.gmail.com with ESMTPSA id v10sm3754208wrq.45.2020.04.13.12.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 12:31:11 -0700 (PDT)
Date:   Mon, 13 Apr 2020 20:31:11 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
Message-ID: <20200413193111.GA1559372@chrisdown.name>
References: <20200412140427.6732-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200412140427.6732-1-laoar.shao@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yafang,

Yafang Shao writes:
>A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
>memory.events") changes the behavior of memcg events, which will
>consider subtrees in memory.events. But oom_kill event is a special one
>as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
>in memory.oom_control. The file memory.oom_control is in both root memcg
>and non root memcg, that is different with memory.event as it only in
>non-root memcg. That commit is okay for cgroup2, but it is not okay for
>cgroup1 as it will cause inconsistent behavior between root memcg and
>non-root memcg.
>Let's recover the original behavior for cgroup1.

Can you please explain the practical ramifications of this and show an 
explicitly laid out example of how this manifests, with numbers and scenarios? 
It's unclear to me that this is a real problem as is -- it may be, but there 
certainly needs to be more information.

Thanks,

Chris
