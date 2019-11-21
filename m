Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F7104CCA
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 08:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfKUHpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 02:45:35 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:47053 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUHpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 02:45:35 -0500
Received: by mail-pl1-f195.google.com with SMTP id l4so1166675plt.13
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 23:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=bPzli0UbnIkOuw3Obh9ByfekwddOHEm4S9pnT6dhJAw=;
        b=qeVdompd7MsyOrNmmhkKOQfjDUIOutiTZSWetVdJtQGNSAW9QVmGT5Abg172zxsLc+
         mdRBlcIOCbJDfeLjbbxrHgOoWvKxFXcLYPTOErYdwfTqLQQ7iECkSEOR8tiL0ZgNfGsQ
         c7GmWYygqY+dlpiviMOmtl2rRbAh93UEQqGNgs3YkccEJnXlWvZPkJgvDWfsLHPekgI7
         343L2MT/9V+VEoJ9cpjWLs7rHxU1B7/+zkBfdrDnEvlq5l5lLBJ4eo8Io8k8z9Zoxad4
         OVodCvslR0oETSjknoVIAJDB160A9DgK4jigPn+wI/qU8Syxcm5uAu7kGEo2v6cKTuiF
         czbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bPzli0UbnIkOuw3Obh9ByfekwddOHEm4S9pnT6dhJAw=;
        b=jphx5m2g7U0v24LEMyFL3mHX/xI7JQpwfMi8FVveP2bLod7dZ9bj4kJLlvnsI6FWzE
         l0g0vqg5l90aCgPkJjNZx05bxN201OHP2CoGwq0UmU2d6fUw/GtPAfLYdsQj2Z3InuXu
         hNrzYbCGqSVQwQJ78hQPUZECbn4s+43T3NJqp8m/BThHbqa5N7MCeT7bheeaCIUxxC6B
         zV76cEpq/ZN5LGjOU8IaB0N/0OaGCF/apwBxqYOKpBLFV2V1Po9UoeYSs1K3fTkko/0g
         S49lP5Qh8Z/pDS285hpCFezdzIQsv6azBwtbQrXGFB4gMPYSQOsjkXVmOZWfNsjnaaRu
         qrrA==
X-Gm-Message-State: APjAAAV5LHEAFcM5RqUK7jeqXy0Iq8hDFCDqNRtn20FlmZmHddxsFxT/
        AwVx/+is2EJa0roMBthM/5KjuVGv
X-Google-Smtp-Source: APXvYqzRVpHcfCB3hzpPLnq8R2HrUYmriEvr21kF9A/BBuR7jVGhWHMwM1jaAYgo78pg36KxFSCz1Q==
X-Received: by 2002:a17:902:d70a:: with SMTP id w10mr7426861ply.279.1574322334279;
        Wed, 20 Nov 2019 23:45:34 -0800 (PST)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id c9sm1943811pfb.114.2019.11.20.23.45.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 23:45:33 -0800 (PST)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id xAL7jTAb015461
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 15:45:29 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id xAL7jTpt015460
        for stable@vger.kernel.org; Thu, 21 Nov 2019 15:45:29 +0800
Date:   Thu, 21 Nov 2019 15:45:29 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Subject: [PATCH] bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by
 0
Message-ID: <20191121074529.GD15326@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6fa632e719eec4d1b1ebf3ddc0b2d667997b057b upstream.

The fix only affects x32 bpf jit, and it is critical to use x32 bpf jit on a
unpatched system, so I think we should backport it to the only affected stable
kernel version: v4.19

Thanks.

Cc: <stable@vger.kernel.org> #4.19

Signed-off-by: Wang YanQing <udknight@gmail.com>
