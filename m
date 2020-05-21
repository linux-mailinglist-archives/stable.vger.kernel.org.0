Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A071DCEB2
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgEUN5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgEUN5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 09:57:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B54C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r18so5361659ybg.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1xlOQNovCivuWKUAbP06Cb/j7GfLljsFtT455sTFP5U=;
        b=dlFWimWB6JorptEo3xFJxXhpXtu8oK3gtfgFD3ydUOg4w1d7GogW9cmJzZ4zCCmsS0
         aPbNF3e8IZy2Ek3W9vYiW5vbnht5IK6+mq9MNA9tNnK3xzt+Qb+sHY8uBHslZP9LatYZ
         y7sCfnclZDcmBQd8mHrtBR/794ZU+8xXR8khBHublkLDLn0gE/BfzvlGkd4PMZDn1b6F
         Rqlha4FLIjoUHqFC7Aa7wrU8UDy9BjBYqleAG+IX/0FW2PC0N+U0iXHrncqUadLtOUoB
         v6x6Td7QES7AJVO4Zj4gl6Po+gZva4NjAeoeQonlBkB9yhrbe4sEQUFHglVFEWubWJMx
         VrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1xlOQNovCivuWKUAbP06Cb/j7GfLljsFtT455sTFP5U=;
        b=MHQM5pRNG1jauvz74FnWkub9jnQfykaT9XN3Au9yp6WcZ9qFUT3icH6pkZfoEZcti2
         RW4k8xvPItcsxEgtftXBd65HZk/Jmqlye3hD013yu29kB/zNMEPXPcl/ce5Q5gK5/qx5
         oIiUtF2QE6blLO8ZLmuwnEtQke0gJiNez9VLHZKj4bpnlzSTTpb4Uwdl6glMVhKS5adB
         GaH0FToFXBWg6Mv6b9GtaLVcM4OgLJLM3LMeheC7jZdq5s1m4m7G//wMnddzB2kfuUGX
         lAg63ZCvA05gzNY6MKguYOnSj+/syuFnzR0L/ZNRZpCGSJvsV7TV2W4A6xOOyEUWdGW/
         Q0Lw==
X-Gm-Message-State: AOAM532f3RM+1Yt97RvW319blwO2HPdGJn92chuNVqIpzCAgtMr1/yFg
        uH03Pq+ilVah0OWsoUDOK4FcXbDqHg8hew==
X-Google-Smtp-Source: ABdhPJy4kenILXALQ9HxREiuSaleHD6P3RZ0YMJUBLxETgg7S2U60z21vXuURzIriOyE20FOe3yVGaUnRDHsUQ==
X-Received: by 2002:a25:8082:: with SMTP id n2mr14965289ybk.427.1590069427812;
 Thu, 21 May 2020 06:57:07 -0700 (PDT)
Date:   Thu, 21 May 2020 14:57:00 +0100
Message-Id: <20200521135704.109812-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 0/4] [backports] fix l2tp use-after-free in pppol2tp_sendmsg
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg.

This is for 4.14.

We received a PoC (code to run as root with a KASAN kernel)
demonstrating the existence of a use-after-free in pppol2tp_sendmsg.
This was accompanied by a patch to resolve it, consisting mostly of
parts of patch 3 plus a little of 4.

The following patches all apply cleanly and compile with allmodconfig.
However, I lack the hardware to test them.

The changes are already in 4.19. I'll post the changes for 4.9 next.

Regards,
Giuliano.

Guillaume Nault (4):
  l2tp: don't register sessions in l2tp_session_create()
  l2tp: initialise l2tp_eth sessions before registering them
  l2tp: protect sock pointer of struct pppol2tp_session with RCU
  l2tp: initialise PPP sessions before registering them

 net/l2tp/l2tp_core.c |  21 ++--
 net/l2tp/l2tp_core.h |   3 +
 net/l2tp/l2tp_eth.c  |  99 +++++++++++++-----
 net/l2tp/l2tp_ppp.c  | 238 +++++++++++++++++++++++++++----------------
 4 files changed, 238 insertions(+), 123 deletions(-)

-- 
2.26.2.761.g0e0b3e54be-goog

