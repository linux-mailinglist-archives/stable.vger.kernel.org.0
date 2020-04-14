Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D6A1A7A50
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 14:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439856AbgDNMGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 08:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439854AbgDNMGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 08:06:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BADC061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 05:06:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o1so4268566pjs.4
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 05:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=jm9THyL6NHvjyPBi15ToGJy65zugr7H20iHk/cdSJyw=;
        b=QOFlOi3SiyJSh29CrjLg5rBh9w6ZZ8aaSi7B/OPkpXhnURNFu5Kae07vhrLYCPeNX4
         rakAqMmK1pT5rQk27k9914npkYLPEsrm2P9q9Q5E7K3nYw+0R2eRx5TotHZvCyQKMPhR
         jrTrCvky33YGF79+cgvWRq+DFLhgc3vKe085It7fdOnghG6Q6jP35YA7IwY02l9ZsPYz
         S4GL69rr6LeX56le+7rHlVJC8smv17hKJfuHkhkRczV1Tf9R9qHOuQW9Pl3mDWLFntYT
         GBuRT35WGP0+7Wvl+v7+E8B6ZdCTRtVaDw9xS/pkB+QFUwXhUFz20EIVRy3Anp581XFr
         Zi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=jm9THyL6NHvjyPBi15ToGJy65zugr7H20iHk/cdSJyw=;
        b=A7XPBfbW2bqeTlqoI8geKENhf0GeeXlrjJPH+CALGOi3gckkjB05TYpb0H3ZIIZJbo
         0DHq4eh9yHsTzIARdyx46E/OpylLqlIULIMxEgiRKKv47um/9xVeZdfm8roq7PCATDSp
         OJSWWbaH8dJRVFI48lhM4stDWXC5CoEomMKIJ6xRF933DL1X4rt37LMzl4xU4TNo4CJF
         bNT8ocgFcnpq/1TntI+6vs0DTemzqBiyDq8G8qPi80L8hPywmHDSN09Ab/paRciIluZT
         JCiTKXKFo9mnexsydUVJwXXe9OKwBTeTpOu0daZJA/9Lk0X2/8hh5EAy1IaikxelQcPE
         /2TA==
X-Gm-Message-State: AGi0PuZAoaCRaczHUMemHszoeaSXajXp83AFeWDiOimrtuN0DiOSbiR+
        gOqgUo8P02kkFYGfm/agSxFHGlhO
X-Google-Smtp-Source: APiQypJRXn/97TRn2MNg1Waw6AFG43jLHeMxlRcf0qV1QSSegyU9hzxzBnlJTEg+bSZdLe8Ro8YK5Q==
X-Received: by 2002:a17:90b:3851:: with SMTP id nl17mr27295147pjb.59.1586865976472;
        Tue, 14 Apr 2020 05:06:16 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5bbb:c872:f2b1:f53b])
        by smtp.gmail.com with ESMTPSA id c10sm7991912pfc.23.2020.04.14.05.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 05:06:15 -0700 (PDT)
Date:   Tue, 14 Apr 2020 21:06:13 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>
Subject: printk: queue wake_up_klogd irq_work only if per-CPU areas are ready
Message-ID: <20200414120613.GD12779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Commit ab6f762f0f53162d41 Linus' HEAD.

printk_deferred() does not make sure that it's safe to write to
per-CPU data, which causes problems when printk_deferred() is
invoked "too early", before per-CPU areas are initialized. There
are multiple bug reports, e.g.
https://bugzilla.kernel.org/show_bug.cgi?id=206847

	-ss
