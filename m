Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C07461B22
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 16:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbhK2Pkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 10:40:51 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:47146
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244980AbhK2Piv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 10:38:51 -0500
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 70F2540009
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638200132;
        bh=tf96AuO5x5gjp6koQeTaZjV3TfVhaiadm4gVY/ssPY0=;
        h=From:Subject:To:Cc:Message-ID:Date:MIME-Version:Content-Type;
        b=IFG+lHwQP3RkS/mSaK1drPo5kbj6CASSintGwAkI5b59bXilvaTMA6ag7fPvLTIt2
         R2+1mweyok/KPFkq9jHCAEthtd//xRbHEZVvdZg18I06W6gwLhWxR6WGoZB7Y9kagn
         nzu7EXhYNBGQ0hFBQpLrboSbh+H5pHF0/ADuZCCmT39vSnLz63YTZuWL5+7u/lDwua
         8qlVbGw/+9RdJ+LffNSGvsjey2imq39YRhBG9LXonO5CGxEXwB85AMdSAqazuELhiT
         dvNLuVqBTnaeQlfS7RpEVnU5NcPG/wWgmB8lM30q2KtqqGnjE6BB24sZj2pO8b/IEv
         rvEum9PQoh+OA==
Received: by mail-pl1-f198.google.com with SMTP id 4-20020a170902c20400b0014381f710d5so6538335pll.11
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 07:35:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tf96AuO5x5gjp6koQeTaZjV3TfVhaiadm4gVY/ssPY0=;
        b=McjU5n/FnTM09q3D8VlUpFLsolIde2Ae+0XT9YCChnQV1sXgk8KZ6gYVzDF5UYRaCp
         q+D2drQG/4qG+8AZvTsOVOhmIyWIPX/pXbPgVEh5vKdMdjjlEMts87Ar88TCxQT75aq3
         u/Q0h0lUK9CfVSFgLPYbJG8okzBYbNfboMWcBL1euijvKMvrFALVAPL5dkcqGy4a5EsN
         JoVoa7uqYr2QdcW7P1GF9euM7ZXlDYvcVkit87WczRYUCQ/6ouI/nBz+7l3fSgPlIVX3
         PcVigYjfhzbNeGPR/uD/RDwdoXC+9CcP0xN3XwQjpcl4JMl9Tv/a74xWQozIBKYvylxI
         C5Gw==
X-Gm-Message-State: AOAM531nqHhsG/kifmOtM5xBr8Xp1SeuUxXDG9qB9tIWKEPQ9ybPd5NQ
        QVAwxQMjZbACH56NZM1LngKiiC7y+NrefxCxe32Ep3uSVpJdBFXD4MWq9om+hc9x1zfzQU6EP1O
        oYNoE8JtCHADfxj+Og5x//umnqOszZLypzg==
X-Received: by 2002:a17:90a:bf8a:: with SMTP id d10mr38703473pjs.67.1638200131115;
        Mon, 29 Nov 2021 07:35:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrtghVy2cB06KZtU+MpQ0hZ+SPUtpz89k2kZUBlz6J0QLHMTxsDRgbAg5O5FYs/Nbm1imESQ==
X-Received: by 2002:a17:90a:bf8a:: with SMTP id d10mr38703435pjs.67.1638200130843;
        Mon, 29 Nov 2021 07:35:30 -0800 (PST)
Received: from [192.168.1.124] ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id u30sm12251881pgo.60.2021.11.29.07.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 07:35:30 -0800 (PST)
From:   Tim Gardner <tim.gardner@canonical.com>
Subject: Commit f980d055a0f858d73d9467bb0b570721bbfcdfb8 causes a regression
To:     len.baker@gmx.com
Cc:     pc@cjr.nz, jlayton@kernel.org, stfrench@microsoft.com,
        Kamal Mostafa <Kamal.Mostafa@canonical.com>,
        linux-cifs@vger.kernel.org,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Message-ID: <a8b2287b-c459-2169-fbf4-31f3065e0897@canonical.com>
Date:   Mon, 29 Nov 2021 08:35:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Len,

I have a report (https://bugs.launchpad.net/bugs/1952094) that commit 
f980d055a0f858d73d9467bb0b570721bbfcdfb8 ("CIFS: Fix a potencially 
linear read overflow") causes a regression as a stable backport in a 5.4 
based kernel. I don't know if this regression exists in tip as well, or 
if it is unique to the backported environment. I suspect, given the 
content of the patch, that it is generic. As such, it has been 
backported to a number of stable releases:

linux-4.4.y.txt:0955df2d9bf4857e3e2287e3028903e6cec06c30
linux-4.9.y.txt:8878af780747f498551b7d360cae61b415798f18
linux-4.14.y.txt:20967547ffc6039f17c63a1c24eb779ee166b245
linux-4.19.y.txt:bea655491daf39f1934a71bf576bf3499092d3a4
linux-5.4.y.txt:b444064a0e0ef64491b8739a9ae05a952b5f8974
linux-5.10.y.txt:6c4857203ffa36918136756a889b12c5864bc4ad
linux-5.13.y.txt:9bffe470e9b537075345406512df01ca2188b725
linux-5.14.y.txt:c41dd61c86482ab34f6f039b13296308018fd99b

Could this be an off-by-one issue if the source string is full length ?

rtg
-- 
-----------
Tim Gardner
Canonical, Inc
