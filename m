Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D2104CE4
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 08:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKUHrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 02:47:31 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37161 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfKUHrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 02:47:31 -0500
Received: by mail-pj1-f67.google.com with SMTP id f3so1094748pjg.4;
        Wed, 20 Nov 2019 23:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=bPzli0UbnIkOuw3Obh9ByfekwddOHEm4S9pnT6dhJAw=;
        b=fiYcxH6U0LxbtGZxga3o8u5x20JnP+ppgJdVTAfnkK9kn2X/XzwWAHbyq5JzJ1nGxv
         KFAJSnZKm8uZyYQDe81yPlfKl2UkeJEGl1AA4mDvxT5raq1J+zU8gwKT0rdCiiacRaGa
         pASYPbuFQ320DGsYaviIK5Jr771oSniNrEbkgOvG7YOZXm4jwGpilriveKcngGJK8mon
         i95fzCdgJU1blqz0LuQ9Vk8HNlutNWCiKegu6B3xeNQviYrCTEiKVo3O/eQeo6xA1HRt
         PEONxO8+ktmhqr0eZrZHOd2bhlnKaBZegGUAukUm1saGnF2YMOhA430KIfLBhW+NXHBj
         EyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bPzli0UbnIkOuw3Obh9ByfekwddOHEm4S9pnT6dhJAw=;
        b=aofMssRGhuXG2sgZ84/Ff3gB/3HDWRtCPNd6d1O9RBokTaXNncAk0VhykpMFXIl+hd
         YKATozw+QaxBa8H2hKuTDljr4tgNLKfEfw44TX+hlbcYRdbWC3lvfqWjfUS03H6fmgVq
         +LPBrTtFvgNVTBcST28hKZCkhf3SPqjSgLTDc1NrSDjCOcSRsW6UbWNT70iDjayjnDbX
         lry2k8QYoil2PlsQTAcbYRNzn5Kxh7c/ItdGuXk2o/QEsgcOWCkXeO9RXHxFho2VpY+N
         CRHzLaeKkOlU7shsRpBukzaNpwNf1RD7er6WTeiV0BpH/MKThowfZOiFvN6xOLYCW+RL
         6obw==
X-Gm-Message-State: APjAAAWcQ5v2PlXdhaeS8NkO8Tt6wJbqe54Xkr86RKHhHE+074mBkbZt
        6+ZFJ6odXs/2qK00CJLFj0RM0BNV
X-Google-Smtp-Source: APXvYqzA4wKcUaP3fSi0u49yfp0Cu1bVQg+vavVdmm0K5SRY2Yu7k3JEDUOmxc17MPSHJGg3pGlvhA==
X-Received: by 2002:a17:902:76cb:: with SMTP id j11mr7070605plt.50.1574322450729;
        Wed, 20 Nov 2019 23:47:30 -0800 (PST)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id t27sm2118278pfq.169.2019.11.20.23.47.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 23:47:30 -0800 (PST)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id xAL7lQeW015510;
        Thu, 21 Nov 2019 15:47:26 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id xAL7lP2k015509;
        Thu, 21 Nov 2019 15:47:25 +0800
Date:   Thu, 21 Nov 2019 15:47:25 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Cc:     stephen@networkplumber.org, ast@kernel.org, songliubraving@fb.com,
        yhs@fb.com, daniel@iogearbox.net, itugrok@yahoo.com,
        bpf@vger.kernel.org
Subject: [PATCH] bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by
 0
Message-ID: <20191121074725.GA15476@udknight>
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
