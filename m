Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A420860E52C
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiJZQBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiJZQB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:01:26 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E2110FFC;
        Wed, 26 Oct 2022 09:01:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 21so8300738edv.3;
        Wed, 26 Oct 2022 09:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eh+SEU+HnlEQUbzfnGbfU7kWNyEwnXy9QRYac8VJ2Q4=;
        b=NpxL6YqAXQlu73AZJIkFuQX1ymYP/ct6mf0wbAK5OulIJMkr2/uBv7rqvE8RaazO86
         FqB0tJYiiMaS1mlmkvuRE4tduf33y9xTYa7GOtdf6Y9L7O6iW1DDKcLiGPVfCzoHF4oM
         vfZhchwk3lS7saoKnBYPcAZ2P1senLC8gdVGeETVCkiErXPEpfxnYegKcXRLoKD0HjSG
         zzk0jEfAENn3ajktr3YQK3ASMLyebtbJVpy+5IqUBHMQ9vO4HeC+ZSUsIImTjwEis8P+
         +OTw+6hiOF/M+ROAlVhZoXIAWf8llK6Lh+GbRiVGcWnIvhEM9FHbGHynCPnsgNjSUPM2
         2o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eh+SEU+HnlEQUbzfnGbfU7kWNyEwnXy9QRYac8VJ2Q4=;
        b=tMPQw49zOgzU40K2hnoDMgyGa3JDb/IPFRHinZlKoPsMUhZv84fvK/8Q3GYe7Lf28N
         u1+Eu16RnuOmw+JIvAkKOoHX6s7PAmJR6MsIS5znmTqo5vvSwVZKigUDngO+z+4FrGzm
         E519i50J188zr6OEqZByitzqv8AoMo2PqJu8pG6Cz8kjMJNO6roVg3mUjdT2iHNvRAJh
         igXsDcBrTN4ECqklll6NTZgfCFVKVCEY2z2jfGepNNw5T7Qi3BopbGMRoutdhXp61fDj
         K8hfkLLvoEakrmD8UtcUbKSpgqiApAk2JsPO1cv6gG1lG9VStHOggeI4REq0QiVkDls2
         4EVQ==
X-Gm-Message-State: ACrzQf0ps2lu7JKtPzWmObiq+7skjp00SSy2rNLcgNkBV1u6gE3acjIR
        bZSMYerTlIfoiFOZ+D0+B8o=
X-Google-Smtp-Source: AMsMyM6QXU8xfCeZGqtR6fz4hE0zcKx1lhuevTCZW36Q97qDQJUfxPXiBCuH/bsGX9HrCq73gGDFWA==
X-Received: by 2002:a05:6402:358e:b0:461:ea80:fb61 with SMTP id y14-20020a056402358e00b00461ea80fb61mr12685675edc.356.1666800060420;
        Wed, 26 Oct 2022 09:01:00 -0700 (PDT)
Received: from michele-ThinkPad-T14-Gen-1.wind3.hub ([31.190.164.33])
        by smtp.gmail.com with ESMTPSA id j6-20020a170906278600b00780b1979adesm3133449ejc.218.2022.10.26.09.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 09:00:58 -0700 (PDT)
From:   mdecandia@gmail.com
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, bsegall@google.com, edumazet@google.com,
        jbaron@akamai.com, khazhy@google.com, linux-kernel@vger.kernel.org,
        r@hev.cc, rpenyaev@suse.de, shakeelb@google.com, stable@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH 5.4 051/389] epoll: autoremove wakers even more aggressively
Date:   Wed, 26 Oct 2022 18:00:51 +0200
Message-Id: <20221026160051.5340-1-mdecandia@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823080117.738248512@linuxfoundation.org>
References: <20220823080117.738248512@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=0D
Subject: [PATCH 5.4 051/389] epoll: autoremove wakers even more aggressivel=
y=0D
=0D
Hi all,=0D
I'm facing an hangup of runc command during startup of containers on Ubuntu=
 20.04,=0D
just adding this patch to my updated linux kernel 5.4.210.=0D
=0D
The runc process exits if I run an strace on it with the strace_runc_hangup=
.login you can find here=0D
=0D
https://github.com/opencontainers/runc/issues/3641=0D
=0D
with more details.=0D
=0D
Testing it with previous docker-ce/containerio releases, just hangup the ru=
nc process and it will remain locked even analyzing it with strace.=0D
=0D
Any idea or further test I can do on it?=0D
=0D
Thanks,=0D
Michele=
