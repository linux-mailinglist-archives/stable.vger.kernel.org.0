Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3F5162212
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgBRILM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:11:12 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54395 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgBRILM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:11:12 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so670798pjb.4
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 00:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version;
        bh=m4fvQJCFzn4tWJRtdGkUOAYhqBRTddzDBOyGkZzFu1o=;
        b=siyndHabVPaZBnty11yjvaaa5BBfeXjqRouS5aNOcrFipVPF4lVbwvMMX9iCZ0QDXP
         pz/Su6WDSIamqzRyLMJedQSLZ5LPwsWJB2aMEfHUbuTx89iDR64RxUBBLxoro+rTWsyK
         Z6rw5r/MUGNbTX4yTXYhkcobnOZ1SiYJBowmASahFcAbzrAk87UF7QuqafxRJ62BVBdA
         EYraDx3eTnuxDtSGHD+eoKsxuKOj4qcAbzKecPUhuNHmnz6F4CQqHh2VtskI1OmJmj7c
         0WGVPgjVS8sKNKE5FjMqAWQ4QU7WbDDpGG0zREOnLoAznZ0/7bF2Ox2PDrXt6CbVB7du
         cZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version;
        bh=m4fvQJCFzn4tWJRtdGkUOAYhqBRTddzDBOyGkZzFu1o=;
        b=lX7f/WxmeYim+Ewu+M3hEbMZJNTbtyoP8p6wDD2f4okso+xpnULONGqtoB16ra/VJd
         LKtrN4hwtCfp6Otn/znSBhR2ONK2joly9D7QdWYXIATO2OCMsWIUEzcQDBVWoNbDnk2F
         iMDPlTXv6GCJQEyThKoetGIhOQR03Dce+JJSi017aHDaOqWssJwlWA1AsWK1RNSM1emA
         Hazuem6nMjDSmdfx3+oU3MN3wPdP2U/Skw5qICb/btKKL0LHuT+QJpBqu6/h36v/imuR
         ifcxc6oXvN1VGZc2Mn8QQAJDMag+E2HgbPWDmPRL+zC22rjHb8aOwjFLJKyPr6K/v4Hx
         zbbA==
X-Gm-Message-State: APjAAAXCNSkdQBFZKQPar6jIgyyn6zRxePItDE5aURhztJSgli0yC9HE
        +BeZeoi25M7IL5ZyHy1FqPZJ7ulspAU=
X-Google-Smtp-Source: APXvYqyZkfMY5zz2vmlbKM/pbUrjexaCGMOpahh2ShMFE0tT2/UA1UKbzkCUV1TvPJV2Vj1AwYlozw==
X-Received: by 2002:a17:90a:9284:: with SMTP id n4mr1191784pjo.69.1582013471353;
        Tue, 18 Feb 2020 00:11:11 -0800 (PST)
Received: from localhost ([129.41.84.76])
        by smtp.gmail.com with ESMTPSA id z29sm3620624pgc.21.2020.02.18.00.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 00:11:10 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Random memory corruption may occur due to incorrent tlb flushes
Date:   Tue, 18 Feb 2020 13:41:07 +0530
Message-ID: <87pnecxqlg.fsf@santosiv.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg/Sasha,

The commit a46cc7a90fd (powerpc/mm/radix: Improve
TLB/PWC flushes) picked up in 4.14 release has the potential to cause random
memory corruption. This was fixed in 5.5 by the following patches.

12e4d53f3f powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
0ed1325967 mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
0758cd8304 asm-generic/tlb: avoid potential double flush

It's a bit tricky to backport to 4.14 stable (though I have a backport to 4.19
stable, which I will post shortly). If you think it's important to fix this in
4.14, it would easier to revert the above mentioned commit (a46cc7a90fd). 

Please let me know your thoughts.

Thanks,
Santosh
