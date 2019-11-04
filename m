Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF6CED85E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 06:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfKDFQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 00:16:36 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33989 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfKDFQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 00:16:35 -0500
Received: by mail-pf1-f195.google.com with SMTP id x195so7875292pfd.1;
        Sun, 03 Nov 2019 21:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QPVsSzauonGoSZqoD8d7kSBM/msp74JsZg4mWGaLQZg=;
        b=l6YcaQbpRN0zbGoPl5zfSfMdLvkm51Ez8pCUOWEOq+RggHwECBLZwL0e6Og+dSvk6J
         h7CNBMKs0lZXnDMFsI33r4EgJktOZ5ujMnErijHNCyRepE60WS8SJM5t8NSfsb7U0ffU
         jJN1brEvKXB4TuLgAZsh85KrdRPXVBs5L5CoJSiTsDi61K2lTkiWF9dEqJTMbC7yO0l9
         P61RjqsIYd4dzdV80tIRBhOjTGUDVrcIcAJAh2JNzIPvUEgMLdDbDSUJfbwhKig9s5es
         GzSyWigioRUnivocmKvPU6pBpnEpiyTVNNY/WaXYY4WnyBDDgEtP+xp4zyaCSOUTJgaO
         Y7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QPVsSzauonGoSZqoD8d7kSBM/msp74JsZg4mWGaLQZg=;
        b=AIu6EHcWMUpcfm1lA2XkJ7z+vq20VC81zyb14T0WrbAkbUtjp12i/AQQaZlUckVwnq
         HZn0OmLKU38YCyLSw84cj0iGNHohXUqzYiXQ2M0S8qStepeSlSS52M6seE2lYrX4Jr67
         vJHFp9z/kzaJi21uzrpCV/GJmCDxI21w4v1X1L7xSh/FMrwWddEMZuQaANzR50u7p8gJ
         kQknXAffO+A7EjDXWhXTqYvJSPGmaW4+Yxu1yZDAGTMLzm6e7/UeIrQj6xMjdZr4pB/f
         CGZPlZjrZa+2quYtJ/5Q6q9hhLAA9Mk6yb8thuch8ivLTCdBZmUrZGk89X4KPnp8iBo8
         zDug==
X-Gm-Message-State: APjAAAVedLgyBiFfRHsOWt/Dm/D9wEyXUuvVIKDG0QDwMPZeE1yMMKJX
        2e9wD0fye+nwN5jRTxnHPY3RVBPV
X-Google-Smtp-Source: APXvYqw4IjL0d/9Z3bAS0w2SV0klKewclAkubM0VLceRFUmMEr5td0bfEhinexjveugTPCN1l2d9aQ==
X-Received: by 2002:a63:33ca:: with SMTP id z193mr13199472pgz.83.1572844593337;
        Sun, 03 Nov 2019 21:16:33 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y1sm15238065pfq.138.2019.11.03.21.16.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Nov 2019 21:16:32 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     stable@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, sashal@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH linux-4.14.y 0/2] sctp: fix a memory leak
Date:   Mon,  4 Nov 2019 13:16:24 +0800
Message-Id: <cover.1572844054.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These 2 patches are missed in linux-4.14.y, it will cause crash
when commit 63dfb7938b13 ("sctp: change sctp_prot .no_autobind
with true") is backported only.

Conflicts:
  - Context difference in Patch 1/2 due to the lack of
    Commit c981f254cc82.

Xin Long (2):
  sctp: fix the issue that flags are ignored when using kernel_connect
  sctp: not bind the socket in sctp_connect

 include/net/sctp/sctp.h |  2 ++
 net/sctp/ipv6.c         |  2 +-
 net/sctp/protocol.c     |  2 +-
 net/sctp/socket.c       | 55 ++++++++++++++++++++++++++-----------------------
 4 files changed, 33 insertions(+), 28 deletions(-)

-- 
2.1.0

