Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0494220FCE
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgGOOsO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Jul 2020 10:48:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49724 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbgGOOsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 10:48:13 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jvihe-0001zT-TZ
        for stable@vger.kernel.org; Wed, 15 Jul 2020 14:48:11 +0000
Received: by mail-pl1-f200.google.com with SMTP id d13so2488196plr.20
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 07:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=LCvS2Mg+NMZP1rAlw+7qixFYYr8UXQD9EiMJwb616iQ=;
        b=HsLnXSn/85R1A1Hiqne/qwWztFOSfUZnVxsMuhaClmupxOKl7hP5xd99gtIup56j40
         m3ddlKrubT3TDZ8sHjjSv9iwCpwZoOxrd0Ujb0w+3Q43OQUDPhkfjedzTb0nOgReD/NX
         QKAi7Gqkcx5ZF0qO5TbePTBaY3jjWrJhCLUNRfG/sZirHz2Or2g8UjYweIPsnO1xPajW
         E9wLKU0ltevs7qSc91oxw3fm5t+/3zgn0kajbNws+B4BETdzKe0msoNfilXG2LRAfCUb
         HgqVfR3cUZ29YpZ1UO2Yv1oTr5KrpJqOOpbSmVP4qChlPk4UGhtKMatCgfh9mttRlMez
         XClA==
X-Gm-Message-State: AOAM530g6Nakt30CG5yRAtQAWDv8Ub5lnRaCOgx/71biaIjRNwkNM4Lb
        TG0osx5s/FzhAqTJc0AytLDpUwdqTqHaHqseIN5z6iOzO4XITz5REi9NUlSTZ5KU3LLp+2pbp2R
        IpPcOpIYZhcl4Jwkd4IGQ8gLsWTtV8se5jA==
X-Received: by 2002:a17:90a:c68e:: with SMTP id n14mr10261830pjt.182.1594824489582;
        Wed, 15 Jul 2020 07:48:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKrlh1HvbeAaJgRiC//V1igGnVxmU5HjSc1N2Q+BfJgRLVgPaPWhuIYiLFaQfZuLdvy30qlg==
X-Received: by 2002:a17:90a:c68e:: with SMTP id n14mr10261800pjt.182.1594824489274;
        Wed, 15 Jul 2020 07:48:09 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id f72sm2391275pfa.66.2020.07.15.07.48.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 07:48:08 -0700 (PDT)
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()" breaks
 NFS Kerberos on upstream stable 5.4.y
Message-Id: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
Date:   Wed, 15 Jul 2020 22:48:06 +0800
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>, linux-nfs@vger.kernel.org,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To:     chuck.lever@oracle.com
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Multiple users reported NFS causes NULL pointer dereference [1] on Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".

The same issue happens on upstream stable 5.4.y branch.
The mainline kernel doesn't have this issue though.

Should we revert them? Or is there any missing commits need to be backported to v5.4?

[1] https://bugs.launchpad.net/bugs/1886277

Kai-Heng
