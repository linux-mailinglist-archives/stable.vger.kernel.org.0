Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67328104CC6
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 08:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUHpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 02:45:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42510 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUHpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 02:45:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id s5so1229433pfh.9;
        Wed, 20 Nov 2019 23:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=wAfKf+UnyZkSPNN8BE0Uu1Clc6h1vga7Y4FsMWy74y0=;
        b=QhqEQ83qWqv3VZJC6V3071hhPrWRRZJiAdWni+KY+mDVKsZyaat/n5sLmHmBSMzRBF
         8HM/F8PNhxGvgX3OcCXjLFi2+cXW0H+pkTLD06FO8YN/PiRaW/E1OGzFFYg6OBxO7TTa
         OXGh80HyZD1QrGmasEH1+a1CDVeTyraDNPbyRwxgyj0BQqpBdTamSy65KEA516q8ZIC0
         sAZFfLrnIFmJBsdDgKkvSJG1rr9VpRKS0WFDcGJmvFwQL40+HGXYBHGZ1cUppH31zwnV
         w7HKPe7hZqUbI9WHrDRkqsEc+Lg2+L/TEkAs/qUgRs5cN+dCAec8Yeb2f5mpAhw1jx+r
         Vcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wAfKf+UnyZkSPNN8BE0Uu1Clc6h1vga7Y4FsMWy74y0=;
        b=Uvxi/rKG7d0SOe9moHTJh5dHMewfYswP5Bpr4JCo2vYYDTlyrJlTrFRXpoqL7YuN1u
         Z+zTlN52A8LGz9SRAhjrDHVD6C0BL3XZRWHGCV33qLwzL2vKkX5EOi6lDAS7HMPikp+X
         hmOhY5uVEw6r0bzePROH53TX2OibNEBELQxMijtLJEakgbH5jjt5cKKJDj1heJbSYpkd
         MQG5uAZb23EF0KZHnpwrO0Ztnawc4YddemedRzac7HMeIpjbMclFJ/Yp4mJ7BMs//S5H
         +kjXlykO2Xojgi+k8Ix4rexFBdpmk4B+blSwsUGElFS5r8Kg4i4T7EYYq4hetGZw6ypV
         G+IQ==
X-Gm-Message-State: APjAAAUiEe34mSSGS3DPzg1H0/DdhUYTi9IJZJgWywIols4HHG6b6F3V
        5Zfti/54vomxOUtB8suqPjgW6sRk
X-Google-Smtp-Source: APXvYqzVfKugtGr1YB/LFgqRsz0Oc++YzcBfW7T/xG2wEgk6APYK/a0RKYoZxiYJ20qv8m1DOF4zQQ==
X-Received: by 2002:a63:b047:: with SMTP id z7mr7983274pgo.224.1574322330409;
        Wed, 20 Nov 2019 23:45:30 -0800 (PST)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id y16sm2060372pff.137.2019.11.20.23.45.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 23:45:29 -0800 (PST)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id xAL7iqtf015431;
        Thu, 21 Nov 2019 15:44:52 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id xAL7iqI8015430;
        Thu, 21 Nov 2019 15:44:52 +0800
Date:   Thu, 21 Nov 2019 15:44:52 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Cc:     stephen@networkplumber.org, ast@kernel.org, songliubraving@fb.com,
        yhs@fb.com, daniel@iogearbox.net, itugrok@yahoo.com,
        bpf@vger.kernel.org
Subject: [PATCH] bpf, x32: Fix bug for BPF_ALU64 | BPF_NEG
Message-ID: <20191121074452.GB15326@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b9aa0b35d878dff9ed19f94101fe353a4de00cc4 upstream.

The fix only affects x32 bpf jit, and it is critical to use x32 bpf jit on a
unpatched system, so I think we should backport it to the only affected stable
kernel version: v4.19

Thanks.

Cc: <stable@vger.kernel.org> #4.19

Signed-off-by: Wang YanQing <udknight@gmail.com>
